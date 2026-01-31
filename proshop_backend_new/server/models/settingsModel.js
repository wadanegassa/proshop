const mongoose = require('mongoose');

const settingsSchema = new mongoose.Schema({
    taxRate: {
        type: Number,
        default: 0.15, // 15%
        min: 0
    },
    shippingFee: {
        type: Number,
        default: 10.0,
        min: 0
    },
    globalDiscount: {
        type: Number,
        default: 0.0,
        min: 0,
        max: 100 // Percentage
    },
    supportEmail: {
        type: String,
        default: 'support@proshop.com'
    },
    supportPhone: {
        type: String,
        default: '+1234567890'
    },
    updatedAt: {
        type: Date,
        default: Date.now
    }
});

// Singleton pattern: Ensure only one document exists?? 
// We will handle this in controller (always fetch the first one or create if empty)

const Settings = mongoose.model('Settings', settingsSchema);
module.exports = Settings;
