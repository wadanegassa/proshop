const Cart = require('../models/cartModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

exports.getCart = catchAsync(async (req, res, next) => {
    let cart = await Cart.findOne({ user: req.user._id }).populate('items.product');

    if (!cart) {
        cart = await Cart.create({ user: req.user._id, items: [] });
    }

    res.status(200).json({
        success: true,
        data: cart
    });
});

exports.syncCart = catchAsync(async (req, res, next) => {
    const { items } = req.body;

    let cart = await Cart.findOne({ user: req.user._id });

    if (!cart) {
        cart = await Cart.create({
            user: req.user._id,
            items: items || []
        });
    } else {
        cart.items = items || [];
        cart.updatedAt = Date.now();
        await cart.save();
    }

    res.status(200).json({
        success: true,
        data: cart
    });
});
