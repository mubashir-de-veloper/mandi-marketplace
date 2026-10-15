
require('dotenv').config();

const express = require('express');
const cors = require('cors');
const pool = require('./config/db');
const listingsRoutes = require('./routes/listingsRoutes');
const ratesRoutes = require('./routes/ratesRoutes');
const priceReportsRoutes = require('./routes/priceReportsRoutes');
const authRoutes = require('./routes/authRoutes');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Basic welcome route
app.get('/', (req, res) => {
  res.json({
    message: 'Mandi Marketplace API is running!',
    status: 'success',
  });
});

// Health-check route
app.get('/api/health', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT current_database() AS database_name'
    );

    res.json({
      status: 'healthy',
      database: result.rows[0].database_name,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Health check failed:', error.message);

    res.status(500).json({
      status: 'error',
      message: 'Database connection failed',
    });
  }
});

app.use('/api/listings', listingsRoutes);
app.use('/api/rates', ratesRoutes);
app.use('/api/price-reports', priceReportsRoutes);
app.use('/api/auth', authRoutes);
app.use((req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'API endpoint not found',
    path: req.originalUrl,
  });
});



if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Mandi Marketplace API running on port ${PORT}`);
  });
}

module.exports = app;
