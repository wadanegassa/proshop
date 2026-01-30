const express = require('express');
const cartController = require('../controllers/cartController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware.protect);

router
    .route('/')
    .get(cartController.getCart)
    .post(cartController.syncCart)
    .delete(cartController.clearCart);

router.route('/:productId').delete(cartController.removeFromCart);

module.exports = router;
