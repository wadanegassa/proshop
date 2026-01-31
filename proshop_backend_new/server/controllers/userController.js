const User = require('../models/userModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

exports.getAllUsers = catchAsync(async (req, res, next) => {
    const users = await User.find();

    res.status(200).json({
        success: true,
        results: users.length,
        data: {
            users
        }
    });
});

exports.getUser = catchAsync(async (req, res, next) => {
    const user = await User.findById(req.params.id);

    if (!user) {
        return next(new AppError('No user found with that ID', 404));
    }

    res.status(200).json({
        success: true,
        data: {
            user
        }
    });
});

exports.deleteUser = catchAsync(async (req, res, next) => {
    const user = await User.findByIdAndDelete(req.params.id);

    if (!user) {
        return next(new AppError('No user found with that ID', 404));
    }

    res.status(200).json({
        success: true,
        data: null
    });
});

exports.getWishlist = catchAsync(async (req, res, next) => {
    const user = await User.findById(req.user.id).populate('wishlist');

    res.status(200).json({
        success: true,
        data: user.wishlist
    });
});

exports.addToWishlist = catchAsync(async (req, res, next) => {
    const user = await User.findById(req.user.id);
    const productId = req.params.id;

    if (!user.wishlist.includes(productId)) {
        user.wishlist.push(productId);
        await user.save({ validateBeforeSave: false }); // Skip password validation
    }

    res.status(200).json({
        success: true,
        data: user.wishlist
    });
});

exports.removeFromWishlist = catchAsync(async (req, res, next) => {
    const user = await User.findById(req.user.id);
    const productId = req.params.id;

    user.wishlist = user.wishlist.filter(id => id.toString() !== productId);
    await user.save({ validateBeforeSave: false });

    res.status(200).json({
        success: true,
        data: user.wishlist
    });
});
