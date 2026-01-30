const Order = require('../models/orderModel');
const catchAsync = require('../middleware/asyncHandler');
const AppError = require('../utils/appError');

exports.getAnalyticsData = catchAsync(async (req, res, next) => {
    // 1. Total Sales & Total Orders
    const totalSalesData = await Order.aggregate([
        {
            $match: { isPaid: true }
        },
        {
            $group: {
                _id: null,
                totalSales: { $sum: '$totalPrice' },
                totalOrders: { $sum: 1 }
            }
        }
    ]);

    const totalSales = totalSalesData.length > 0 ? totalSalesData[0].totalSales : 0;
    const totalOrders = await Order.countDocuments(); // Count all orders, even unpaid? Requirement says "Total Orders", usually implies all.

    // 2. Sales Over Time (Last 30 Days)
    const date = new Date();
    const last30Days = new Date(date.setDate(date.getDate() - 30));

    const salesOverTime = await Order.aggregate([
        {
            $match: {
                createdAt: { $gte: last30Days },
                isPaid: true
            }
        },
        {
            $group: {
                _id: { $dateToString: { format: '%Y-%m-%d', date: '$createdAt' } },
                totalSales: { $sum: '$totalPrice' },
                count: { $sum: 1 }
            }
        },
        { $sort: { _id: 1 } }
    ]);

    // 3. Top Selling Products
    const topProducts = await Order.aggregate([
        { $match: { isPaid: true } },
        { $unwind: '$orderItems' },
        {
            $group: {
                _id: '$orderItems.product',
                name: { $first: '$orderItems.name' },
                totalSold: { $sum: '$orderItems.qty' }
            }
        },
        { $sort: { totalSold: -1 } },
        { $limit: 5 }
    ]);

    res.status(200).json({
        success: true,
        data: {
            totalSales,
            totalOrders,
            salesOverTime,
            topProducts
        }
    });
});
