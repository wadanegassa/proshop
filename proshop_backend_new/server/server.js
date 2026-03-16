const env = require('./config/env');
const connectDB = require('./config/db');
const app = require('./app');
const seedAdmin = require('./utils/adminSeeder');

// Connect to Database
connectDB().then(() => {
    seedAdmin();
});

const os = require('os');

const PORT = env.PORT || 5000;

const server = app.listen(PORT, '0.0.0.0', () => {
    const interfaces = os.networkInterfaces();
    const addresses = [];
    for (const k in interfaces) {
        for (const k2 in interfaces[k]) {
            const address = interfaces[k][k2];
            if (address.family === 'IPv4' && !address.internal) {
                addresses.push(address.address);
            }
        }
    }
    
    console.log(`Server running in ${env.NODE_ENV} mode on port ${PORT}`);
    console.log(`Local Access: http://localhost:${PORT}`);
    addresses.forEach(addr => console.log(`Network Access: http://${addr}:${PORT}`));
});

// Handle Unhandled Promise Rejections
process.on('unhandledRejection', (err) => {
    console.log('UNHANDLED REJECTION! 💥 Shutting down...');
    console.log(err.name, err.message);
    server.close(() => {
        process.exit(1);
    });
});
