
const pool = require('../config/db');

async function getListings(req, res) {
  try {
    const query = `
      SELECT
        l.id,
        l.title,
        l.description,
        l.quantity,
        l.unit,
        l.asking_price,
        l.status,
        l.created_at,
        c.name AS commodity_name,
        c.category AS commodity_category,
        ci.name AS city_name,
        ci.province,
        m.name AS market_name
      FROM listings l
      LEFT JOIN commodities c ON l.commodity_id = c.id
      LEFT JOIN cities ci ON l.city_id = ci.id
      LEFT JOIN markets m ON l.market_id = m.id
      ORDER BY l.created_at DESC NULLS LAST, l.id DESC
      LIMIT 100
    `;

    const result = await pool.query(query);

    res.json({
      status: 'success',
      count: result.rows.length,
      listings: result.rows,
    });
  } catch (error) {
    console.error('Failed to fetch listings:', error.message);

    res.status(500).json({
      status: 'error',
      message: 'Unable to fetch marketplace listings',
    });
  }
}

module.exports = { getListings };
