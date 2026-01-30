const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const globalErrorHandler = require('./middleware/errorMiddleware');
const AppError = require('./utils/appError');

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'));
}

// Routes Placeholder
app.get('/', (req, res) => {
    res.send('ProShop API is running...');
});

const authRouter = require('./routes/userRoutes');
const productRouter = require('./routes/productRoutes');
const categoryRouter = require('./routes/categoryRoutes');
const orderRouter = require('./routes/orderRoutes');
const cartRouter = require('./routes/cartRoutes');
const analyticsRouter = require('./routes/analyticsRoutes');
const uploadRouter = require('./routes/uploadRoutes');
const path = require('path');

// ...

// Mount Routes
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/users', authRouter);
app.use('/api/v1/products', productRouter);
app.use('/api/v1/categories', categoryRouter);
app.use('/api/v1/orders', orderRouter);
app.use('/api/v1/cart', cartRouter);
app.use('/api/v1/cart', cartRouter);
app.use('/api/v1/analytics', analyticsRouter);
app.use('/api/v1/upload', uploadRouter);

const __dirname1 = path.resolve();
app.use('/uploads', express.static(path.join(__dirname1, '/uploads')));


// Handle Unhandled Routes
app.use((req, res, next) => {
    next(new AppError(`Can't find ${req.originalUrl} on this server!`, 404));
});

// Global Error Handler
app.use(globalErrorHandler);

module.exports = app;
