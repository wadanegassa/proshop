const Cart = require('../models/cartModel');
const Product = require('../models/productModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

exports.getCart = catchAsync(async (req, res, next) => {
    let cart = await Cart.findOne({ user: req.user._id }).populate('items.product', 'name price images');

    if (!cart) {
        cart = await Cart.create({ user: req.user._id, items: [] });
    }

    res.status(200).json({
        success: true,
        data: cart
    });
});

exports.addToCart = catchAsync(async (req, res, next) => {
    const { productId, quantity } = req.body;
    const qty = parseInt(quantity) || 1;

    let cart = await Cart.findOne({ user: req.user._id });

    if (!cart) {
        cart = await Cart.create({ user: req.user._id, items: [] });
    }

    // Check if product exists
    const product = await Product.findById(productId);
    if (!product) {
        return next(new AppError('Product not found', 404));
    }

    // Check if item already exists in cart
    const itemIndex = cart.items.findIndex(p => p.product.toString() === productId);

    if (itemIndex > -1) {
        // Product exists in cart, update quantity
        cart.items[itemIndex].quantity += qty;
    } else {
        // Product does not exist in cart, add new item
        cart.items.push({ product: productId, quantity: qty });
    }

    await cart.save();
    await cart.populate('items.product', 'name price images');

    res.status(200).json({
        success: true,
        data: cart
    });
});

exports.removeFromCart = catchAsync(async (req, res, next) => {
    const { productId } = req.params;

    let cart = await Cart.findOne({ user: req.user._id });

    if (!cart) {
        return next(new AppError('No cart found', 404));
    }

    cart.items = cart.items.filter(item => item.product.toString() !== productId);

    await cart.save();
    await cart.populate('items.product', 'name price images');

    res.status(200).json({
        success: true,
        data: cart
    });
});

exports.syncCart = catchAsync(async (req, res, next) => {
    const { items } = req.body;

    let cart = await Cart.findOne({ user: req.user._id });

    if (!cart) {
        cart = await Cart.create({ user: req.user._id, items: [] });
    }

    cart.items = items.map(item => ({
        product: item.product,
        quantity: item.quantity
    }));

    await cart.save();
    await cart.populate('items.product', 'name price images');

    res.status(200).json({
        success: true,
        data: cart
    });
});

exports.clearCart = catchAsync(async (req, res, next) => {
    let cart = await Cart.findOne({ user: req.user._id });
    if (cart) {
        cart.items = [];
        await cart.save();
    }

    res.status(204).json({
        success: true,
        data: null
    });
});
