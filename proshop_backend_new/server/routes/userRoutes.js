const express = require('express');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');

const userController = require('../controllers/userController');

const router = express.Router();

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/admin/login', authController.adminLogin);

router.get('/me', authMiddleware.protect, authController.getMe);

// Admin Routes
router.get('/', authMiddleware.protect, authMiddleware.restrictTo('admin'), userController.getAllUsers);
router.delete('/:id', authMiddleware.protect, authMiddleware.restrictTo('admin'), userController.deleteUser);

module.exports = router;
