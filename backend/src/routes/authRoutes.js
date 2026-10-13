
const express = require('express');
const rateLimit = require('express-rate-limit');

const {
  register,
  login,
  getMe,
} = require('../controllers/authController');

const authenticateToken = require('../middleware/authMiddleware');

const router = express.Router();

// Limit repeated login attempts from the same IP address.
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  limit: 10, // Maximum 10 attempts per window
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  message: {
    status: 'error',
    message: 'Too many login attempts. Please try again in 15 minutes.',
  },
});

router.post('/register', register);
router.post('/login', loginLimiter, login);
router.get('/me', authenticateToken, getMe);

module.exports = router;
