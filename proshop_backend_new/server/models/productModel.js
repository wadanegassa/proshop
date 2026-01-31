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
    gender: { type: String, enum: ['Men', 'Women', 'Kids', 'Unisex', 'N/A'], default: 'N/A' },
    sizes: { type: [String], default: [] },
    colors: { type: [String], default: [] },
    specifications: [
        {
            label: { type: String, required: true },
            value: { type: String, required: true }
        }
    ],
    highlights: { type: [String], default: [] },
    reviews: [
        {
            user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
            name: { type: String, required: true },
            rating: { type: Number, required: true, min: 1, max: 5 },
            comment: { type: String, required: true },
            createdAt: { type: Date, default: Date.now }
        }
    ],
    rating: {
        type: Number,
        default: 0
    },
    numReviews: {
        type: Number,
        default: 0
    },
    status: {
        type: String,
        enum: ['Draft', 'Published', 'Archived'],
        default: 'Draft'
    },
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
