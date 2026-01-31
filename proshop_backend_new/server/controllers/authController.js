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
    user.password = undefined;

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
        role: req.body.role || 'user'
    });

    createSendToken(newUser, 201, res);
});

exports.login = catchAsync(async (req, res, next) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return next(new AppError('Please provide email and password!', 400));
    }

    const user = await User.findOne({ email }).select('+password');

    if (!user || !(await user.correctPassword(password, user.password))) {
        return next(new AppError('Incorrect email or password', 401));
    }

    if (user.isBlocked) {
        return next(new AppError('Your account has been blocked.', 403));
    }

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
