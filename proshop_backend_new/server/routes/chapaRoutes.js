const express = require('express');
const chapaController = require('../controllers/chapaController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/initialize/:orderId', protect, chapaController.initializeChapaTransaction);
router.get('/verify/:tx_ref', chapaController.verifyChapaPayment);

module.exports = router;
