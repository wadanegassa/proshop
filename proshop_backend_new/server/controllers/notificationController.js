const Notification = require('../models/notificationModel');
const catchAsync = require('../middleware/asyncHandler');

exports.getNotifications = catchAsync(async (req, res, next) => {
    const notifications = await Notification.find({ user: req.user._id }).sort('-createdAt').limit(20);
    res.status(200).json({
        success: true,
        data: { notifications }
    });
});

exports.adminGetAllNotifications = catchAsync(async (req, res, next) => {
    const notifications = await Notification.find({})
        .populate('user', 'name email')
        .sort('-createdAt')
        .limit(100);

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

exports.deleteSelected = catchAsync(async (req, res, next) => {
    const { ids } = req.body;
    if (!ids || !Array.isArray(ids)) {
        return next(new AppError('Please provide an array of notification IDs', 400));
    }

    await Notification.deleteMany({
        _id: { $in: ids },
        user: req.user._id
    });

    res.status(200).json({
        success: true,
        message: 'Selected notifications deleted'
    });
});
