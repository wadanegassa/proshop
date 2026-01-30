import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ordersAPI } from '../services/api';
import {
    Plus,
    Search,
    Filter,
    Eye,
    Trash2,
    Edit3,
    ChevronRight,
    ChevronLeft,
    DollarSign,
    ShoppingCart,
    Truck,
    ClipboardList,
    Clock,
    RotateCcw,
    XCircle
} from 'lucide-react';

const orderStats = [
    { label: 'Payment Refund', value: '490', icon: RotateCcw, color: '#FF6C2F' },
    { label: 'Order Cancel', value: '241', icon: XCircle, color: '#E5484D' },
    { label: 'Order Shipped', value: '630', icon: Truck, color: '#FF6C2F' },
    { label: 'Order Delivering', value: '170', icon: Truck, color: '#FF6C2F' },
    { label: 'Pending Review', value: '210', icon: ClipboardList, color: '#FF6C2F' },
    { label: 'Pending Payment', value: '608', icon: Clock, color: '#FF6C2F' },
    { label: 'Delivered', value: '200', icon: ClipboardList, color: '#FF6C2F' },
    { label: 'In Progress', value: '656', icon: ShoppingCart, color: '#FF6C2F' },
];

const OrderListPage = () => {
    const navigate = useNavigate();
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchOrders = async () => {
            try {
                const response = await ordersAPI.getAll();
                setOrders(response.data.orders || []);
            } catch (error) {
                console.error('Error fetching orders:', error);
            } finally {
                setLoading(false);
            }
        };
        fetchOrders();
    }, []);

    if (loading) return <div style={styles.loading}>Loading Orders...</div>;

    return (
        <div style={styles.container}>
            <header style={styles.header}>
                <h1 style={styles.title}>ORDERS <span className="orange-text">LIST</span></h1>
            </header>

            <div style={styles.statsGrid}>
                {orderStats.map((stat, idx) => (
                    <div key={idx} className="larkon-card" style={styles.statCard}>
                        <div style={styles.statInfo}>
                            <p style={styles.statLabel}>{stat.label}</p>
                            <h3 style={styles.statValue}>{stat.value}</h3>
                        </div>
                        <div style={{ ...styles.statIcon, background: `${stat.color}15`, color: stat.color }}>
                            <stat.icon size={20} />
                        </div>
                    </div>
                ))}
            </div>

            <div className="larkon-card" style={styles.tableCard}>
                <div style={styles.tableToolbar}>
                    <h4 style={styles.cardTitle}>All Order List</h4>
                    <div style={styles.toolbarActions}>
                        <div style={styles.filterDropdown}>
                            <span>This Month</span>
                            <ChevronRight size={14} style={{ transform: 'rotate(90deg)' }} />
                        </div>
                    </div>
                </div>

                <div style={styles.tableWrapper}>
                    <table className="larkon-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Created at</th>
                                <th>Customer</th>
                                <th>Priority</th>
                                <th>Total</th>
                                <th>Payment Status</th>
                                <th>Items</th>
                                <th>Delivery Number</th>
                                <th>Order Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {orders.map((order) => (
                                <tr key={order._id}>
                                    <td style={styles.orderId}>#{order._id.substring(0, 6)}</td>
                                    <td>{new Date(order.createdAt).toLocaleDateString()}</td>
                                    <td style={styles.customerName}>{order.user?.name || 'Guest'}</td>
                                    <td><span>Normal</span></td>
                                    <td style={styles.total}>${order.totalPrice}</td>
                                    <td>
                                        <span className={`larkon-badge ${order.isPaid ? 'badge-success' : 'badge-orange'}`}>
                                            {order.isPaid ? 'Paid' : 'Unpaid'}
                                        </span>
                                    </td>
                                    <td>{order.orderItems?.length || 0}</td>
                                    <td>{order.isDelivered ? 'DELIVERED' : '-'}</td>
                                    <td>
                                        <span className={`larkon-badge badge-${order.isDelivered ? 'success' : 'primary'}`} style={{ textTransform: 'uppercase' }}>
                                            {order.isDelivered ? 'Completed' : 'Processing'}
                                        </span>
                                    </td>
                                    <td>
                                        <div style={styles.actions}>
                                            <button style={styles.actionIcon} onClick={() => navigate(`/orders/details/${order._id}`)} title="View Details">
                                                <Eye size={16} />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>

                <div style={styles.pagination}>
                    <p style={styles.paginationText}>Showing {orders.length} orders</p>
                    <div style={styles.pageButtons}>
                        <button style={styles.pageBtn}><ChevronLeft size={16} /></button>
                        <button style={{ ...styles.pageBtn, background: 'var(--primary)', color: 'var(--background)', borderColor: 'var(--primary)' }}>1</button>
                        <button style={styles.pageBtn}>2</button>
                        <button style={styles.pageBtn}>3</button>
                        <button style={styles.pageBtn}><ChevronRight size={16} /></button>
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
    header: {
        marginBottom: '8px',
    },
    title: {
        fontSize: '24px',
        fontWeight: '800',
    },
    statsGrid: {
        display: 'grid',
        gridTemplateColumns: 'repeat(4, 1fr)',
        gap: '24px',
    },
    statCard: {
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: '24px',
    },
    statLabel: {
        fontSize: '13px',
        color: 'var(--text-muted)',
        fontWeight: '600',
        marginBottom: '8px',
    },
    statValue: {
        fontSize: '22px',
        fontWeight: '800',
    },
    statIcon: {
        width: '44px',
        height: '44px',
        borderRadius: '10px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
    },
    tableCard: {
        padding: 0,
    },
    tableToolbar: {
        padding: '24px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottom: '1px solid var(--divider)',
    },
    cardTitle: {
        fontSize: '16px',
        fontWeight: '700',
    },
    filterDropdown: {
        background: 'var(--surface)',
        border: '1px solid var(--divider)',
        padding: '8px 16px',
        borderRadius: '8px',
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
        fontSize: '13px',
        fontWeight: '600',
        color: 'var(--text-secondary)',
    },
    tableWrapper: {
        overflowX: 'auto',
    },
    orderId: {
        color: 'var(--text-muted)',
        fontSize: '13px',
    },
    customerName: {
        color: 'var(--primary)',
        fontWeight: '600',
    },
    total: {
        fontWeight: '700',
    },
    actions: {
        display: 'flex',
        gap: '8px',
    },
    actionIcon: {
        width: '32px',
        height: '32px',
        borderRadius: '6px',
        background: 'var(--background)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        color: 'var(--text-secondary)',
        border: '1px solid var(--divider)',
        cursor: 'pointer',
        transition: 'var(--transition)',
        '&:hover': { background: 'var(--surface-hover)' }
    },
    pagination: {
        padding: '20px 24px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderTop: '1px solid var(--divider)',
    },
    paginationText: {
        fontSize: '13px',
        color: 'var(--text-muted)',
    },
    pageButtons: {
        display: 'flex',
        gap: '6px',
    },
    pageBtn: {
        width: '32px',
        height: '32px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: '6px',
        background: 'var(--surface)',
        border: '1px solid var(--divider)',
        fontSize: '13px',
        fontWeight: '600',
        color: 'var(--text-secondary)',
    }
};

export default OrderListPage;
