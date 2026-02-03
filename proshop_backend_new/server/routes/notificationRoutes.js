const express = require('express');
const notificationController = require('../controllers/notificationController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware.protect);
// router.use(authMiddleware.restrictTo('admin')); 
// Notifications are for all users

router.get('/', notificationController.getNotifications);
router.get('/admin', authMiddleware.restrictTo('admin'), notificationController.adminGetAllNotifications);
router.patch('/:id/read', notificationController.markAsRead);
router.patch('/read-all', notificationController.markAllAsRead);
router.delete('/clear', notificationController.clearAll);
router.delete('/delete-multiple', notificationController.deleteSelected);
router.delete('/:id', notificationController.deleteNotification);

module.exports = router;
