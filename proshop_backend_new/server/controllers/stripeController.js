const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

// @desc    Create Stripe Payment Intent
// @route   POST /api/v1/stripe/create-payment-intent
// @access  Private
exports.createPaymentIntent = catchAsync(async (req, res, next) => {
    const { amount, currency = 'usd' } = req.body;

    if (!amount) {
        return next(new AppError('Please provide an amount', 400));
    }

    console.log(`Creating Stripe Payment Intent for: ${amount} ${currency}`);
    let paymentIntent;
    try {
        paymentIntent = await stripe.paymentIntents.create({
            amount: Math.round(amount * 100),
            currency,
            payment_method_types: ['card'],
        });
    } catch (stripeError) {
        console.error('Stripe SDK Error:', stripeError.message);
        return next(new AppError(`Stripe Error: ${stripeError.message}`, 500));
    }

    console.log(`Payment Intent Created: ${paymentIntent.id} for amount ${amount} ${currency}`);
    console.log(`Client Secret: ${paymentIntent.client_secret.substring(0, 15)}...`);
    res.status(200).json({
        status: 'success',
        clientSecret: paymentIntent.client_secret,
    });
});

exports.getStripePublishableKey = catchAsync(async (req, res, next) => {
    res.status(200).json({
        success: true,
        data: process.env.STRIPE_PUBLISHABLE_KEY
    });
});
