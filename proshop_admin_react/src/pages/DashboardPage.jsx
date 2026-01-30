import { useState, useEffect } from 'react';
import axios from 'axios';
import { analyticsAPI, ordersAPI } from '../services/api';
import { motion } from 'framer-motion';
import {
    Plus,
    Search,
    Filter,
    Edit3,
    Trash2,
    Eye,
    Star,
    ChevronLeft,
    ChevronRight,
    TrendingUp,
    ShoppingBag,
    Users,
    DollarSign,
    ArrowUpRight,
    ArrowDownRight,
    MoreHorizontal
} from 'lucide-react';
import EthiopiaMap from '../components/EthiopiaMap';
import {
    AreaChart,
    Area,
    XAxis,
    YAxis,
    CartesianGrid,
    Tooltip,
    ResponsiveContainer,
    BarChart,
    Bar,
    ComposedChart,
    Line,
    Cell
} from 'recharts';

const performanceData = [
    { name: 'Jan', pageViews: 32, clicks: 12 },
    { name: 'Feb', pageViews: 58, clicks: 25 },
    { name: 'Mar', pageViews: 45, clicks: 18 },
    { name: 'Apr', pageViews: 65, clicks: 30 },
    { name: 'May', pageViews: 48, clicks: 22 },
    { name: 'Jun', pageViews: 52, clicks: 28 },
    { name: 'Jul', pageViews: 42, clicks: 20 },
    { name: 'Aug', pageViews: 48, clicks: 25 },
    { name: 'Sep', pageViews: 82, clicks: 42 },
    { name: 'Oct', pageViews: 55, clicks: 28 },
    { name: 'Nov', pageViews: 62, clicks: 35 },
    { name: 'Dec', pageViews: 68, clicks: 40 },
];

const dashboardStats = {
    kpis: [
        { title: 'Total Orders', value: '13,647', change: '+2.3%', trend: 'up', icon: ShoppingBag, label: 'Last Week' },
        { title: 'New Leads', value: '9,526', change: '+8.1%', trend: 'up', icon: Users, label: 'Last Month' },
        { title: 'Deals', value: '976', change: '-0.3%', trend: 'down', icon: TrendingUp, label: 'Last Month' },
        { title: 'Booked Revenue', value: '$123.6k', change: '+10.6%', trend: 'up', icon: DollarSign, label: 'Last Month' },
    ],
    topPages: [
        { path: '/larkon/ecommerce.html', views: 465, exitRate: '4.4%', status: 'success' },
        { path: '/larkon/dashboard.html', views: 426, exitRate: '20.4%', status: 'error' },
        { path: '/larkon/chat.html', views: 254, exitRate: '12.25%', status: 'warning' },
        { path: '/larkon/auth-login.html', views: 3369, exitRate: '5.2%', status: 'success' },
        { path: '/larkon/email.html', views: 985, exitRate: '64.2%', status: 'error' },
        { path: '/larkon/social.html', views: 653, exitRate: '2.4%', status: 'success' },
        { path: '/larkon/blog.html', views: 478, exitRate: '1.4%', status: 'success' },
    ],
    recentOrders: [
        { id: '#RB5625', date: '21 April 2024', product: 'Anna M. Hines', customer: 'Anna M. Hines', email: 'anna.hines@mail.com', phone: '(+1)-555-1564-261', address: 'Burr Ridge/Illinois', payment: 'Credit Card', status: 'Completed' },
        { id: '#RB5652', date: '25 April 2024', product: 'Judith H. Fritsche', customer: 'Judith H. Fritsche', email: 'judith.fritsche.com', phone: '(+57)-305-5579-759', address: 'SULLIVAN/Kentucky', payment: 'Credit Card', status: 'Completed' },
        { id: '#RB5684', date: '25 April 2024', product: 'Peter T. Smith', customer: 'Peter T. Smith', email: 'peter.smith@mail.com', phone: '(+33)-655-5187-93', address: 'Yreka/California', payment: 'PayPal', status: 'Completed' },
    ]
};

