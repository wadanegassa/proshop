import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ordersAPI } from '../services/api';
import {
    Package,
    Truck,
    MapPin,
    CreditCard,
    CheckCircle,
    Printer,
    User,
    Mail,
    Phone,
    ArrowLeft
} from 'lucide-react';

const OrderDetailsPage = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [order, setOrder] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchOrder();
    }, [id]);

    const fetchOrder = async () => {
        try {
            const response = await ordersAPI.getOne(id);
            setOrder(response.data.order);
        } catch (error) {
            console.error('Error fetching order:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleDeliver = async () => {
        try {
            await ordersAPI.updateToDelivered(id);
            fetchOrder(); // Refresh
        } catch (error) {
            console.error('Error updating order:', error);
            alert('Failed to mark as delivered');
        }
    };

    if (loading) return <div style={styles.loading}>Loading Order Details...</div>;
    if (!order) return <div style={styles.error}>Order not found</div>;

    return (
        <div style={styles.container}>
            <header style={styles.header}>
                <div style={styles.headerLeft}>
                    <button onClick={() => navigate('/orders')} style={styles.backBtn}><ArrowLeft size={18} /> Back</button>
                    <div>
                        <h1 style={styles.title}>Order <span className="orange-text">Details</span></h1>
                        <div style={styles.headerSub}>
                            <span style={styles.idBadge}>#{order._id}</span>
                            <span style={styles.dateText}>{new Date(order.createdAt).toLocaleString()}</span>
                        </div>
                    </div>
                </div>
                <div style={styles.headerActions}>
                    <button style={styles.actionBtn}><Printer size={18} /> Print Invoice</button>
                    {!order.isDelivered && (
                        <button style={styles.primaryBtn} onClick={handleDeliver}>
                            <Truck size={18} /> Mark as Delivered
                        </button>
                    )}
                </div>
            </header>

            <div style={styles.mainGrid}>
                {/* Left Col: Order Content */}
                <div style={styles.leftCol}>
                    {/* Items Card */}
                    <div className="larkon-card" style={styles.card}>
                        <div style={styles.cardHeader}>
                            <Package size={18} color="var(--primary)" />
                            <h4 style={styles.cardTitle}>Order Items</h4>
                        </div>
                        <table className="larkon-table">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Price</th>
                                    <th>Qty</th>
                                    <th style={{ textAlign: 'right' }}>Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                {order.orderItems.map((item, index) => (
                                    <tr key={index}>
                                        <td>
                                            <div style={styles.productCell}>
                                                <div style={styles.productThumb}>
                                                    {item.image ? <img src={item.image} alt="" style={styles.thumbImg} /> : '📦'}
                                                </div>
                                                <span style={styles.productName}>{item.name}</span>
                                            </div>
                                        </td>
                                        <td>${item.price.toFixed(2)}</td>
                                        <td>{item.qty}</td>
                                        <td style={{ textAlign: 'right', fontWeight: '700', color: 'var(--text-primary)' }}>
                                            ${(item.price * item.qty).toFixed(2)}
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                        <div style={styles.summaryArea}>
                            <div style={styles.summaryRow}>
                                <span>Shipping Fee</span>
                                <span>${order.shippingPrice?.toFixed(2) || '0.00'}</span>
                            </div>
                            <div style={styles.summaryRow}>
                                <span>Tax</span>
                                <span>${order.taxPrice?.toFixed(2) || '0.00'}</span>
                            </div>
                            <div style={{ ...styles.summaryRow, borderTop: '1px solid var(--divider)', marginTop: '12px', paddingTop: '12px' }}>
                                <h3 style={styles.totalLabel}>Total</h3>
                                <h3 style={styles.totalValue}>${order.totalPrice?.toFixed(2)}</h3>
                            </div>
                        </div>
                    </div>

                    {/* Customer & Shipping Info Grid */}
                    <div style={styles.infoGrid}>
                        <div className="larkon-card" style={styles.infoCard}>
                            <div style={styles.cardHeader}>
                                <User size={18} color="var(--primary)" />
                                <h4 style={styles.cardTitle}>Customer Info</h4>
                            </div>
                            <div style={styles.customerBox}>
                                <div style={styles.avatarPlaceholder}>
                                    <User size={24} color="var(--primary)" />
                                </div>
                                <div>
                                    <p style={styles.customerName}>{order.user?.name || 'Guest'}</p>
                                    <div style={styles.contactItem}><Mail size={12} /> {order.user?.email || 'N/A'}</div>
                                </div>
                            </div>
                        </div>

                        <div className="larkon-card" style={styles.infoCard}>
                            <div style={styles.cardHeader}>
                                <MapPin size={18} color="var(--primary)" />
                                <h4 style={styles.cardTitle}>Shipping Address</h4>
                            </div>
                            <p style={styles.addressText}>
                                {order.shippingAddress?.address}, {order.shippingAddress?.city}<br />
                                {order.shippingAddress?.postalCode}, {order.shippingAddress?.country}
                            </p>
                            {order.isDelivered ? (
                                <div style={{ ...styles.statusBadge, color: 'var(--success)', background: 'rgba(34, 197, 94, 0.1)' }}>
                                    Delivered at {new Date(order.deliveredAt).toLocaleString()}
                                </div>
                            ) : (
                                <div style={{ ...styles.statusBadge, color: 'var(--warning)', background: 'rgba(234, 179, 8, 0.1)' }}>
                                    Not Delivered
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                {/* Right Col: Timeline & Status */}
                <div style={styles.rightCol}>
                    <div className="larkon-card" style={styles.card}>
                        <div style={styles.cardHeader}>
                            <CreditCard size={18} color="var(--primary)" />
                            <h4 style={styles.cardTitle}>Payment Details</h4>
                        </div>
                        <div style={styles.paymentBox}>
                            <div style={styles.paymentRow}>
                                <span style={styles.payLabel}>Method</span>
                                <span style={styles.payVal}>{order.paymentMethod}</span>
                            </div>
                            <div style={styles.paymentRow}>
                                <span style={styles.payLabel}>Status</span>
                                {order.isPaid ? (
                                    <span className="larkon-badge badge-success">Paid on {new Date(order.paidAt).toLocaleDateString()}</span>
                                ) : (
                                    <span className="larkon-badge badge-error">Not Paid</span>
                                )}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

const styles = {
    loading: {
        height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--primary)',
    },
    error: {
        padding: '40px', textAlign: 'center', color: 'var(--error)',
    },
    container: { display: 'flex', flexDirection: 'column', gap: '24px' },
    header: { display: 'flex', justifyContent: 'space-between', alignItems: 'center' },
    headerLeft: { display: 'flex', flexDirection: 'column', gap: '8px' },
    backBtn: {
        background: 'none', border: 'none', display: 'flex', alignItems: 'center', gap: '6px', color: 'var(--text-muted)', cursor: 'pointer', fontSize: '13px', padding: 0, marginBottom: '4px'
    },
    title: { fontSize: '24px', fontWeight: '800' },
    headerSub: { display: 'flex', alignItems: 'center', gap: '12px', marginTop: '6px' },
    idBadge: { background: 'rgba(255, 108, 47, 0.1)', color: 'var(--primary)', padding: '2px 8px', borderRadius: '4px', fontSize: '11px', fontWeight: '800' },
    dateText: { fontSize: '12px', color: 'var(--text-muted)', fontWeight: '600' },
    headerActions: { display: 'flex', gap: '12px' },
    primaryBtn: { background: 'var(--primary)', color: 'black', padding: '10px 20px', borderRadius: '8px', fontSize: '14px', fontWeight: '700', display: 'flex', alignItems: 'center', gap: '8px', cursor: 'pointer' },
    actionBtn: { background: 'var(--surface-hover)', border: '1px solid var(--divider)', color: 'var(--text-primary)', padding: '10px 20px', borderRadius: '8px', fontSize: '14px', fontWeight: '700', display: 'flex', alignItems: 'center', gap: '8px', cursor: 'pointer' },
    mainGrid: { display: 'grid', gridTemplateColumns: '1fr 340px', gap: '24px', alignItems: 'start' },
    leftCol: { display: 'flex', flexDirection: 'column', gap: '24px' },
    rightCol: { display: 'flex', flexDirection: 'column', gap: '24px' },
    card: { padding: '24px' },
    cardHeader: { display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '20px' },
    cardTitle: { fontSize: '15px', fontWeight: '700' },
    productCell: { display: 'flex', alignItems: 'center', gap: '12px' },
    productThumb: { width: '32px', height: '32px', background: 'var(--background)', borderRadius: '6px', display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden' },
    thumbImg: { width: '100%', height: '100%', objectFit: 'cover' },
    productName: { fontSize: '13px', fontWeight: '600' },
    summaryArea: { marginTop: '24px', display: 'flex', flexDirection: 'column', gap: '8px', alignItems: 'flex-end' },
    summaryRow: { width: '260px', display: 'flex', justifyContent: 'space-between', fontSize: '13px', color: 'var(--text-secondary)' },
    totalLabel: { fontSize: '18px', fontWeight: '800', color: 'var(--text-primary)' },
    totalValue: { fontSize: '18px', fontWeight: '800', color: 'var(--primary)' },
    infoGrid: { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px' },
    infoCard: { padding: '24px' },
    customerBox: { display: 'flex', alignItems: 'center', gap: '16px' },
    avatarPlaceholder: { width: '48px', height: '48px', borderRadius: '12px', background: 'var(--surface-hover)', display: 'flex', alignItems: 'center', justifyContent: 'center' },
    customerName: { fontSize: '14px', fontWeight: '700', marginBottom: '6px' },
    contactItem: { fontSize: '12px', color: 'var(--text-muted)', display: 'flex', alignItems: 'center', gap: '6px' },
    addressText: { fontSize: '13px', color: 'var(--text-secondary)', lineHeight: '1.6', marginBottom: '16px' },
    paymentBox: { display: 'flex', flexDirection: 'column', gap: '12px' },
    paymentRow: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: '13px' },
    payLabel: { color: 'var(--text-muted)' },
    payVal: { fontWeight: '600', color: 'var(--text-primary)' },
    statusBadge: { padding: '8px', borderRadius: '6px', fontSize: '12px', fontWeight: '600', textAlign: 'center', marginTop: '8px' }
};

export default OrderDetailsPage;
