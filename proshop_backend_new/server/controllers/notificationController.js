const Notification = require('../models/notificationModel');
const catchAsync = require('../middleware/asyncHandler');

exports.getNotifications = catchAsync(async (req, res, next) => {
    const notifications = await Notification.find().sort('-createdAt').limit(20);
    res.status(200).json({
        success: true,
        data: { notifications }
    });
});

exports.markAsRead = catchAsync(async (req, res, next) => {
    await Notification.findByIdAndUpdate(req.params.id, { read: true });
    res.status(200).json({ success: true });
});

exports.markAllAsRead = catchAsync(async (req, res, next) => {
    await Notification.updateMany({ read: false }, { read: true });
    res.status(200).json({ success: true });
});

exports.clearAll = catchAsync(async (req, res, next) => {
    await Notification.deleteMany({});
    res.status(200).json({ success: true });
});
