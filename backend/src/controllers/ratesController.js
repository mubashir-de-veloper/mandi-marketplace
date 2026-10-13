
const pool = require('../config/db');

async function getRates(req, res) {
  try {
    const { city, commodity } = req.query;
    const conditions = [];
    const values = [];

    if (city) {
      values.push(city.trim());
      conditions.push(
        `ci.name ILIKE $${values.length}`
      );
    }

    if (commodity) {
      values.push(commodity.trim());
      conditions.push(
        `c.name ILIKE $${values.length}`
      );
    }

    let query = `
      SELECT
        r.id,
        r.rate_date,
        r.min_price,
        r.max_price,
        r.unit,
        r.source_reference,
        c.name AS commodity_name,
        c.category AS commodity_category,
        ci.name AS city_name,
        ci.province,
        m.name AS market_name,
        ds.name AS source_name,
        ds.source_type
      FROM official_rates r
      LEFT JOIN commodities c ON r.commodity_id = c.id
      LEFT JOIN markets m ON r.market_id = m.id
      LEFT JOIN cities ci ON m.city_id = ci.id
      LEFT JOIN data_sources ds ON r.source_id = ds.id
    `;

    if (conditions.length > 0) {
      query += ` WHERE ${conditions.join(' AND ')}`;
    }

    query += `
      ORDER BY r.rate_date DESC, r.id DESC
      LIMIT 100
    `;

    const result = await pool.query(query, values);

    res.json({
      status: 'success',
      count: result.rows.length,
      rates: result.rows,
    });
  } catch (error) {
    console.error('Failed to fetch rates:', error.message);

    res.status(500).json({
      status: 'error',
      message: 'Unable to fetch mandi rates',
    });
  }
}

module.exports = { getRates };
