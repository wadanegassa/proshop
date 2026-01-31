const Settings = require('../models/settingsModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

// @desc    Get global settings
// @route   GET /api/v1/settings
// @access  Public
exports.getSettings = catchAsync(async (req, res, next) => {
    let settings = await Settings.findOne();

    if (!settings) {
        settings = await Settings.create({}); // Create default if not exists
    }

    res.status(200).json({
        success: true,
        data: settings
    });
});

// @desc    Update global settings
// @route   PUT /api/v1/settings
// @access  Private/Admin
exports.updateSettings = catchAsync(async (req, res, next) => {
    let settings = await Settings.findOne();

    if (!settings) {
        settings = await Settings.create({});
    }

    settings.taxRate = req.body.taxRate !== undefined ? req.body.taxRate : settings.taxRate;
    settings.shippingFee = req.body.shippingFee !== undefined ? req.body.shippingFee : settings.shippingFee;
    settings.globalDiscount = req.body.globalDiscount !== undefined ? req.body.globalDiscount : settings.globalDiscount;
    settings.supportEmail = req.body.supportEmail || settings.supportEmail;
    settings.supportPhone = req.body.supportPhone || settings.supportPhone;
    settings.updatedAt = Date.now();

    const updatedSettings = await settings.save();

    res.status(200).json({
        success: true,
        data: updatedSettings
    });
});
