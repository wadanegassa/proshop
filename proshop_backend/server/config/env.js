const dotenv = require('dotenv');

dotenv.config({ path: './server/.env' }); // Adjust path if running from root

module.exports = {
    NODE_ENV: process.env.NODE_ENV || 'development',
    PORT: process.env.PORT || 5000,
    MONGO_URI: process.env.MONGO_URI || 'mongodb://localhost:27017/proshop',
    JWT_SECRET: process.env.JWT_SECRET || 'fallback_secret_do_not_use_in_prod',
    JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '30d',
};
