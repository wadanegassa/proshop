const Order = require('../models/orderModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');
const Notification = require('../models/notificationModel');

exports.addOrderItems = catchAsync(async (req, res, next) => {
    const {
        orderItems,
        shippingAddress,
        paymentMethod,
        itemsPrice,
        taxPrice,
        shippingPrice,
        totalPrice
    } = req.body;

    if (orderItems && orderItems.length === 0) {
        return next(new AppError('No order items', 400));
    }

    const order = new Order({
        orderItems,
        user: req.user._id,
        shippingAddress,
        paymentMethod,
        itemsPrice,
        taxPrice,
        shippingPrice,
        totalPrice
    });

    const createdOrder = await order.save();

    // Create Notification
    try {
        await Notification.create({
            title: 'New Order Received',
            message: `Order #${createdOrder._id.toString().substring(0, 6)} placed by ${req.user.name}`,
            type: 'order'
        });
    } catch (err) {
        console.error('Notification Error:', err.message);
    }

    res.status(201).json({
        success: true,
        data: createdOrder
    });
});

exports.getOrderById = catchAsync(async (req, res, next) => {
    const order = await Order.findById(req.params.id).populate('user', 'name email');
    if (!order) return next(new AppError('Order not found', 404));

    if (req.user.role !== 'admin' && order.user._id.toString() !== req.user._id.toString()) {
        return next(new AppError('Not authorized', 403));
    }

    res.status(200).json({
        success: true,
        data: order
    });
});

exports.getOrders = catchAsync(async (req, res, next) => {
    const orders = await Order.find({}).populate('user', 'id name').sort('-createdAt');
    res.status(200).json({
        success: true,
        data: { orders }
    });
});

exports.updateOrderStatus = catchAsync(async (req, res, next) => {
    const order = await Order.findById(req.params.id);
    if (!order) return next(new AppError('Order not found', 404));

    order.status = req.body.status || order.status;
    if (req.body.status === 'delivered') {
        order.isDelivered = true;
        order.deliveredAt = Date.now();
    }

    const updatedOrder = await order.save();
    res.status(200).json({
        success: true,
        data: updatedOrder
    });
});

exports.getMyOrders = catchAsync(async (req, res, next) => {
    const orders = await Order.find({ user: req.user._id }).sort('-createdAt');
    res.status(200).json({
        success: true,
        data: { orders }
    });
});
