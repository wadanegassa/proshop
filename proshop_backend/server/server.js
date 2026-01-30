const env = require('./config/env');
const connectDB = require('./config/db');
const app = require('./app');

const seedAdmin = require('./utils/adminSeeder');

// Connect to Database
connectDB().then(() => {
    seedAdmin();
});

const PORT = env.PORT || 5000;

const server = app.listen(PORT, () => {
    console.log(`Server running in ${env.NODE_ENV} mode on port ${PORT}`);
});

// Handle Unhandled Promise Rejections
process.on('unhandledRejection', (err) => {
    console.log('UNHANDLED REJECTION! 💥 Shutting down...');
    console.log(err.name, err.message);
    server.close(() => {
        process.exit(1);
    });
});

process.on('uncaughtException', (err) => {
    console.log('UNCAUGHT EXCEPTION! 💥 Shutting down...');
    console.log(err.name, err.message);
    process.exit(1);
});
