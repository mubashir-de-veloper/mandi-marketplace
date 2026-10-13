
const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
  const authorization = req.headers.authorization;

  if (!authorization || !authorization.startsWith('Bearer ')) {
    return res.status(401).json({
      status: 'error',
      message: 'Authentication token is required',
    });
  }

  const token = authorization.slice(7).trim();

  if (!token) {
    return res.status(401).json({
      status: 'error',
      message: 'Authentication token is required',
    });
  }

  if (!process.env.JWT_SECRET) {
    console.error('JWT_SECRET is missing from the environment');

    return res.status(500).json({
      status: 'error',
      message: 'Authentication service is not configured',
    });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    if (
      typeof decoded === 'string' ||
      typeof decoded.sub !== 'string' ||
      !/^\d+$/.test(decoded.sub)
    ) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid authentication token',
      });
    }

    req.auth = {
      userId: decoded.sub,
    };

    next();
  } catch (error) {
    return res.status(401).json({
      status: 'error',
      message: 'Invalid or expired authentication token',
    });
  }
}

module.exports = authenticateToken;
