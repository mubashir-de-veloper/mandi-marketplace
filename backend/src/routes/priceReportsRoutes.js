
const express = require('express');

const {
  getPriceReports,
  createPriceReport,
} = require('../controllers/priceReportsController');

const authenticateToken = require('../middleware/authMiddleware');

const router = express.Router();

// Public: anyone can view reports.
router.get('/', getPriceReports);

// Protected: only authenticated users can submit reports.
router.post('/', authenticateToken, createPriceReport);

module.exports = router;
