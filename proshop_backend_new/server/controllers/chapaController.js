const axios = require('axios');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');
const Order = require('../models/orderModel');

const CHAPA_URL = 'https://api.chapa.co/v1/transaction/initialize';
const CHAPA_VERIFY_URL = 'https://api.chapa.co/v1/transaction/verify/';

// @desc    Initialize Chapa Transaction
// @route   POST /api/v1/chapa/initialize/:orderId
// @access  Private
exports.initializeChapaTransaction = catchAsync(async (req, res, next) => {
    const order = await Order.findById(req.params.orderId);

    if (!order) {
        return next(new AppError('Order not found', 404));
    }

    const tx_ref = `proshop-${order._id}-${Date.now()}`;
    const firstName = req.user.name.split(' ')[0] || 'User';
    const lastName = req.user.name.split(' ').slice(1).join(' ') || 'Customer';
    
    // Convert USD to ETB (1 USD = 180 ETB as requested)
    const EXCHANGE_RATE = 180;
    const amountInETB = (parseFloat(order.totalPrice) * EXCHANGE_RATE).toFixed(2);
    
    const data = {
        amount: amountInETB,
        currency: 'ETB',
        email: req.user.email,
        first_name: firstName,
        last_name: lastName,
        tx_ref,
        callback_url: `${process.env.BACKEND_URL || 'http://192.168.137.127:5000'}/api/v1/chapa/verify/${tx_ref}`,
        return_url: `${process.env.BACKEND_URL || 'http://192.168.137.127:5000'}/checkout/success`,
        customization: {
            title: 'ProShop Order',
            description: `Order ${order._id.toString().slice(-8)} ${amountInETB} ETB`
        }
    };

    console.log('Sending Chapa Payload:', JSON.stringify(data, null, 2));

    try {
        const response = await axios.post(CHAPA_URL, data, {
            headers: {
                Authorization: `Bearer ${process.env.CHAPA_SECRET_KEY}`,
                'Content-Type': 'application/json'
            }
        });

        if (response.data.status === 'success') {
            res.status(200).json({
                success: true,
                data: {
                    ...response.data.data,
                    tx_ref
                }
            });
        } else {
            console.warn('Chapa Success Check Failed:', JSON.stringify(response.data, null, 2));
            return next(new AppError('Chapa initialization failed', 400));
        }
    } catch (error) {
        const errorData = error.response?.data || error;
        console.error('Chapa Error Full:', JSON.stringify(errorData, null, 2));
        
        let errorMsg = 'Unknown Chapa Error';
        
        if (errorData.message) {
            // Handle case where message is an object or string
            errorMsg = typeof errorData.message === 'object' 
                ? JSON.stringify(errorData.message) 
                : errorData.message;
        } else if (error.message) {
            errorMsg = error.message;
        } else if (typeof errorData === 'object') {
            errorMsg = JSON.stringify(errorData);
        } else {
            errorMsg = String(errorData);
        }
            
        return next(new AppError(`Chapa Error: ${errorMsg}`, 500));
    }
});

// @desc    Verify Chapa Transaction
// @route   GET /api/v1/chapa/verify/:tx_ref
// @access  Public (usually called by callback or mobile app)
exports.verifyChapaPayment = catchAsync(async (req, res, next) => {
    const { tx_ref } = req.params;

    try {
        const response = await axios.get(`${CHAPA_VERIFY_URL}${tx_ref}`, {
            headers: {
                Authorization: `Bearer ${process.env.CHAPA_SECRET_KEY}`
            }
        });

        if (response.data.status === 'success') {
            // Find order by tx_ref hidden in the reference or we can pass orderId in metadata
            // For now, extract orderId from tx_ref: proshop-ORDERID-TIMESTAMP
            const parts = tx_ref.split('-');
            const orderId = parts[1];

            const order = await Order.findById(orderId);
            if (order && !order.isPaid) {
                order.isPaid = true;
                order.paidAt = Date.now();
                order.paymentResult = {
                    id: response.data.data.reference,
                    status: 'COMPLETED',
                    update_time: new Date().toISOString(),
                    email_address: response.data.data.email
                };
                await order.save();
                
                // Redirect or send success response
                return res.status(200).json({
                    success: true,
                    message: 'Payment verified and order updated'
                });
            }
            
            res.status(200).json({
                success: true,
                message: 'Payment already processed or order not found'
            });
        } else {
            return next(new AppError('Payment verification failed', 400));
        }
    } catch (error) {
        console.error('Chapa Verification Error:', error.response?.data || error.message);
        return next(new AppError('Chapa Verification Error', 500));
    }
});
