const express = require('express');
const orderController = require('../controllers/orderController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware.protect);

router.post('/', orderController.addOrderItems);
router.get('/myorders', orderController.getMyOrders);
router.get('/:id', orderController.getOrderById);

// Admin Only
router.get('/', authMiddleware.restrictTo('admin'), orderController.getOrders);
router.patch('/:id/status', authMiddleware.restrictTo('admin'), orderController.updateOrderStatus);

module.exports = router;
