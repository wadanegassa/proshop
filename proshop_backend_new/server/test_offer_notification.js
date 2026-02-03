const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Product = require('./models/productModel');
const Notification = require('./models/notificationModel');
const User = require('./models/userModel');

dotenv.config();

const testOfferNotification = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('Connected to MongoDB');

        // 1. Get a product
        const product = await Product.findOne();
        if (!product) {
            console.log('No product found');
            process.exit(1);
        }
        console.log(`Testing with product: ${product.name}, current discount: ${product.discount}%`);

        // 2. Mock the controller logic
        // We will manually update and create notification as the controller would
        const oldDiscount = product.discount || 0;
        const newDiscount = 25; // Significant increase >= 20%

        product.discount = newDiscount;
        await product.save();
        console.log(`Updated product discount to ${newDiscount}%`);

        if (newDiscount >= 20 && newDiscount > oldDiscount) {
            const users = await User.find({ role: 'user' });
            console.log(`Found ${users.length} users to notify`);

            if (users.length > 0) {
                const notifications = users.map(user => ({
                    title: '🔥 Big Offer Alert!',
                    message: `${product.name} is now ${newDiscount}% OFF! Grab it before it's gone.`,
                    type: 'alert',
                    user: user._id,
                    createdAt: Date.now()
                }));
                const created = await Notification.insertMany(notifications);
                console.log(`Created ${created.length} notifications successfully`);
            }
        }

        process.exit(0);
    } catch (error) {
        console.error('Test failed:', error);
        process.exit(1);
    }
};

testOfferNotification();
