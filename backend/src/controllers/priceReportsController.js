
const pool = require('../config/db');

async function getPriceReports(req, res) {
  try {
    const { city, commodity } = req.query;
    const conditions = [];
    const values = [];

    if (city) {
      values.push(city.trim());
      conditions.push(`ci.name ILIKE $${values.length}`);
    }

    if (commodity) {
      values.push(commodity.trim());
      conditions.push(`c.name ILIKE $${values.length}`);
    }

    const query = `
      SELECT
        pr.id,
        pr.reported_price,
        pr.unit,
        pr.observed_at,
        pr.notes,
        pr.verification_status,
        c.name AS commodity_name,
        ci.name AS city_name,
        ci.province,
        m.name AS market_name
      FROM price_reports pr
      LEFT JOIN commodities c ON pr.commodity_id = c.id
      LEFT JOIN cities ci ON pr.city_id = ci.id
      LEFT JOIN markets m ON pr.market_id = m.id
      ${conditions.length ? `WHERE ${conditions.join(' AND ')}` : ''}
      ORDER BY pr.observed_at DESC NULLS LAST, pr.id DESC
      LIMIT 100
    `;

    const result = await pool.query(query, values);

    res.json({
      status: 'success',
      count: result.rows.length,
      reports: result.rows,
    });
  } catch (error) {
    console.error('Failed to fetch price reports:', error.message);

    res.status(500).json({
      status: 'error',
      message: 'Unable to fetch street-price reports',
    });
  }
}


async function createPriceReport(req, res) {
  try {
    const {
      city_id,
      commodity_id,
      market_id,
      reported_price,
      unit,
      observed_at,
      notes,
    } = req.body;

    // Validate required fields
    if (
      city_id == null ||
      commodity_id == null ||
      reported_price == null ||
      unit == null
    ) {
      return res.status(400).json({
        status: 'error',
        message: 'city_id, commodity_id, reported_price, and unit are required',
      });
    }

    // Validate IDs
    const cityId = Number(city_id);
    const commodityId = Number(commodity_id);
    const marketId =
      market_id == null || market_id === '' ? null : Number(market_id);

    if (
      !Number.isSafeInteger(cityId) || cityId <= 0 ||
      !Number.isSafeInteger(commodityId) || commodityId <= 0 ||
      (marketId !== null &&
        (!Number.isSafeInteger(marketId) || marketId <= 0))
    ) {
      return res.status(400).json({
        status: 'error',
        message: 'City, commodity, and market IDs must be valid positive integers',
      });
    }

    // Validate price
    const price = Number(reported_price);

    if (!Number.isFinite(price) || price < 0) {
      return res.status(400).json({
        status: 'error',
        message: 'reported_price must be a valid non-negative number',
      });
    }

    // Validate unit
    if (typeof unit !== 'string' || !unit.trim() || unit.trim().length > 50) {
      return res.status(400).json({
        status: 'error',
        message: 'unit must be a non-empty string of at most 50 characters',
      });
    }

    // Validate optional notes
    if (
      notes != null &&
      (typeof notes !== 'string' || notes.length > 2000)
    ) {
      return res.status(400).json({
        status: 'error',
        message: 'notes must be text of at most 2000 characters',
      });
    }

    // Validate optional observation date
    let observedAt = null;

    if (observed_at != null && observed_at !== '') {
      if (
        typeof observed_at !== 'string' ||
        Number.isNaN(Date.parse(observed_at))
      ) {
        return res.status(400).json({
          status: 'error',
          message: 'observed_at must be a valid date/time',
        });
      }

      observedAt = new Date(observed_at);
    }

    
    const query = `
      INSERT INTO price_reports (
        user_id,
        city_id,
        commodity_id,
        market_id,
        reported_price,
        unit,
        observed_at,
        notes
      )
      VALUES ($1, $2, $3, $4, $5, $6, COALESCE($7, NOW()), $8)
      RETURNING
        id,
        user_id,
        city_id,
        commodity_id,
        market_id,
        reported_price,
        unit,
        observed_at,
        notes,
        verification_status,
        created_at
    `;

    const result = await pool.query(query, [
      req.auth.userId,
      cityId,
      commodityId,
      marketId,
      price,
      unit.trim(),
      observedAt,
      notes?.trim() || null,
    ]);


    return res.status(201).json({
      status: 'success',
      message: 'Price report submitted for verification',
      report: result.rows[0],
    });
  } catch (error) {
    console.error('Failed to create price report:', error.message);

    if (error.code === '23503') {
      return res.status(400).json({
        status: 'error',
        message: 'The selected city, commodity, or market does not exist',
      });
    }

    return res.status(500).json({
      status: 'error',
      message: 'Unable to submit price report',
    });
  }
}

module.exports = { getPriceReports, createPriceReport };
