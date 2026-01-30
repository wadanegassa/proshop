const User = require('../models/userModel');

const seedAdmin = async () => {
    try {
        const adminEmail = 'admin@proshop.com';
        const adminExists = await User.findOne({ email: adminEmail });

        if (!adminExists) {
            await User.create({
                name: 'ProShop Admin',
                email: adminEmail,
                password: 'Admin@123',
                role: 'admin'
            });
            console.log('✅ Admin account created: admin@proshop.com / Admin@123');
        } else {
            console.log('ℹ️ Admin account already exists.');
        }
    } catch (error) {
        console.error('❌ Error seeding admin:', error.message);
    }
};

module.exports = seedAdmin;
