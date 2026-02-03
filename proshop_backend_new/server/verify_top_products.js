const mongoose = require('mongoose');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const Order = require('./models/orderModel');
const Product = require('./models/productModel');

const connectDB = async () => {
    try {
        const conn = await mongoose.connect(process.env.MONGO_URI);
        console.log(`MongoDB Connected: ${conn.connection.host}`);
    } catch (error) {
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }
};

const verifyTopProducts = async () => {
    await connectDB();

    console.log('Running Aggregation...');

    // Top Selling Products (Calculated from orders if possible, otherwise mock from product stats)
    const topProductsData = await Order.aggregate([
        { $unwind: '$orderItems' },
        {
            $group: {
                _id: '$orderItems.product',
                name: { $first: '$orderItems.name' },
                salesCount: { $sum: '$orderItems.qty' },
                revenue: { $sum: { $multiply: ['$orderItems.qty', '$orderItems.price'] } }
            }
        },
        { $sort: { salesCount: -1 } },
        { $limit: 6 }
    ]);

    console.log('Aggregation Result:', JSON.stringify(topProductsData, null, 2));

    const orderCount = await Order.countDocuments();
    console.log('Total Orders in DB:', orderCount);

    process.exit();
};

verifyTopProducts();
