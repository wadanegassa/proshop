const Notification = require('../models/notificationModel');
const catchAsync = require('../middleware/asyncHandler');

exports.getNotifications = catchAsync(async (req, res, next) => {
    const notifications = await Notification.find({ user: req.user._id }).sort('-createdAt').limit(20);
    res.status(200).json({
        success: true,
        data: { notifications }
    });
});

exports.markAsRead = catchAsync(async (req, res, next) => {
    await Notification.findOneAndUpdate(
        { _id: req.params.id, user: req.user._id },
        { read: true }
    );
    res.status(200).json({ success: true });
});

exports.markAllAsRead = catchAsync(async (req, res, next) => {
    await Notification.updateMany({ user: req.user._id, read: false }, { read: true });
    res.status(200).json({ success: true });
});

exports.clearAll = catchAsync(async (req, res, next) => {
    await Notification.deleteMany({ user: req.user._id });
    res.status(200).json({ success: true });
});

exports.deleteNotification = catchAsync(async (req, res, next) => {
    await Notification.findOneAndDelete({ _id: req.params.id, user: req.user._id });
    res.status(200).json({ success: true });
});
