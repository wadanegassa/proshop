const express = require('express');
const categoryController = require('../controllers/categoryController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router
    .route('/')
    .get(categoryController.getAllCategories)
    .post(
        authMiddleware.protect,
        authMiddleware.restrictTo('admin'),
        categoryController.createCategory
    );

router
    .route('/:id')
    .patch(
        authMiddleware.protect,
        authMiddleware.restrictTo('admin'),
        categoryController.updateCategory
    )
    .delete(
        authMiddleware.protect,
        authMiddleware.restrictTo('admin'),
        categoryController.deleteCategory
    );

module.exports = router;
