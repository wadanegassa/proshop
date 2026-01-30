const express = require('express');
const analyticsController = require('../controllers/analyticsController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.get(
    '/',
    authMiddleware.protect,
    authMiddleware.restrictTo('admin'),
    analyticsController.getAnalyticsData
);

module.exports = router;
