const express = require('express');
const stripeController = require('../controllers/stripeController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.use(protect);

router.post('/create-payment-intent', stripeController.createPaymentIntent);
router.get('/config', stripeController.getStripePublishableKey);

module.exports = router;
