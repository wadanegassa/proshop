import React, { useState, useEffect } from 'react';
import {
    TrendingUp,
    ArrowUpRight,
    ArrowDownRight,
    ShoppingBag,
    Users,
    DollarSign,
    Target,
    Layers,
    Globe,
    MoreVertical,
    ChevronRight,
    Plus
} from 'lucide-react';
import { analyticsAPI } from '../services/api';
import {
    AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
    BarChart, Bar, LineChart, Line, ComposedChart, PieChart, Pie, Cell
} from 'recharts';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import L from 'leaflet';
import { useTheme } from '../context/ThemeContext';

// Fix for default marker icon
import icon from 'leaflet/dist/images/marker-icon.png';
import iconShadow from 'leaflet/dist/images/marker-shadow.png';

let DefaultIcon = L.icon({
    iconUrl: icon,
    shadowUrl: iconShadow,
    iconSize: [25, 41],
    iconAnchor: [12, 41]
});

L.Marker.prototype.options.icon = DefaultIcon;

const DashboardPage = () => {
    const { isDarkMode } = useTheme();
    const [stats, setStats] = useState(null);
    const [performanceData, setPerformanceData] = useState([]);
    const [orderLocations, setOrderLocations] = useState([]);
    const [loading, setLoading] = useState(true);
    const [performanceLoading, setPerformanceLoading] = useState(true);
    const [performanceRange, setPerformanceRange] = useState('1M');

    // Fetch Initial General Stats
    useEffect(() => {
        const fetchStats = async () => {
            try {
                const response = await analyticsAPI.getStats('1M');
                const data = response.data.data;
                setStats(data);
                setPerformanceData(data.salesOverTime || []);

                // Stable locations for map
                if (data.recentOrders) {
                    const locations = data.recentOrders.map(order => ({
                        id: order._id,
                        name: order.user?.name || 'Customer',
                        pos: [
                            9.145 + (Math.random() * 4 - 2),
                            40.489 + (Math.random() * 4 - 2)
                        ]
                    }));
                    setOrderLocations(locations);
                }
            } catch (error) {
                console.error('Dashboard error:', error);
            } finally {
                setLoading(false);
                setPerformanceLoading(false);
            }
        };
        fetchStats();
    }, []);

    // Only update performance data when range changes
    useEffect(() => {
        const fetchPerformanceData = async () => {
            if (loading) return;
            setPerformanceLoading(true);
            try {
                const response = await analyticsAPI.getStats(performanceRange);
                setPerformanceData(response.data.data.salesOverTime || []);
            } catch (error) {
                console.error('Performance error:', error);
            } finally {
                setPerformanceLoading(false);
            }
        };
        fetchPerformanceData();
    }, [performanceRange]);

    const formatChartLabel = (value) => {
        if (!value) return '';
        if (performanceRange === '1D') return value;
        try {
            const date = new Date(value);
            if (isNaN(date.getTime())) return value;
            if (performanceRange === '1M' || performanceRange === '6M') {
                return date.toLocaleDateString('en-US', { day: 'numeric', month: 'short' });
            }
            if (performanceRange === '1Y' || performanceRange === 'ALL') {
                return date.toLocaleDateString('en-US', { month: 'short', year: '2-digit' });
            }
        } catch (e) {
            return value;
        }
        return value;
    };

    if (loading) return <div className="loading-state">Loading premium dashboard...</div>;

    const topStats = [
        { title: 'Total Orders', value: stats?.totalOrders.toLocaleString(), icon: <ShoppingBag size={20} />, trend: '2.3%', isUp: true, sub: 'Last Week', color: '#ff6600' },
        { title: 'New Leads', value: stats?.newLeads.toLocaleString(), icon: <Target size={20} />, trend: '8.1%', isUp: true, sub: 'Last Month', color: '#ff6600' },
        { title: 'Deals', value: stats?.deals.toLocaleString(), icon: <Layers size={20} />, trend: '0.3%', isUp: false, sub: 'Last Month', color: '#ff6600' },
        { title: 'Booked Revenue', value: `$${(stats?.bookedRevenue / 1000).toFixed(1)}k`, icon: <DollarSign size={20} />, trend: '10.6%', isUp: false, sub: 'Last Month', color: '#ff6600' },
    ];

    const COLORS = ['#ff6b00', '#22c55e', '#3b82f6', '#eab308'];

    return (
        <div className="dashboard-page fade-in">
            <div className="welcome-banner glass-card">
                <div className="banner-text">
                    <h1>PROSHOP DASHBOARD</h1>
                    <p>Track your business performance and customer insights in real-time.</p>
                </div>
            </div>

            <div className="dashboard-grid">
                {/* Top Widgets */}
                <div className="stats-container">
                    <div className="stats-header">
                        {topStats.map((stat, i) => (
                            <div key={i} className="stat-widget glass-card">
                                <div className="stat-info">
                                    <div className="stat-icon-box" style={{ background: `${stat.color}15`, color: stat.color }}>
                                        {stat.icon}
                                    </div>
                                    <div className="stat-details">
                                        <span className="stat-label">{stat.title}</span>
                                        <h3 className="stat-value">{stat.value}</h3>
                                    </div>
                                </div>
                                <div className="stat-footer">
                                    <span className={`trend-tag ${stat.isUp ? 'up' : 'down'}`}>
                                        {stat.isUp ? '▲' : '▼'} {stat.trend}
                                    </span>
                                    <span className="stat-period">{stat.sub}</span>
                                </div>
                            </div>
                        ))}
                    </div>

                    <div className="conversions-box glass-card">
                        <div className="card-header">
                            <h4>Conversions</h4>
                        </div>
                        <div className="radial-chart-container">
                            <ResponsiveContainer width="100%" height={200}>
                                <PieChart>
                                    <Pie
                                        data={[
                                            { name: 'Returning', value: parseFloat(stats?.returningCustomersPercent || 0) },
                                            { name: 'New', value: parseFloat(stats?.newCustomersPercent || 0) }
                                        ]}
                                        cx="50%"
                                        cy="50%"
                                        innerRadius={60}
                                        outerRadius={80}
                                        paddingAngle={5}
                                        dataKey="value"
                                        startAngle={180}
                                        endAngle={0}
                                    >
                                        <Cell fill="#ff6b00" />
                                        <Cell fill="rgba(255,107,0,0.1)" />
                                    </Pie>
                                </PieChart>
                            </ResponsiveContainer>
                            <div className="radial-center">
                                <span className="radial-value">{stats?.returningCustomersPercent || 0}%</span>
                                <span className="radial-label">Returning Customer</span>
                            </div>
                        </div>
                        <div className="conversion-stats">
                            <div className="c-stat">
                                <span className="c-label">Total Customers</span>
                                <span className="c-value">{stats?.totalUniqueCustomers || 0}</span>
                            </div>
                            <div className="c-stat">
                                <span className="c-label">Returning</span>
                                <span className="c-value">{Math.round((stats?.returningCustomersPercent / 100) * stats?.totalUniqueCustomers) || 0}</span>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Performance Chart */}
                <div className="performance-box glass-card">
                    <div className="card-header">
                        <h4>Performance</h4>
                        <div className="header-actions">
                            <div className="chart-tabs">
                                <span className={performanceRange === 'ALL' ? 'active' : ''} onClick={() => setPerformanceRange('ALL')}>ALL</span>
                                <span className={performanceRange === '1D' ? 'active' : ''} onClick={() => setPerformanceRange('1D')}>1D</span>
                                <span className={performanceRange === '1M' ? 'active' : ''} onClick={() => setPerformanceRange('1M')}>1M</span>
                                <span className={performanceRange === '6M' ? 'active' : ''} onClick={() => setPerformanceRange('6M')}>6M</span>
                                <span className={performanceRange === '1Y' ? 'active' : ''} onClick={() => setPerformanceRange('1Y')}>1Y</span>
                            </div>
                        </div>
                    </div>
                    <div className="chart-wrapper" style={{ opacity: performanceLoading ? 0.5 : 1, transition: 'opacity 0.3s' }}>
                        <ResponsiveContainer width="100%" height={320}>
                            <ComposedChart data={performanceData}>
                                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke={isDarkMode ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.05)'} />
                                <XAxis
                                    dataKey="_id"
                                    axisLine={false}
                                    tickLine={false}
                                    tick={{ fill: isDarkMode ? '#888' : '#666', fontSize: 11 }}
                                    tickFormatter={formatChartLabel}
                                />
                                <YAxis axisLine={false} tickLine={false} tick={{ fill: isDarkMode ? '#888' : '#666', fontSize: 11 }} />
                                <Tooltip
                                    labelFormatter={formatChartLabel}
                                    contentStyle={{ background: isDarkMode ? '#1e2227' : '#ffffff', border: '1px solid var(--divider)', borderRadius: '8px' }}
                                />
                                <Bar dataKey="pageViews" fill="var(--primary)" radius={[4, 4, 0, 0]} barSize={performanceRange === '1D' ? 40 : 20} />
                                <Line type="monotone" dataKey="clicks" stroke="#22c55e" strokeWidth={2} dot={false} />
                            </ComposedChart>
                        </ResponsiveContainer>
                        <div className="chart-legend">
                            <span className="legend-item"><span className="dot" style={{ background: 'var(--primary)' }}></span> Sales Content View</span>
                            <span className="legend-item"><span className="dot" style={{ background: '#22c55e' }}></span> Order Conversion</span>
                        </div>
                    </div>
                </div>

                <div className="sessions-box glass-card">
                    <div className="card-header">
                        <h4>Live Orders Map (Ethiopia)</h4>
                    </div>
                    <div className="map-container-wrapper" style={{ height: '300px', borderRadius: '12px', overflow: 'hidden' }}>
                        <MapContainer
                            center={[9.145, 40.489673]}
                            zoom={6}
                            style={{ height: '100%', width: '100%' }}
                            zoomControl={false}
                        >
                            <TileLayer
                                url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
                                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
                            />
                            {orderLocations.map((loc) => (
                                <Marker
                                    key={loc.id}
                                    position={loc.pos}
                                >
                                    <Popup>
                                        <div style={{ color: 'black' }}>
                                            <b>Order #{loc.id.substring(loc.id.length - 6)}</b><br />
                                            {loc.name}<br />
                                            Active
                                        </div>
                                    </Popup>
                                </Marker>
                            ))}
                        </MapContainer>
                    </div>
                    <div className="sessions-list">
                        {stats?.sessionsByCountry.slice(0, 4).map((c, i) => (
                            <div key={i} className="session-item">
                                <span className="country-info">{c.country || 'Ethiopia'}</span>
                                <span className="session-count">{c.sessions} Orders</span>
                            </div>
                        ))}
                    </div>
                </div>

                <div className="top-pages-box glass-card">
                    <div className="card-header">
                        <h4>Top Selling Products</h4>
                    </div>
                    <div className="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Product Name</th>
                                    <th>Sales</th>
                                    <th>Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                {stats?.topProducts?.map((p, i) => (
                                    <tr key={i}>
                                        <td className="page-path">{p.name}</td>
                                        <td>{p.salesCount}</td>
                                        <td><span className={`badge badge-success`}>${Number(p.revenue).toLocaleString()}</span></td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>

                <div className="recent-orders-box glass-card full-width">
                    <div className="card-header">
                        <h4>Recent Orders</h4>
                    </div>
                    <div className="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Order ID.</th>
                                    <th>Date</th>
                                    <th>Customer Name</th>
                                    <th>Email ID</th>
                                    <th>Phone No.</th>
                                    <th>Address</th>
                                    <th>Payment Type</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {stats?.recentOrders.map((order, i) => (
                                    <tr key={i}>
                                        <td className="order-id">#{order._id.substring(order._id.length - 6).toUpperCase()}</td>
                                        <td>{new Date(order.createdAt).toLocaleDateString()}</td>
                                        <td>{order.user?.name || 'Customer'}</td>
                                        <td>{order.user?.email || 'N/A'}</td>
                                        <td>{order.shippingAddress?.phone || 'N/A'}</td>
                                        <td>{order.shippingAddress?.city || 'N/A'}</td>
                                        <td>{order.paymentMethod || 'COD'}</td>
                                        <td>
                                            <span className="status-badge">
                                                <span className="dot" style={{ background: order.isPaid ? '#22c55e' : '#f59e0b' }}></span>
                                                {order.isPaid ? 'Paid' : 'Unpaid'}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <style>{`
                .dashboard-page {
                    display: flex;
                    flex-direction: column;
                    gap: 24px;
                }
                .welcome-banner {
                    padding: 24px;
                    background: var(--sidebar-bg) !important;
                    border: 1px solid var(--divider) !important;
                }
                .banner-text h1 { font-size: 18px; margin-bottom: 8px; color: var(--primary); }
                .banner-text p { font-size: 13px; color: var(--text-secondary); }

                .dashboard-grid {
                    display: grid;
                    grid-template-columns: repeat(12, 1fr);
                    gap: 24px;
                }

                .stats-container {
                    grid-column: span 8;
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 20px;
                }
                .stats-header {
                    grid-column: span 1;
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    grid-template-rows: 1fr 1fr;
                    gap: 20px;
                }
                .conversions-box { grid-column: span 1; padding: 24px; }

                .stat-widget {
                    padding: 20px;
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                }
                .stat-info { display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
                .stat-icon-box {
                    width: 44px;
                    height: 44px;
                    border-radius: 8px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .stat-label { font-size: 13px; color: var(--text-muted); display: block; }
                .stat-value { font-size: 20px; font-weight: 700; color: var(--text-primary); }
                .stat-footer { display: flex; align-items: center; gap: 8px; font-size: 11px; }
                .trend-tag { font-weight: 600; }
                .trend-tag.up { color: var(--success); }
                .trend-tag.down { color: var(--error); }
                .stat-period { color: var(--text-muted); flex: 1; }
                .view-more { color: var(--primary); font-size: 11px; font-weight: 600; background: transparent; }

                .radial-chart-container { position: relative; margin: 20px 0; }
                .radial-center {
                    position: absolute;
                    top: 55%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    text-align: center;
                }
                .radial-value { display: block; font-size: 18px; font-weight: 700; color: var(--text-primary); }
                .radial-label { font-size: 10px; color: var(--text-muted); }
                .conversion-stats { display: flex; justify-content: space-around; margin-bottom: 20px; }
                .c-stat { text-align: center; }
                .c-label { display: block; font-size: 11px; color: var(--text-muted); margin-bottom: 4px; }
                .c-value { font-size: 14px; font-weight: 700; color: var(--text-primary); }
                .full-view-btn { width: 100%; height: 36px; background: var(--surface-light); border-radius: 6px; color: var(--text-primary); font-size: 12px; font-weight: 600; box-shadow: 0 4px 0 var(--background); }
                .full-view-btn:hover { background: var(--surface); color: var(--text-primary); }

                .performance-box { grid-column: span 4; padding: 24px; }
                .chart-tabs { display: flex; background: var(--sidebar-bg); border-radius: 4px; padding: 2px; }
                .chart-tabs span { padding: 4px 8px; font-size: 10px; font-weight: 700; color: var(--text-muted); cursor: pointer; border-radius: 4px; }
                .chart-tabs span.active { background: var(--primary); color: white; }
                .chart-legend { display: flex; justify-content: center; gap: 24px; margin-top: 20px; }
                .legend-item { font-size: 11px; color: var(--text-muted); display: flex; align-items: center; gap: 6px; }
                .dot { width: 8px; height: 8px; border-radius: 50%; }

                .sessions-box { grid-column: span 4; padding: 24px; }
                .map-placeholder { height: 200px; display: flex; align-items: center; justify-content: center; margin: 20px 0; }
                .session-item { display: flex; justify-content: space-between; padding: 12px 0; border-top: 1px solid var(--divider); }
                .country-info { font-size: 13px; color: var(--text-primary); }
                .session-count { font-size: 13px; font-weight: 600; color: var(--text-primary); }

                .top-pages-box { grid-column: span 4; padding: 24px; }
                .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .card-header h4 { font-size: 14px; font-weight: 700; color: var(--text-primary); }
                
                .recent-orders-box { grid-column: span 12; padding: 24px; }
                .full-width { grid-column: span 12; }

                table { width: 100%; border-collapse: collapse; }
                th { text-align: left; padding: 12px; font-size: 11px; color: var(--text-muted); font-weight: 600; border-bottom: 1px solid var(--divider); text-transform: uppercase; }
                td { padding: 14px 12px; font-size: 12px; border-bottom: 1px solid var(--divider); color: var(--text-secondary); }
                .page-path { color: var(--text-muted); }
                .order-id { font-weight: 700; color: #3b82f6; }
                .status-badge { display: flex; align-items: center; gap: 8px; }
                .view-all-link { color: var(--primary); font-size: 12px; font-weight: 600; background: transparent; }
                .btn-sm { font-size: 11px; padding: 6px 12px; border-radius: 4px; }
                
                .loading-state { height: 80vh; display: flex; align-items: center; justify-content: center; font-size: 18px; color: var(--primary); }
            `}</style>
        </div>
    );
};

export default DashboardPage;
