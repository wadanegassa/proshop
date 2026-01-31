const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Notification = require('./models/notificationModel');
const User = require('./models/userModel');

dotenv.config();

const seedNotification = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('DB Connected');

        const user = await User.findOne(); // Get first user (likely admin or the one logged in)
        if (!user) {
            console.log('No users found');
            process.exit(1);
        }

        console.log(`Creating notification for user: ${user.name} (${user._id})`);

        await Notification.create({
            title: 'Test Notification',
            message: 'This is a test notification to verify the system.',
            type: 'system',
            user: user._id
        });

        console.log('Notification Created Successfully');
        process.exit();
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

seedNotification();
