const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'A product must have a name'],
        trim: true
    },
    description: {
        type: String,
        required: [true, 'A product must have a description']
    },
    price: {
        type: Number,
        required: [true, 'A product must have a price'],
        default: 0
    },
    images: {
        type: [String],
        default: []
    },
    category: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Category',
        required: [true, 'A product must belong to a category']
    },
    countInStock: {
        type: Number,
        required: [true, 'A product must have a stock count'],
        default: 0
    },
    brand: String,
    sku: String,
    manufacturer: String,
    weight: String,
    discount: { type: Number, default: 0 },
    tax: { type: Number, default: 0 },
    gender: { type: String, enum: ['Men', 'Women', 'Kids', 'Unisex'], default: 'Men' },
    sizes: { type: [String], default: [] },
    colors: { type: [String], default: [] },
    createdAt: {
        type: Date,
        default: Date.now
    }
}, {
    toJSON: { virtuals: true },
    toObject: { virtuals: true }
});

const Product = mongoose.model('Product', productSchema);
module.exports = Product;
