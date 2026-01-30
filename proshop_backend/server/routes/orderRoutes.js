const express = require('express');
const orderController = require('../controllers/orderController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware.protect);

router
    .route('/')
    .post(orderController.addOrderItems)
    .get(authMiddleware.restrictTo('admin'), orderController.getOrders);

router.route('/myorders').get(orderController.getMyOrders);

router.route('/:id').get(orderController.getOrderById);

router.route('/:id/pay').put(orderController.updateOrderToPaid);

router
    .route('/:id/deliver')
    .put(authMiddleware.restrictTo('admin'), orderController.updateOrderToDelivered);

router
    .route('/:id/status')
    .put(authMiddleware.restrictTo('admin'), orderController.updateOrderStatus);

module.exports = router;