const DashboardPage = () => {
    const [stats, setStats] = useState(null);
    const [recentOrders, setRecentOrders] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const [analyticsRes, ordersRes] = await Promise.all([
                    analyticsAPI.getDashboardData(),
                    ordersAPI.getAll()
                ]);
                setStats(analyticsRes.data || {});
                // ordersRes is { success: true, count: N, data: { orders: [...] } }
                const orders = ordersRes.data.orders || [];
                const sortedOrders = orders.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt)).slice(0, 5);
                setRecentOrders(sortedOrders);
            } catch (error) {
                console.error('Error fetching dashboard data:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, []);

    const kpis = [
        { title: 'Total Revenue', value: stats ? `$${stats.totalSales.toLocaleString()}` : '$0', change: '+12.5%', trend: 'up', icon: DollarSign, label: 'Lifetime' },
        { title: 'Total Orders', value: stats ? stats.totalOrders.toLocaleString() : '0', change: '+5.2%', trend: 'up', icon: ShoppingBag, label: 'Lifetime' },
        { title: 'Top Products', value: stats ? stats.topProducts.length : '0', change: '+2.1%', trend: 'up', icon: TrendingUp, label: 'Active' },
        { title: 'Growth Rate', value: '18.4%', change: '+3.1%', trend: 'up', icon: Users, label: 'This Month' },
    ];

    const chartData = stats?.salesOverTime?.map(item => ({
        name: new Date(item._id).toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
        sales: item.totalSales,
        orders: item.count
    })) || performanceData;

    if (loading) return <div style={styles.loading}>Loading Dashboard...</div>;

    return (
        <div style={styles.container}>
            {/* Warning Notice from Screenshot */}
            <div style={styles.notice}>
                <p>We regret to inform you that our server is currently experiencing technical difficulties.</p>
            </div>

            <div style={styles.topSection}>
                {/* KPI Grid */}
                <div style={styles.kpiContainer}>
                    <div style={styles.kpiGrid}>
                        {kpis.map((kpi, idx) => (
                            <div key={kpi.title} className="larkon-card" style={styles.kpiCard}>
                                <div style={styles.kpiContent}>
                                    <div style={styles.kpiIconBox}>
                                        <kpi.icon size={20} color="var(--primary)" />
                                    </div>
                                    <div style={styles.kpiInfo}>
                                        <p style={styles.kpiLabel}>{kpi.title}</p>
                                        <h3 style={styles.kpiValue}>{kpi.value}</h3>
                                    </div>
                                </div>
                                <div style={styles.kpiFooter}>
                                    <span style={{ ...styles.kpiTrend, color: kpi.trend === 'up' ? 'var(--success)' : 'var(--error)' }}>
                                        {kpi.trend === 'up' ? <ArrowUpRight size={12} /> : <ArrowDownRight size={12} />}
                                        {kpi.change}
                                    </span>
                                    <span style={styles.kpiTime}>{kpi.label}</span>
                                    <span style={styles.viewMore}>View More</span>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>

                {/* Performance Chart */}
                <div className="larkon-card" style={styles.performanceCard}>
                    <div style={styles.cardHeader}>
                        <h4 style={styles.cardTitle}>Performance</h4>
                        <div style={styles.chartActions}>
                            {['ALL', '1M', '6M', '1Y'].map(t => <button key={t} style={styles.timeBtn}>{t}</button>)}
                        </div>
                    </div>
                    <div style={styles.chartWrapper}>
                        <ResponsiveContainer width="100%" height="100%">
                            <ComposedChart data={chartData}>
                                <Bar dataKey="sales" fill="var(--primary)" radius={[4, 4, 0, 0]} barSize={12} name="Sales ($)" />
                                <Line type="monotone" dataKey="orders" stroke="var(--success)" strokeWidth={2} dot={false} name="Orders" />
                            </ComposedChart>
                        </ResponsiveContainer>
                    </div>
                    <div style={styles.chartLegend}>
                        <div style={styles.legendItem}><div style={{ ...styles.dot, background: 'var(--primary)' }}></div> Sales ($)</div>
                        <div style={styles.legendItem}><div style={{ ...styles.dot, background: 'var(--success)' }}></div> Orders</div>
                    </div>
                </div>
            </div>

            <div style={styles.middleSection}>
                {/* Conversions Gauge Placeholder */}
                <div className="larkon-card" style={styles.widgetCard}>
                    <h4 style={styles.cardTitle}>Conversions</h4>
                    <div style={styles.gaugeContainer}>
                        <div style={styles.gaugeMock}>
                            <div style={styles.gaugeInner}>
                                <h2 style={styles.gaugeValue}>65.2%</h2>
                                <p style={styles.gaugeLabel}>Returning Customer</p>
                            </div>
                        </div>
                    </div>
                    <div style={styles.gaugeStats}>
                        <div style={styles.gaugeStatItem}>
                            <p style={styles.gaugeStatLabel}>This Week</p>
                            <h4 style={styles.gaugeStatValue}>23.5k</h4>
                        </div>
                        <div style={styles.gaugeStatItem}>
                            <p style={styles.gaugeStatLabel}>Last Week</p>
                            <h4 style={styles.gaugeStatValue}>41.05k</h4>
                        </div>
                    </div>
                    <button style={styles.fullWidthBtn}>View Details</button>
                </div>

                {/* Sessions by Country Widget */}
                <div className="larkon-card" style={styles.widgetCard}>
                    <h4 style={styles.cardTitle}>Sessions by Country</h4>
                    <EthiopiaMap />
                    <div style={styles.gaugeStats}>
                        <div style={styles.gaugeStatItem}>
                            <p style={styles.gaugeStatLabel}>Sessions</p>
                            <h4 style={styles.gaugeStatValue}>12.4k</h4>
                        </div>
                        <div style={styles.gaugeStatItem}>
                            <p style={styles.gaugeStatLabel}>Bounce Rate</p>
                            <h4 style={styles.gaugeStatValue}>24.3%</h4>
                        </div>
                    </div>
                </div>

                {/* Top Pages Table */}
                <div className="larkon-card" style={styles.widgetCard}>
                    <div style={styles.cardHeader}>
                        <h4 style={styles.cardTitle}>Top Pages</h4>
                        <button style={styles.viewAllBtn}>View All</button>
                    </div>
                    <table className="larkon-table" style={styles.compactTable}>
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Sold</th>
                            </tr>
                        </thead>
                        <tbody>
                            {stats?.topProducts?.map((product, idx) => (
                                <tr key={idx}>
                                    <td style={styles.pathTd}>{product.name}</td>
                                    <td>
                                        <span className="larkon-badge badge-orange">{product.totalSold} sold</span>
                                    </td>
                                </tr>
                            )) || <p style={{ padding: '20px', color: 'var(--text-muted)' }}>No data</p>}
                        </tbody>
                    </table>
                </div>
            </div>

            <div style={styles.bottomSection}>
                <div className="larkon-card" style={styles.fullCard}>
                    <div style={styles.cardHeader}>
                        <h4 style={styles.cardTitle}>Recent Orders</h4>
                        <button style={styles.orangeBtn}><Plus size={16} /> Create Order</button>
                    </div>
                    <div style={styles.tableScroll}>
                        <table className="larkon-table">
                            <thead>
                                <tr>
                                    <th>Order ID.</th>
                                    <th>Date</th>
                                    <th>Product</th>
                                    <th>Customer Name</th>
                                    <th>Email ID</th>
                                    <th>Phone No.</th>
                                    <th>Address</th>
                                    <th>Payment Type</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {recentOrders.map((order) => (
                                    <tr key={order._id}>
                                        <td style={styles.orderId}>#{order._id.substring(0, 6)}</td>
                                        <td>{new Date(order.createdAt).toLocaleDateString()}</td>
                                        <td>
                                            <div style={styles.productCell}>
                                                <div style={styles.productThumb}>📦</div>
                                                <span>{order.orderItems.length} Items</span>
                                            </div>
                                        </td>
                                        <td style={styles.customerName}>{order.user?.name || 'Guest'}</td>
                                        <td>{order.user?.email || 'N/A'}</td>
                                        <td>-</td>
                                        <td>{order.shippingAddress?.city}, {order.shippingAddress?.country}</td>
                                        <td>{order.paymentMethod}</td>
                                        <td>
                                            <div style={styles.statusCell}>
                                                <div style={{ ...styles.statusDot, background: order.isPaid ? 'var(--success)' : 'var(--warning)' }}></div>
                                                <span style={{ color: order.isPaid ? 'var(--success)' : 'var(--warning)' }}>{order.isPaid ? 'Paid' : 'Unpaid'}</span>
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                                {recentOrders.length === 0 && (
                                    <tr>
                                        <td colSpan="9" style={{ textAlign: 'center', padding: '20px', color: 'var(--text-muted)' }}>
                                            No recent orders found.
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    );
};

const styles = {
    loading: {
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: '18px',
        color: 'var(--primary)',
        background: 'var(--background)',
    },
    container: {
        display: 'flex',
        flexDirection: 'column',
        gap: '24px',
    },
    notice: {
        background: 'rgba(255, 108, 47, 0.05)',
        border: '1px solid rgba(255, 108, 47, 0.1)',
        borderRadius: '8px',
        padding: '12px 20px',
        fontSize: '13px',
        color: 'var(--primary)',
        textAlign: 'center',
    },
    topSection: {
        display: 'grid',
        gridTemplateColumns: '400px 1fr',
        gap: '24px',
    },
    kpiGrid: {
        display: 'grid',
        gridTemplateColumns: 'repeat(2, 1fr)',
        gap: '16px',
        height: '100%',
    },
    kpiCard: {
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        padding: '20px',
    },
    kpiContent: {
        display: 'flex',
        alignItems: 'center',
        gap: '16px',
        marginBottom: '16px',
    },
    kpiIconBox: {
        width: '44px',
        height: '44px',
        background: 'rgba(255, 108, 47, 0.1)',
        borderRadius: '10px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
    },
    kpiInfo: {
        display: 'flex',
        flexDirection: 'column',
    },
    kpiLabel: {
        fontSize: '12px',
        color: 'var(--text-muted)',
        fontWeight: '600',
        marginBottom: '4px',
    },
    kpiValue: {
        fontSize: '20px',
        fontWeight: '800',
    },
    kpiFooter: {
        display: 'flex',
        alignItems: 'baseline',
        gap: '8px',
        flexWrap: 'wrap',
    },
    kpiTrend: {
        fontSize: '12px',
        fontWeight: '700',
        display: 'flex',
        alignItems: 'center',
        gap: '2px',
    },
    kpiTime: {
        fontSize: '11px',
        color: 'var(--text-muted)',
    },
    viewMore: {
        marginLeft: 'auto',
        fontSize: '11px',
        color: 'var(--text-muted)',
        cursor: 'pointer',
    },
    performanceCard: {
        display: 'flex',
        flexDirection: 'column',
    },
    cardHeader: {
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: '24px',
    },
    cardTitle: {
        fontSize: '15px',
        fontWeight: '700',
    },
    chartActions: {
        display: 'flex',
        background: 'var(--background)',
        padding: '4px',
        borderRadius: '8px',
        gap: '4px',
    },
    timeBtn: {
        padding: '4px 10px',
        fontSize: '11px',
        fontWeight: '700',
        color: 'var(--text-secondary)',
        borderRadius: '6px',
        '&:hover': { background: 'var(--surface)' }
    },
    chartWrapper: {
        height: '250px',
        width: '100%',
    },
    chartLegend: {
        display: 'flex',
        justifyContent: 'center',
        gap: '20px',
        marginTop: '16px',
    },
    legendItem: {
        display: 'flex',
        alignItems: 'center',
        gap: '6px',
        fontSize: '12px',
        color: 'var(--text-secondary)',
    },
    dot: {
        width: '8px',
        height: '8px',
        borderRadius: '50%',
    },
    middleSection: {
        display: 'grid',
        gridTemplateColumns: 'repeat(3, 1fr)',
        gap: '24px',
    },
    widgetCard: {
        display: 'flex',
        flexDirection: 'column',
        height: '420px',
    },
    gaugeContainer: {
        flex: 1,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
    },
    gaugeMock: {
        width: '180px',
        height: '180px',
        border: '15px solid rgba(255, 108, 47, 0.1)',
        borderTopColor: 'var(--primary)',
        borderRadius: '50%',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        transform: 'rotate(45deg)',
    },
    gaugeInner: {
        transform: 'rotate(-45deg)',
        textAlign: 'center',
    },
    gaugeValue: {
        fontSize: '28px',
        fontWeight: '800',
    },
    gaugeLabel: {
        fontSize: '12px',
        color: 'var(--text-muted)',
        marginTop: '4px',
    },
    gaugeStats: {
        display: 'grid',
        gridTemplateColumns: '1fr 1fr',
        padding: '20px 0',
        borderTop: '1px solid var(--divider)',
        marginTop: 'auto',
    },
    gaugeStatItem: {
        textAlign: 'center',
    },
    gaugeStatLabel: {
        fontSize: '12px',
        color: 'var(--text-muted)',
        marginBottom: '8px',
    },
    gaugeStatValue: {
        fontSize: '16px',
        fontWeight: '700',
    },
    fullWidthBtn: {
        width: '100%',
        padding: '10px',
        background: 'var(--primary-glow)',
        borderRadius: '8px',
        color: 'var(--primary)',
        fontSize: '13px',
        fontWeight: '600',
        border: '1px solid var(--divider)',
    },
    mapPlaceholder: {
        flex: 1,
        backgroundImage: `url('https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/World_map_blank_without_borders.svg/1000px-World_map_blank_without_borders.svg.png')`,
        backgroundSize: 'contain',
        backgroundPosition: 'center',
        backgroundRepeat: 'no-repeat',
        opacity: 0.1,
        position: 'relative',
    },
    mapDots: {
        position: 'absolute',
        top: 0, left: 0, right: 0, bottom: 0,
    },
    mapDot: {
        position: 'absolute',
        width: '8px',
        height: '8px',
        background: 'var(--primary)',
        borderRadius: '50%',
        boxShadow: '0 0 10px var(--primary)',
    },
    viewAllBtn: {
        fontSize: '12px',
        color: 'var(--primary)',
        fontWeight: '600',
        background: 'rgba(255, 108, 47, 0.1)',
        padding: '4px 10px',
        borderRadius: '6px',
    },
    compactTable: {
        marginTop: '10px',
    },
    pathTd: {
        maxWidth: '150px',
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        whiteSpace: 'nowrap',
        color: 'var(--text-muted)',
    },
    bottomSection: {
        marginTop: '8px',
    },
    fullCard: {
        width: '100%',
    },
    orangeBtn: {
        background: 'var(--primary)',
        color: 'var(--background)',
        padding: '8px 16px',
        borderRadius: '8px',
        fontSize: '13px',
        fontWeight: '700',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
    },
    tableScroll: {
        overflowX: 'auto',
    },
    orderId: {
        color: 'var(--primary)',
        fontWeight: '700',
    },
    productCell: {
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
    },
    productThumb: {
        width: '28px',
        height: '28px',
        background: 'var(--surface-hover)',
        borderRadius: '6px',
    },
    customerName: {
        color: 'var(--primary)',
        fontWeight: '600',
    },
    statusCell: {
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        color: 'var(--success)',
        fontWeight: '700',
    },
    statusDot: {
        width: '6px',
        height: '6px',
        background: 'var(--success)',
        borderRadius: '50%',
    }
};

export default DashboardPage;
