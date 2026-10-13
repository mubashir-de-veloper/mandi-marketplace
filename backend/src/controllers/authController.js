
const pool = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

async function register(req, res) {
  try {
    const {
      full_name,
      email,
      phone,
      password,
      role,
    } = req.body || {};

    // Validate required fields
    if (
      typeof full_name !== 'string' ||
      typeof email !== 'string' ||
      typeof password !== 'string'
    ) {
      return res.status(400).json({
        status: 'error',
        message: 'Full name, email, and password are required',
      });
    }

    const name = full_name.trim();
    const normalizedEmail = email.trim().toLowerCase();

    if (name.length < 2 || name.length > 100) {
      return res.status(400).json({
        status: 'error',
        message: 'Full name must be between 2 and 100 characters',
      });
    }

    // Basic email format validation
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (
      normalizedEmail.length > 254 ||
      !emailPattern.test(normalizedEmail)
    ) {
      return res.status(400).json({
        status: 'error',
        message: 'Please provide a valid email address',
      });
    }

    if (password.length < 8 || password.length > 72) {
      return res.status(400).json({
        status: 'error',
        message: 'Password must be between 8 and 72 characters',
      });
    }

    // Only allow public, non-admin roles
    const allowedRoles = ['buyer', 'farmer', 'wholesaler'];
    const selectedRole = role == null ? 'buyer' : role;

    if (
      typeof selectedRole !== 'string' ||
      !allowedRoles.includes(selectedRole)
    ) {
      return res.status(400).json({
        status: 'error',
        message: 'Role must be buyer, farmer, or wholesaler',
      });
    }

    // Validate optional phone number
    let normalizedPhone = null;

    if (phone != null && phone !== '') {
      if (typeof phone !== 'string' || phone.trim().length > 30) {
        return res.status(400).json({
          status: 'error',
          message: 'Phone must be text of at most 30 characters',
        });
      }

      normalizedPhone = phone.trim();

      if (!normalizedPhone) {
        normalizedPhone = null;
      }
    }

    // Hash the password; never store the plain-text password
    const passwordHash = await bcrypt.hash(password, 12);

    const query = `
      INSERT INTO users (
        full_name,
        email,
        phone,
        password_hash,
        role
      )
      VALUES ($1, $2, $3, $4, $5)
      RETURNING
        id,
        full_name,
        email,
        phone,
        role,
        created_at
    `;

    const result = await pool.query(query, [
      name,
      normalizedEmail,
      normalizedPhone,
      passwordHash,
      selectedRole,
    ]);

    return res.status(201).json({
      status: 'success',
      message: 'Account registered successfully',
      user: result.rows[0],
    });
  } catch (error) {
    if (error.code === '23505') {
      return res.status(409).json({
        status: 'error',
        message: 'An account with this email or phone already exists',
      });
    }

    console.error('Registration failed:', error.message);

    return res.status(500).json({
      status: 'error',
      message: 'Unable to register account',
    });
  }
}


async function login(req, res) {
  try {
    const { email, password } = req.body || {};

    if (
      typeof email !== 'string' ||
      typeof password !== 'string' ||
      !email.trim() ||
      !password
    ) {
      return res.status(400).json({
        status: 'error',
        message: 'Email and password are required',
      });
    }

    if (password.length > 72) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid email or password',
      });
    }

    const normalizedEmail = email.trim().toLowerCase();

    const result = await pool.query(
      `SELECT id, full_name, email, phone, password_hash, role
       FROM users
       WHERE email = $1`,
      [normalizedEmail]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid email or password',
      });
    }

    const user = result.rows[0];

    const passwordMatches = await bcrypt.compare(
      password,
      user.password_hash
    );

    if (!passwordMatches) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid email or password',
      });
    }

    if (!process.env.JWT_SECRET) {
      console.error('JWT_SECRET is missing from the environment');

      return res.status(500).json({
        status: 'error',
        message: 'Authentication service is not configured',
      });
    }

    const token = jwt.sign(
      { sub: String(user.id) },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '1h' }
    );

    return res.json({
      status: 'success',
      message: 'Login successful',
      token,
      token_type: 'Bearer',
      expires_in: process.env.JWT_EXPIRES_IN || '1h',
      user: {
        id: user.id,
        full_name: user.full_name,
        email: user.email,
        phone: user.phone,
        role: user.role,
      },
    });
  } catch (error) {
    console.error('Login failed:', error.message);

    return res.status(500).json({
      status: 'error',
      message: 'Unable to log in',
    });
  }
}


async function getMe(req, res) {
  try {
    const result = await pool.query(
      `SELECT id, full_name, email, phone, role, created_at
       FROM users
       WHERE id = $1`,
      [req.auth.userId]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({
        status: 'error',
        message: 'User account not found',
      });
    }

    return res.json({
      status: 'success',
      user: result.rows[0],
    });
  } catch (error) {
    console.error('Fetching authenticated user failed:', error.message);

    return res.status(500).json({
      status: 'error',
      message: 'Unable to retrieve user profile',
    });
  }
}


module.exports = { register, login, getMe };
