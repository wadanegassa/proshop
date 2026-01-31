const Order = require('../models/orderModel');
const Notification = require('../models/notificationModel');
const User = require('../models/userModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

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
    console.log('Order Created:', createdOrder._id);

    // Create Notification
    // Create Notification for all Admins
    try {
        const admins = await User.find({ role: 'admin' });

        if (admins.length > 0) {
            const notifications = admins.map(admin => ({
                title: 'New Order Received',
                message: `Order #${createdOrder._id.toString().substring(0, 6).toUpperCase()} placed by ${req.user.name}`,
                type: 'order',
                user: admin._id,
                createdAt: Date.now()
            }));

            await Notification.insertMany(notifications);
        }
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

    // Create Notification
    try {
        await Notification.create({
            title: `Order Updated: ${req.body.status}`,
            message: `Your order #${order._id} status has been updated to ${req.body.status}`,
            type: 'order',
            user: order.user
        });
    } catch (error) {
        console.error('Notification creation failed:', error);
    }

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

exports.updateOrderToPaid = catchAsync(async (req, res, next) => {
    console.log('Update To Paid Request:', req.params.id);
    console.log('Request Body:', req.body);

    let order;
    try {
        order = await Order.findById(req.params.id);
    } catch (err) {
        return next(new AppError('Invalid Order ID format', 400));
    }

    if (order) {
        // Double check user authorization if not admin
        if (req.user.role !== 'admin' && order.user.toString() !== req.user._id.toString()) {
            return next(new AppError('Not authorized to pay for this order', 403));
        }

        order.isPaid = true;
        order.paidAt = Date.now();
        order.paymentResult = {
            id: req.body.id,
            status: req.body.status,
            update_time: req.body.update_time,
            email_address: req.body.payer?.email_address || '',
        };

        const updatedOrder = await order.save();

        // Create Notification
        try {
            await Notification.create({
                title: 'Payment Successful',
                message: `Payment for order #${order._id} has been confirmed.`,
                type: 'order',
                user: order.user
            });
        } catch (error) {
            console.error('Notification creation failed:', error);
        }

        res.status(200).json({
            success: true,
            data: updatedOrder
        });
    } else {
        return next(new AppError('Order not found', 404));
    }
});

exports.deleteOrder = catchAsync(async (req, res, next) => {
    const order = await Order.findById(req.params.id);

    if (!order) {
        return next(new AppError('Order not found', 404));
    }

    // Admin can delete any order, regular users can only delete unpaid orders
    if (req.user.role !== 'admin' && order.isPaid) {
        return next(new AppError('Cannot delete a paid order', 400));
    }

    // Delete the order completely from database
    await Order.findByIdAndDelete(req.params.id);

    // Also delete related notifications for this order
    try {
        await Notification.deleteMany({
            message: { $regex: order._id.toString() }
        });
    } catch (error) {
        console.error('Failed to delete related notifications:', error);
    }

    console.log(`Order ${req.params.id} permanently deleted by admin`);

    res.status(200).json({
        success: true,
        message: 'Order permanently deleted'
    });
});

exports.getPaypalClientId = catchAsync(async (req, res, next) => {
    res.status(200).json({
        success: true,
        data: process.env.PAYPAL_CLIENT_ID
    });
});
