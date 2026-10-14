
const pool = require('../config/db');

const PAKDATAHUB_URL = 'https://api.pakdatahub.com/v1/agri/latest';

async function getRates(req, res) {
  try {
    const { city, commodity } = req.query;

    // Try live API data first when a key is configured.
    if (process.env.PAKDATAHUB_API_KEY) {
      try {
        const market = (city || 'Lahore').trim().toLowerCase();

        const url = new URL(PAKDATAHUB_URL);
        url.searchParams.set('market', market);

        const response = await fetch(url, {
          headers: {
            'X-API-Key': process.env.PAKDATAHUB_API_KEY,
          },
          signal: AbortSignal.timeout(10000),
        });

        if (response.ok) {
          const payload = await response.json();

          if (payload.success && Array.isArray(payload.data)) {
            let rates = payload.data
              .filter((item) => item.min != null && item.max != null)
              .map((item) => ({
                id: `pakdatahub-${item.commodity_id}-${item.date}`,
                rate_date: item.date,
                min_price: item.min,
                max_price: item.max,
                unit: item.unit,
                source_reference: 'PakDataHub API',
                commodity_name: item.commodity,
                commodity_category: 'Other',
                city_name: item.market || payload.market?.name || market,
                province: null,
                market_name: item.market || payload.market?.name || market,
                source_name: 'PakDataHub API',
                source_type: 'external_api',
                fqp: item.fqp,
                quantity: item.quantity,
              }));

            if (commodity) {
              rates = rates.filter((item) =>
                item.commodity_name
                  .toLowerCase()
                  .includes(commodity.trim().toLowerCase())
              );
            }

            return res.json({
              status: 'success',
              count: rates.length,
              rates,
              data_source: 'PakDataHub API',
            });
          }
        } else {
          console.error('PakDataHub returned HTTP', response.status);
        }
      } catch (apiError) {
        console.error('PakDataHub request failed:', apiError.message);
      }
    }

    // Fallback to the existing PostgreSQL rates.
    const conditions = [];
    const values = [];

    if (city) {
      values.push(city.trim());
      conditions.push(`ci.name ILIKE $${values.length}`);
    }

    if (commodity) {
      values.push(`%${commodity.trim()}%`);
      conditions.push(`c.name ILIKE $${values.length}`);
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

    return res.json({
      status: 'success',
      count: result.rows.length,
      rates: result.rows,
      data_source: 'PostgreSQL',
    });
  } catch (error) {
    console.error('Failed to fetch rates:', error.message);

    return res.status(500).json({
      status: 'error',
      message: 'Unable to fetch mandi rates',
    });
  }
}

module.exports = { getRates };
