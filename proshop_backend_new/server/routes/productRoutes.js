const express = require('express');
const productController = require('../controllers/productController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/', productController.getAllProducts);
router.get('/:id', productController.getProduct);

// Protected Routes
router.use(authMiddleware.protect);

router.post('/:id/reviews', productController.createProductReview);

// Admin Only Routes
router.use(authMiddleware.restrictTo('admin'));
router.post('/', productController.createProduct)
router.patch('/:id', productController.updateProduct);
router.delete('/:id', productController.deleteProduct);
router.delete('/:id/reviews/:reviewId', productController.deleteProductReview);

module.exports = router;
