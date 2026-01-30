const jwt = require('jsonwebtoken');
const User = require('../models/userModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');
const env = require('../config/env');

const signToken = id => {
    return jwt.sign({ id }, env.JWT_SECRET, {
        expiresIn: env.JWT_EXPIRES_IN
    });
};

const createSendToken = (user, statusCode, res) => {
    const token = signToken(user._id);

    user.password = undefined; // Remove password from output

    res.status(statusCode).json({
        success: true,
        token,
        data: {
            user
        }
    });
};

exports.register = catchAsync(async (req, res, next) => {
    const newUser = await User.create({
        name: req.body.name,
        email: req.body.email,
        password: req.body.password,
        role: 'user' // Default to user, admin creation should be manual or seeded
    });

    createSendToken(newUser, 201, res);
});

exports.login = catchAsync(async (req, res, next) => {
    const { email, password } = req.body;

    // 1) Check if email and password exist
    if (!email || !password) {
        return next(new AppError('Please provide email and password!', 400));
    }

    // 2) Check if user exists && password is correct
    const user = await User.findOne({ email }).select('+password');

    if (!user || !(await user.correctPassword(password, user.password))) {
        return next(new AppError('Incorrect email or password', 401));
    }

    // 3) Check if user is blocked
    if (user.isBlocked) {
        return next(new AppError('Your account has been blocked. Please contact support.', 403));
    }

    // 4) If everything ok, send token to client
    createSendToken(user, 200, res);
});

exports.adminLogin = catchAsync(async (req, res, next) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return next(new AppError('Please provide email and password!', 400));
    }

    const user = await User.findOne({ email }).select('+password');

    if (!user || !(await user.correctPassword(password, user.password))) {
        return next(new AppError('Incorrect email or password', 401));
    }

    if (user.role !== 'admin') {
        return next(new AppError('Access denied. Admin only.', 403));
    }

    if (user.isBlocked) {
        return next(new AppError('Your account has been blocked.', 403));
    }

    createSendToken(user, 200, res);
});

exports.getMe = catchAsync(async (req, res, next) => {
    const user = await User.findById(req.user.id);
    res.status(200).json({
        success: true,
        data: {
            user
        }
    });
});

exports.getUsers = catchAsync(async (req, res, next) => {
    const users = await User.find({ role: 'user' }).sort('-createdAt');
    res.status(200).json({
        success: true,
        data: {
            users
        }
    });
});

exports.blockUser = catchAsync(async (req, res, next) => {
    const user = await User.findByIdAndUpdate(req.params.id, { isBlocked: true }, { new: true });
    if (!user) return next(new AppError('User not found', 404));

    res.status(200).json({
        success: true,
        data: { user }
    });
});

exports.unblockUser = catchAsync(async (req, res, next) => {
    const user = await User.findByIdAndUpdate(req.params.id, { isBlocked: false }, { new: true });
    if (!user) return next(new AppError('User not found', 404));

    res.status(200).json({
        success: true,
        data: { user }
    });
});
