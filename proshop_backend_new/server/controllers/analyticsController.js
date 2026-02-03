const Order = require('../models/orderModel');
const Product = require('../models/productModel');
const User = require('../models/userModel');
const catchAsync = require('../middleware/asyncHandler');

exports.getAnalyticsData = catchAsync(async (req, res, next) => {
    console.log('Analytics request received at Controller');
    // Basic stats
    const totalSalesData = await Order.aggregate([
        { $match: { isPaid: true } },
        { $group: { _id: null, totalSales: { $sum: '$totalPrice' }, totalOrders: { $sum: 1 } } }
    ]);

    const totalSales = (totalSalesData.length > 0 && totalSalesData[0].totalSales) ? totalSalesData[0].totalSales : 0;
    const totalOrders = (await Order.countDocuments()) || 0;

    // Real Metrics
    const totalUsers = await User.countDocuments(); // Raw count of all registered users
    const newLeads = totalUsers; // For now consider all users as leads if we track that way

    const dealsCount = await Order.countDocuments({ $or: [{ isPaid: true }, { isDelivered: true }] });
    const deals = dealsCount;

    const allOrdersValue = await Order.aggregate([
        { $group: { _id: null, total: { $sum: '$totalPrice' } } }
    ]);
    const bookedRevenue = allOrdersValue.length > 0 ? allOrdersValue[0].total : 0;

    const { range = '1M' } = req.query;
    let startDate = new Date();
    let groupFormat = '%Y-%m-%d';

    if (range === '1D') {
        startDate.setHours(startDate.getHours() - 24);
        groupFormat = '%H:00';
    } else if (range === '1M') {
        startDate.setDate(startDate.getDate() - 30);
        groupFormat = '%Y-%m-%d';
    } else if (range === '6M') {
        startDate.setMonth(startDate.getMonth() - 6);
        groupFormat = '%Y-%m-%d';
    } else if (range === '1Y') {
        startDate.setFullYear(startDate.getFullYear() - 1);
        groupFormat = '%Y-%m';
    } else if (range === 'ALL') {
        startDate = new Date(0);
        groupFormat = '%Y-%m';
    }

    // Sessions by City
    const sessionsByCity = await Order.aggregate([
        { $group: { _id: '$shippingAddress.city', count: { $sum: 1 } } },
        { $project: { city: '$_id', sessions: '$count', _id: 0 } },
        { $sort: { sessions: -1 } }
    ]);

    // Performance Chart Data (Sales over time)
    const salesOverTime = await Order.aggregate([
        { $match: { createdAt: { $gte: startDate } } },
        {
            $group: {
                _id: { $dateToString: { format: groupFormat, date: '$createdAt' } },
                totalSales: { $sum: '$totalPrice' },
                orderCount: { $sum: 1 }
            }
        },
        { $sort: { _id: 1 } }
    ]);

    // Ensure chart has at least some data points for visualization if empty
    let finalSalesOverTime = salesOverTime;

    // FILL EMPTY DATA for better UX (Zero State) 
    // If we have no data, generate empty slots for the chart so it shows 0s instead of nothing
    if (finalSalesOverTime.length === 0) {
        finalSalesOverTime = [];
        const today = new Date();
        const daysToGen = range === '1D' ? 24 : (range === '1M' ? 30 : 7);

        for (let i = daysToGen; i >= 0; i--) {
            const d = new Date(today);
            if (range === '1D') {
                d.setHours(d.getHours() - i);
                // Format manually to match groupFormat %H:00
                // Note: Mongo's %H is 0-23. 
                const h = d.getHours().toString().padStart(2, '0');
                finalSalesOverTime.push({ _id: `${h}:00`, totalSales: 0, orderCount: 0 });
            } else {
                d.setDate(d.getDate() - i);
                // Format YYYY-MM-DD
                const dateStr = d.toISOString().split('T')[0];
                finalSalesOverTime.push({ _id: dateStr, totalSales: 0, orderCount: 0 });
            }
        }
    }

    // Top Selling Products (Calculated from orders if possible, otherwise mock from product stats)
    const topProductsData = await Order.aggregate([
        { $unwind: '$orderItems' },
        {
            $group: {
                _id: '$orderItems.product',
                name: { $first: '$orderItems.name' },
                salesCount: { $sum: '$orderItems.qty' },
                revenue: { $sum: { $multiply: ['$orderItems.qty', '$orderItems.price'] } }
            }
        },
        { $sort: { salesCount: -1 } },
        { $limit: 6 },
        {
            $lookup: {
                from: 'products',
                localField: '_id',
                foreignField: '_id',
                as: 'productDetails'
            }
        },
        {
            $unwind: {
                path: '$productDetails',
                preserveNullAndEmptyArrays: true
            }
        },
        {
            $project: {
                _id: 1,
                name: 1,
                salesCount: 1,
                revenue: 1,
                rating: { $ifNull: ['$productDetails.rating', 0] },
                numReviews: { $ifNull: ['$productDetails.numReviews', 0] }
            }
        }
    ]);

    // If no orders yet, fall back to showing products with mock sales
    let finalTopProducts = topProductsData;

    // Fallback: If no top sellers (no orders), show "Recent Products" with 0 sales
    if (topProductsData.length === 0) {
        const recentProducts = await Product.find({})
            .select('name price rating numReviews')
            .sort('-createdAt')
            .limit(5);

        finalTopProducts = recentProducts.map(p => ({
            _id: p._id,
            name: p.name,
            salesCount: 0,
            revenue: 0,
            rating: p.rating || 0,
            numReviews: p.numReviews || 0
        }));
    }

    // Customer Segmentation (Returning vs New)
    const customerOrders = await Order.aggregate([
        { $group: { _id: '$user', orderCount: { $sum: 1 } } }
    ]);
    const totalUniqueCustomers = customerOrders.length;
    const returningCustomers = customerOrders.filter(c => c.orderCount > 1).length;
    const newCustomers = totalUniqueCustomers - returningCustomers;
    const returningCustomersPercent = totalUniqueCustomers > 0 ? ((returningCustomers / totalUniqueCustomers) * 100).toFixed(1) : 0;
    const newCustomersPercent = totalUniqueCustomers > 0 ? (100 - returningCustomersPercent).toFixed(1) : 0;

    // Recent Orders
    const recentOrders = await Order.find({})
        .populate('user', 'name email')
        .sort('-createdAt')
        .limit(10);

    // Orders by Status
    const ordersByStatus = await Order.aggregate([
        { $group: { _id: '$status', count: { $sum: 1 } } },
        { $project: { name: '$_id', value: '$count', _id: 0 } }
    ]);

    res.status(200).json({
        success: true,
        data: {
            totalSales: Number(totalSales) || 0,
            totalOrders: Number(totalOrders) || 0,
            deals: Number(deals) || 0,
            newLeads: Number(newLeads) || 0,
            bookedRevenue: Number(bookedRevenue) || 0,
            salesOverTime: finalSalesOverTime || [],
            conversionRate: ((totalOrders / totalUsers) * 100).toFixed(1),
            returningCustomersPercent: returningCustomersPercent || "0.0",
            newCustomersPercent: newCustomersPercent || "0.0",
            totalUniqueCustomers: totalUniqueCustomers || 0,
            totalUsers: totalUsers || 0,
            sessionsByCity: sessionsByCity || [],
            topProducts: finalTopProducts || [],
            recentOrders: recentOrders || [],
            ordersByStatus: ordersByStatus || []
        }
    });
});
