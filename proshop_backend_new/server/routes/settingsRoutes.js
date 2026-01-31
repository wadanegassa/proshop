const express = require('express');
const router = express.Router();
const settingsController = require('../controllers/settingsController');
const authMiddleware = require('../middleware/authMiddleware');

router.get('/', settingsController.getSettings);
router.put('/', authMiddleware.protect, authMiddleware.restrictTo('admin'), settingsController.updateSettings);

module.exports = router;
