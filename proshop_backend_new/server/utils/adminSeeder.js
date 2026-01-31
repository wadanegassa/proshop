const User = require('../models/userModel');

const seedAdmin = async () => {
    try {
        const adminExists = await User.findOne({ email: 'admin@proshop.com' });
        if (adminExists) {
            console.log('Admin already exists.');
            return;
        }

        await User.create({
            name: 'ProShop Admin',
            email: 'admin@proshop.com',
            password: 'proshop1234',
            role: 'admin'
        });

        console.log('Admin user created successfully.');
    } catch (error) {
        console.error('Error seeding admin:', error.message);
    }
};

module.exports = seedAdmin;
