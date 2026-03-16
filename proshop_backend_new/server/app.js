const express = require('express');
const cors = require('cors');
const compression = require('compression');
const helmet = require('helmet');
const morgan = require('morgan');
const path = require('path');
const AppError = require('./utils/appError');
const globalErrorHandler = require('./middleware/errorMiddleware');
const userRouter = require('./routes/userRoutes');
const productRouter = require('./routes/productRoutes');
const categoryRouter = require('./routes/categoryRoutes');
const orderRouter = require('./routes/orderRoutes');
const uploadRouter = require('./routes/uploadRoutes');
const analyticsRouter = require('./routes/analyticsRoutes');
const notificationRouter = require('./routes/notificationRoutes');
const settingsRouter = require('./routes/settingsRoutes');
const cartRouter = require('./routes/cartRoutes');
const stripeRouter = require('./routes/stripeRoutes');
const chapaRouter = require('./routes/chapaRoutes');

const app = express();

// Global Middlewares
app.use(helmet({
    crossOriginResourcePolicy: false,
    contentSecurityPolicy: false, // Allow external resources if needed
}));

// More robust CORS configuration
const corsOptions = {
    origin: process.env.NODE_ENV === 'development' ? '*' : process.env.ALLOWED_ORIGINS?.split(',') || [],
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
    optionsSuccessStatus: 204
};
app.use(cors(corsOptions));
app.use(compression());
if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'));
}
app.use(express.json());

// Routes
app.use('/api/v1/auth', userRouter);
app.use('/api/v1/products', productRouter);
app.use('/api/v1/categories', categoryRouter);
app.use('/api/v1/orders', orderRouter);
app.use('/api/v1/upload', uploadRouter);
app.use('/api/v1/analytics', analyticsRouter);
app.use('/api/v1/notifications', notificationRouter);
app.use('/api/v1/settings', settingsRouter);
app.use('/api/v1/cart', cartRouter);
app.use('/api/v1/stripe', stripeRouter);
app.use('/api/v1/chapa', chapaRouter);

app.get('/', (req, res) => {
    res.send('API is running...');
});

app.get('/checkout/success', (req, res) => {
    res.send('<html><body style="display:flex;justify-content:center;align-items:center;height:100vh;font-family:sans-serif;background:#0f172a;color:white;text-align:center;"><div><h1 style="color:#10b981;">Payment Successful!</h1><p>You can now close this window.</p></div></body></html>');
});

// Static Files
app.use('/uploads', express.static(path.join(path.resolve(), 'uploads')));

// 404 Handler
app.use((req, res, next) => {
    next(new AppError(`Can't find ${req.originalUrl} on this server!`, 404));
});

// Error Handler
app.use(globalErrorHandler);

module.exports = app;
