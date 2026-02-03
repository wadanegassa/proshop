const mongoose = require('mongoose');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

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

const testDiscount = async () => {
    await connectDB();

    // Find the headset
    const product = await Product.findOne();
    if (!product) {
        console.log('No product found');
        process.exit();
    }

    console.log(`Original Discount: ${product.discount}`);

    // Update discount
    product.discount = 15;
    await product.save();

    console.log('Updated Discount to 15');

    // Fetch again
    const updated = await Product.findById(product._id);
    console.log(`Fetched Discount: ${updated.discount}`);

    process.exit();
};

testDiscount();
