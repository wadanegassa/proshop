const Category = require('../models/categoryModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

exports.getAllCategories = catchAsync(async (req, res, next) => {
    const categories = await Category.find({ isActive: true });

    res.status(200).json({
        success: true,
        count: categories.length,
        data: {
            categories
        }
    });
});

exports.createCategory = catchAsync(async (req, res, next) => {
    const newCategory = await Category.create(req.body);

    res.status(201).json({
        success: true,
        data: {
            category: newCategory
        }
    });
});

exports.updateCategory = catchAsync(async (req, res, next) => {
    const category = await Category.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
        runValidators: true
    });

    if (!category) {
        return next(new AppError('No category found with that ID', 404));
    }

    res.status(200).json({
        success: true,
        data: {
            category
        }
    });
});

exports.deleteCategory = catchAsync(async (req, res, next) => {
    const category = await Category.findByIdAndDelete(req.params.id);

    if (!category) {
        return next(new AppError('No category found with that ID', 404));
    }

    res.status(204).json({
        success: true,
        data: null
    });
});
