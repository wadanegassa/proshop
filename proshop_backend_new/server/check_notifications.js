const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Notification = require('./models/notificationModel');
const User = require('./models/userModel');

dotenv.config();

const checkNotifications = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('DB Connected');

        const count = await Notification.countDocuments();
        console.log(`Total Notifications: ${count}`);

        const notifications = await Notification.find().populate('user', 'name email');
        console.log('Notifications:', JSON.stringify(notifications, null, 2));

        const users = await User.find().select('name email');
        console.log('Users:', users);

        process.exit();
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

checkNotifications();
