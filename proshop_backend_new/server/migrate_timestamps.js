const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Order = require('./models/orderModel');

dotenv.config({ path: '../.env' });

const connectDB = async () => {
    try {
        const conn = await mongoose.connect(process.env.MONGO_URI);
        console.log(`MongoDB Connected: ${conn.connection.host}`);
    } catch (error) {
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }
};

const migrateTimestamps = async () => {
    try {
        await connectDB();

        const orders = await Order.find({ createdAt: { $exists: false } });
        console.log(`Found ${orders.length} orders without timestamps.`);

        for (const order of orders) {
            const timestamp = order._id.getTimestamp();
            order.createdAt = timestamp;
            order.updatedAt = timestamp;
            await order.save();
            console.log(`Updated order ${order._id} with timestamp ${timestamp}`);
        }

        console.log('Migration completed successfully.');
        process.exit();
    } catch (error) {
        console.error(`Migration failed: ${error.message}`);
        process.exit(1);
    }
};

migrateTimestamps();
