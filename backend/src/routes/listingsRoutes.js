
const express = require('express');
const { getListings } = require('../controllers/listingsController');

const router = express.Router();

router.get('/', getListings);

module.exports = router;
