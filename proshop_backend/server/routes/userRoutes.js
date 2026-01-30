const express = require('express');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/admin/login', authController.adminLogin);

// Protect all routes after this middleware
router.use(authMiddleware.protect);

router.get('/me', authController.getMe);
// Admin only routes
router.use(authMiddleware.restrictTo('admin'));
router.get('/', authController.getUsers);
router.patch('/:id/block', authController.blockUser);
router.patch('/:id/unblock', authController.unblockUser);

module.exports = router;
