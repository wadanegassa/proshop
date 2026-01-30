const Order = require('../models/orderModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

// @desc    Create new order
// @route   POST /api/v1/orders
// @access  Private
exports.addOrderItems = catchAsync(async (req, res, next) => {
    const {
        orderItems,
        shippingAddress,
        paymentMethod,
        itemsPrice,
        taxPrice,
        shippingPrice,
        totalPrice,
    } = req.body;

    if (orderItems && orderItems.length === 0) {
        return next(new AppError('No order items', 400));
    } else {
        const order = new Order({
            orderItems,
            user: req.user._id,
            shippingAddress,
            paymentMethod,
            itemsPrice,
            taxPrice,
            shippingPrice,
            totalPrice,
        });

        const createdOrder = await order.save();

        res.status(201).json({
            success: true,
            data: createdOrder,
        });
    }
});

// @desc    Get order by ID
// @route   GET /api/v1/orders/:id
// @access  Private
exports.getOrderById = catchAsync(async (req, res, next) => {
    const order = await Order.findById(req.params.id).populate(
        'user',
        'name email'
    );

    if (order) {
        // Only admin or the order owner can view
        if (req.user.role !== 'admin' && order.user._id.toString() !== req.user._id.toString()) {
            return next(new AppError('Not authorized to view this order', 403));
        }

        res.status(200).json({
            success: true,
            data: order,
        });
    } else {
        return next(new AppError('Order not found', 404));
    }
});

// @desc    Update order to paid
// @route   PUT /api/v1/orders/:id/pay
// @access  Private
exports.updateOrderToPaid = catchAsync(async (req, res, next) => {
    const order = await Order.findById(req.params.id);

    if (order) {
        order.isPaid = true;
        order.paidAt = Date.now();
        order.paymentResult = {
            id: req.body.id,
            status: req.body.status,
            update_time: req.body.update_time,
            email_address: req.body.email_address,
        };
        order.status = 'processing'; // Update status to processing upon payment

        const updatedOrder = await order.save();

        res.status(200).json({
            success: true,
            data: updatedOrder,
        });
    } else {
        return next(new AppError('Order not found', 404));
    }
});

// @desc    Update order to delivered
// @route   PUT /api/v1/orders/:id/deliver
// @access  Private/Admin
exports.updateOrderToDelivered = catchAsync(async (req, res, next) => {
    const order = await Order.findById(req.params.id);

    if (order) {
        order.isDelivered = true;
        order.deliveredAt = Date.now();
        order.status = 'delivered';

        const updatedOrder = await order.save();

        res.status(200).json({
            success: true,
            data: updatedOrder,
        });
    } else {
        return next(new AppError('Order not found', 404));
    }
});

// @desc    Get logged in user orders
// @route   GET /api/v1/orders/myorders
// @access  Private
exports.getMyOrders = catchAsync(async (req, res, next) => {
    const orders = await Order.find({ user: req.user._id }).sort('-createdAt');

    res.status(200).json({
        success: true,
        count: orders.length,
        data: {
            orders
        },
    });
});

// @desc    Get all orders
// @route   GET /api/v1/orders
// @access  Private/Admin
exports.getOrders = catchAsync(async (req, res, next) => {
    const orders = await Order.find({}).populate('user', 'id name').sort('-createdAt');

    res.status(200).json({
        success: true,
        count: orders.length,
        data: {
            orders
        },
    });
});

// @desc    Update order status
// @route   PUT /api/v1/orders/:id/status
// @access  Private/Admin
exports.updateOrderStatus = catchAsync(async (req, res, next) => {
    const order = await Order.findById(req.params.id);

    if (order) {
        order.status = req.body.status; // pending, processing, shipped, delivered, cancelled
        if (req.body.status === 'delivered') {
            order.isDelivered = true;
            order.deliveredAt = Date.now();
        }

        const updatedOrder = await order.save();
        res.status(200).json({
            success: true,
            data: updatedOrder
        });
    } else {
        return next(new AppError('Order not found', 404));
    }
});
