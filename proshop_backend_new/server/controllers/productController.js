const Product = require('../models/productModel');
const Category = require('../models/categoryModel');
const Notification = require('../models/notificationModel');
const User = require('../models/userModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');
const APIFeatures = require('../utils/apiFeatures');

exports.getAllProducts = catchAsync(async (req, res, next) => {
    const features = new APIFeatures(Product.find().populate('category', 'name'), req.query)
        .filter()
        .sort()
        .limitFields()
        .paginate();

    const products = await features.query;

    res.status(200).json({
        success: true,
        count: products.length,
        data: { products }
    });
});

exports.getProduct = catchAsync(async (req, res, next) => {
    const product = await Product.findById(req.params.id).populate('category', 'name');
    if (!product) return next(new AppError('No product found with that ID', 404));
    res.status(200).json({
        success: true,
        data: { product }
    });
});

exports.createProduct = catchAsync(async (req, res, next) => {
    const newProduct = await Product.create(req.body);
    res.status(201).json({
        success: true,
        data: { product: newProduct }
    });
});

exports.updateProduct = catchAsync(async (req, res, next) => {
    console.log(`Updating Product [${req.params.id}] with body:`, req.body);

    // Find product first to check old discount
    const oldProduct = await Product.findById(req.params.id);
    if (!oldProduct) return next(new AppError('No product found with that ID', 404));

    const product = await Product.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
        runValidators: true
    });

    // Check if discount was increased and is now a "Big Offer" (>= 20%)
    const newDiscount = Number(req.body.discount);
    const prevDiscount = Number(oldProduct.discount || 0);

    if (newDiscount && newDiscount >= 20 && newDiscount > prevDiscount) {
        setImmediate(async () => {
            try {
                const users = await User.find({ role: 'user' });
                if (users.length > 0) {
                    const notifications = users.map(user => ({
                        title: '🔥 Big Offer Alert!',
                        message: `${product.name} is now ${newDiscount}% OFF! Grab it before it's gone.`,
                        type: 'alert',
                        user: user._id,
                        createdAt: Date.now()
                    }));
                    await Notification.insertMany(notifications);
                    console.log(`Sent offer notifications to ${users.length} users`);
                }
            } catch (err) {
                console.error('Offer Notification Error:', err.message);
            }
        });
    }

    res.status(200).json({
        success: true,
        data: { product }
    });
});

exports.deleteProduct = catchAsync(async (req, res, next) => {
    const product = await Product.findByIdAndDelete(req.params.id);
    if (!product) return next(new AppError('No product found with that ID', 404));
    res.status(204).json({
        success: true,
        data: null
    });
});

exports.createProductReview = catchAsync(async (req, res, next) => {
    const { rating, comment } = req.body;

    const product = await Product.findById(req.params.id);

    if (!product) {
        return next(new AppError('Product not found', 404));
    }

    const alreadyReviewed = product.reviews.find(
        (r) => r.user.toString() === req.user._id.toString()
    );

    if (alreadyReviewed) {
        return next(new AppError('Product already reviewed', 400));
    }

    const review = {
        name: req.user.name,
        rating: Number(rating),
        comment,
        user: req.user._id,
    };

    product.reviews.push(review);
    product.numReviews = product.reviews.length;

    // Recalculate average rating
    const totalRating = product.reviews.reduce((acc, item) => item.rating + acc, 0);
    product.rating = Number((totalRating / product.reviews.length).toFixed(1));

    await product.save();
    res.status(201).json({ success: true, message: 'Review added' });
});

exports.deleteProductReview = catchAsync(async (req, res, next) => {
    const product = await Product.findById(req.params.id);

    if (!product) {
        return next(new AppError('Product not found', 404));
    }

    const reviewIndex = product.reviews.findIndex(
        (r) => r._id.toString() === req.params.reviewId.toString()
    );

    if (reviewIndex === -1) {
        return next(new AppError('Review not found', 404));
    }

    product.reviews.splice(reviewIndex, 1);
    product.numReviews = product.reviews.length;

    // Recalculate average rating
    if (product.reviews.length === 0) {
        product.rating = 0;
    } else {
        const totalRating = product.reviews.reduce((acc, item) => item.rating + acc, 0);
        product.rating = (totalRating / product.reviews.length).toFixed(1);
    }

    await product.save();
    res.status(200).json({ success: true, message: 'Review deleted' });
});
