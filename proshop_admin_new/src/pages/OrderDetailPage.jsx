import React, { useState, useEffect } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { ordersAPI, getImageUrl } from '../services/api';
import {
    ShoppingCart, Package, Truck, CheckCircle, Clock, ChevronRight,
    MapPin, User, DollarSign, ExternalLink, ArrowLeft, Check,
    CreditCard, Edit2, FileText, Ban, Download
} from 'lucide-react';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

const OrderDetailPage = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [order, setOrder] = useState(null);
    const [loading, setLoading] = useState(true);
    const [updating, setUpdating] = useState(false);

    const generatePDF = () => {
        const doc = new jsPDF();
        const orderId = order._id.substring(order._id.length - 8).toUpperCase();

        // Header
        doc.setFontSize(22);
        doc.setTextColor(255, 107, 0); // ProShop Orange
        doc.text('PROSHOP INVOICE', 14, 22);

        doc.setFontSize(10);
        doc.setTextColor(100);
        doc.text(`Order ID: #${orderId}`, 14, 30);
        doc.text(`Date: ${new Date(order.createdAt).toLocaleDateString()}`, 14, 35);
        doc.text(`Status: ${order.status.toUpperCase()}`, 14, 40);

        // Sidebar - Customer Info
        doc.setFontSize(12);
        doc.setTextColor(0);
        doc.text('Customer Details', 140, 30);
        doc.setFontSize(10);
        doc.setTextColor(80);
        doc.text(order.user?.name || 'Guest', 140, 36);
        doc.text(order.user?.email || '', 140, 41);
        doc.text(order.shippingAddress.address, 140, 46);
        doc.text(`${order.shippingAddress.city}, ${order.shippingAddress.postalCode}`, 140, 51);
        doc.text(order.shippingAddress.country, 140, 56);

        // Main Content - Table
        const tableColumn = ["Product", "Qty", "Price", "Amount"];
        const tableRows = order.orderItems.map(item => [
            item.name,
            item.qty,
            `$${item.price.toFixed(2)}`,
            `$${(item.qty * item.price).toFixed(2)}`
        ]);

        autoTable(doc, {
            startY: 70,
            head: [tableColumn],
            body: tableRows,
            theme: 'grid',
            headStyles: { fillColor: [255, 107, 0], textColor: [255, 255, 255] },
            styles: { fontSize: 9 }
        });

        // Footer - Totals
        const finalY = doc.lastAutoTable.finalY + 10;
        doc.setFontSize(10);
        doc.setTextColor(0);
        doc.text(`Subtotal: $${order.itemsPrice.toFixed(2)}`, 140, finalY);
        doc.text(`Shipping: $${order.shippingPrice.toFixed(2)}`, 140, finalY + 6);
        doc.text(`Tax: $${order.taxPrice.toFixed(2)}`, 140, finalY + 12);

        doc.setFontSize(14);
        doc.setTextColor(255, 107, 0);
        doc.text(`Total: $${order.totalPrice.toFixed(2)}`, 140, finalY + 22);

        // Save
        doc.save(`invoice-${orderId}.pdf`);
    };

    useEffect(() => {
        const fetchOrder = async () => {
            try {
                const response = await ordersAPI.getOne(id);
                setOrder(response.data.data);
            } catch (error) {
                console.error('Error fetching order:', error);
            } finally {
                setLoading(false);
            }
        };
        fetchOrder();
    }, [id]);

    const handleUpdateStatus = async (status) => {
        setUpdating(true);
        try {
            await ordersAPI.updateStatus(id, status);
            const response = await ordersAPI.getOne(id);
            setOrder(response.data.data);
        } catch (error) {
            console.error('Error updating status:', error);
        } finally {
            setUpdating(false);
        }
    };

    if (loading) return (
        <div className="larkon-loading">
            <div className="spinner-larkon"></div>
        </div>
    );

    if (!order) return (
        <div className="larkon-error">
            <div className="glass-card error-card">
                <Ban size={48} color="var(--error)" />
                <h2>Order not found</h2>
                <Link to="/orders" className="btn-primary">Go Back</Link>
            </div>
        </div>
    );

    const stages = [
        { key: 'pending', label: 'Order Confirming' },
        { key: 'paid', label: 'Payment Pending' },
        { key: 'processing', label: 'Processing' },
        { key: 'shipped', label: 'Shipping' },
        { key: 'delivered', label: 'Delivered' }
    ];

    const getCurrentStageIndex = () => {
        if (order.status === 'delivered') return 4;
        if (order.status === 'shipped') return 3;
        if (order.status === 'processing') return 2;
        if (order.isPaid) return 2;
        return 0;
    };

    const currentStage = getCurrentStageIndex();

    return (
        <div className="order-details-p-wrapper fade-in">
            {/* Sub Header / Page Header */}
            <div className="larkon-sub-header">
                <div className="header-info">
                    <div className="title-row">
                        <button className="back-btn-ghost" onClick={() => navigate('/orders')}><ArrowLeft size={20} /></button>
                        <h2>Order #{order._id.substring(order._id.length - 8).toUpperCase()}</h2>
                        <span className={`badge-larkon ${order.isPaid ? 'paid' : 'unpaid'}`}>{order.isPaid ? 'Paid' : 'Unpaid'}</span>
                        <span className="badge-larkon status-tag">{order.status.replace('-', ' ')}</span>
                    </div>
                    <div className="breadcrumb-row">
                        <Link to="/">Dashboard</Link> <ChevronRight size={12} /> <Link to="/orders">Orders</Link> <ChevronRight size={12} /> <span>Details</span>
                        <span className="date-sep">-</span>
                        <span>{new Date(order.createdAt).toLocaleString()}</span>
                    </div>
                </div>
                <div className="header-actions">
                    <button className="larkon-btn btn-primary" onClick={generatePDF}>
                        <Download size={18} className="me-1" /> Invoice PDF
                    </button>
                </div>
            </div>

            <div className="larkon-grid">
                {/* Left Section (70%) */}
                <div className="larkon-content-main">
                    {/* Progress Section */}
                    <div className="glass-card mb-4 overflow-hidden">
                        <div className="card-header-plain">
                            <h4>Progress</h4>
                        </div>
                        <div className="larkon-progress-container">
                            <div className="progress-track">
                                {stages.map((stage, index) => (
                                    <div key={index} className={`progress-segment ${index <= currentStage ? 'completed' : ''} ${index === currentStage ? 'active' : ''}`}>
                                        <div className="segment-bar"></div>
                                        <span className="segment-label">{stage.label}</span>
                                    </div>
                                ))}
                            </div>
                            <div className="shipping-estimate">
                                <div className="est-info">
                                    <Clock size={14} />
                                    <span>Estimated shipping date: <strong>{new Date(new Date(order.createdAt).getTime() + 2 * 24 * 60 * 60 * 1000).toLocaleDateString()}</strong></span>
                                </div>
                                {order.status === 'delivered' ? (
                                    <button className="btn-primary sm-btn" disabled style={{ background: 'var(--success)', opacity: 1, gap: '6px' }}>
                                        <Check size={14} /> Delivered
                                    </button>
                                ) : (
                                    <button
                                        className="btn-primary sm-btn"
                                        onClick={() => handleUpdateStatus(order.status === 'shipped' ? 'delivered' : 'shipped')}
                                        disabled={updating}
                                    >
                                        {updating ? 'Updating...' : (order.status === 'shipped' ? 'Mark as Delivered' : 'Ready To Ship')}
                                    </button>
                                )}
                            </div>
                        </div>
                    </div>

                    {/* Product Table */}
                    <div className="glass-card mb-4">
                        <div className="card-header-plain">
                            <h4>Order Items</h4>
                        </div>
                        <div className="larkon-table-wrapper">
                            <table className="larkon-product-table">
                                <thead>
                                    <tr>
                                        <th>Product Name</th>
                                        <th>Status</th>
                                        <th>Quantity</th>
                                        <th>Price</th>
                                        <th>Tax</th>
                                        <th>Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {order.orderItems.map((item, idx) => (
                                        <tr key={idx}>
                                            <td>
                                                <div className="product-item-cell">
                                                    <img src={getImageUrl(item.image)} alt="" />
                                                    <div className="p-info">
                                                        <span className="p-name">{item.name}</span>
                                                        <span className="p-sku">SKU: PRO-{order._id.substring(0, 4)}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span className="badge-larkon status-tag secondary">Ready</span></td>
                                            <td>{item.qty}</td>
                                            <td>${item.price.toFixed(2)}</td>
                                            <td>${(item.price * item.qty * 0.15).toFixed(2)}</td>
                                            <td className="fw-bold">${(item.qty * item.price).toFixed(2)}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>

                    {/* Order Timeline */}
                    <div className="glass-card">
                        <div className="card-header-plain">
                            <h4>Order Timeline</h4>
                        </div>
                        <div className="larkon-timeline-v2">
                            <div className="timeline-item-v2 completed">
                                <div className="dot-icon"><div className="dot"></div></div>
                                <div className="t-content">
                                    <p className="t-title">Order Received</p>
                                    <p className="t-desc">Wait for system confirmation</p>
                                </div>
                                <span className="t-date">{new Date(order.createdAt).toLocaleString()}</span>
                            </div>
                            {order.isPaid && (
                                <div className="timeline-item-v2 completed">
                                    <div className="dot-icon success"><Check size={14} /></div>
                                    <div className="t-content">
                                        <p className="t-title">Payment Confirmed</p>
                                        <p className="t-desc">Transaction processed via <span className="primary-text">{order.paymentMethod}</span></p>
                                        <button className="btn-link sm-btn mt-2">View Transaction</button>
                                    </div>
                                    <span className="t-date">{new Date(order.paidAt || order.createdAt).toLocaleString()}</span>
                                </div>
                            )}
                            <div className="timeline-item-v2">
                                <div className="dot-icon"><div className="dot"></div></div>
                                <div className="t-content">
                                    <p className="t-title">Shipping & Logistics</p>
                                    <p className="t-desc">{order.status === 'shipped' || order.status === 'delivered' ? 'Package is in transit or delivered.' : 'Inventory check and packaging started'}</p>
                                </div>
                                <span className="t-date">{order.status === 'shipped' || order.status === 'delivered' ? 'Completed' : 'Processing'}</span>
                            </div>
                            {order.status === 'delivered' && (
                                <div className="timeline-item-v2 completed">
                                    <div className="dot-icon success"><Check size={14} /></div>
                                    <div className="t-content">
                                        <p className="t-title">Package Delivered</p>
                                        <p className="t-desc">Order successfully received by the customer</p>
                                    </div>
                                    <span className="t-date">{new Date(order.updatedAt).toLocaleString()}</span>
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                {/* Right Sidebar (30%) */}
                <div className="larkon-sidebar">
                    {/* Order Summary */}
                    <div className="glass-card mb-4 summary-card-larkon">
                        <div className="card-header-plain">
                            <h4>Order Summary</h4>
                        </div>
                        <div className="summary-list">
                            <div className="summary-item">
                                <span className="label">Sub Total :</span>
                                <span className="val">${order.itemsPrice.toFixed(2)}</span>
                            </div>
                            <div className="summary-item">
                                <span className="label">Shipping Fee :</span>
                                <span className="val">${order.shippingPrice.toFixed(2)}</span>
                            </div>
                            <div className="summary-item">
                                <span className="label">Tax (15%) :</span>
                                <span className="val">${order.taxPrice.toFixed(2)}</span>
                            </div>
                            <div className="summary-total mt-4">
                                <span className="label">Total Amount</span>
                                <span className="val">${order.totalPrice.toFixed(2)}</span>
                            </div>
                        </div>
                    </div>

                    {/* Payment Information */}
                    <div className="glass-card mb-4">
                        <div className="card-header-plain">
                            <h4>Payment Information</h4>
                        </div>
                        <div className="payment-body">
                            <div className="card-details-l">
                                <CreditCard size={20} color="var(--primary)" />
                                <div className="card-text">
                                    <p className="brand-name">{order.paymentMethod}</p>
                                    <p className="card-number">xxxx xxxx xxxx 4242</p>
                                </div>
                                {order.isPaid && <CheckCircle size={16} color="var(--success)" className="ms-auto" />}
                            </div>
                            <div className="payment-meta mt-3">
                                <p>Transaction ID: <span className="text-highlight">#TRX-{(order._id.substring(18))}</span></p>
                                <p>Billing Name: <span className="text-highlight">{order.user?.name}</span></p>
                            </div>
                        </div>
                    </div>

                    {/* Customer Details */}
                    <div className="glass-card mb-4">
                        <div className="card-header-plain">
                            <h4>Customer Details</h4>
                        </div>
                        <div className="customer-body">
                            <div className="customer-profile-cell">
                                <div className="avatar-larkon">
                                    {order.user?.name?.charAt(0) || 'G'}
                                </div>
                                <div className="c-text">
                                    <h6>{order.user?.name}</h6>
                                    <p>{order.user?.email}</p>
                                </div>
                            </div>

                            <div className="info-section-l mt-4">
                                <div className="section-title">
                                    <span>Phone Number</span>
                                </div>
                                <p className="section-val">{order.shippingAddress.phone || 'No phone provided'}</p>
                            </div>

                            <div className="info-section-l mt-3">
                                <div className="section-title">
                                    <span>Shipping Address</span>
                                </div>
                                <p className="section-val">
                                    <strong>{order.shippingAddress.fullName || order.user?.name}</strong><br />
                                    {order.shippingAddress.address}<br />
                                    {order.shippingAddress.city}, {order.shippingAddress.postalCode}<br />
                                    {order.shippingAddress.country}
                                </p>
                            </div>
                        </div>
                    </div>

                    {/* Map Placeholder */}
                    <div className="glass-card p-0 overflow-hidden">
                        <div className="map-placeholder-l">
                            <img src="https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=400" alt="Map" />
                            <div className="map-overlay">
                                <MapPin size={16} /> <span>Live Tracking Area</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <style>{`
                .order-details-p-wrapper { padding: 4px; }

                /* Sub Header */
                .larkon-sub-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid var(--divider); }
                .title-row { display: flex; align-items: center; gap: 12px; margin-bottom: 8px; }
                .title-row h2 { color: var(--text-primary); font-size: 20px; font-weight: 800; }
                .back-btn-ghost { background: none; border: none; color: var(--text-secondary); width: 32px; height: 32px; border-radius: 8px; }
                .back-btn-ghost:hover { background: var(--surface); color: var(--primary); }

                .badge-larkon { font-size: 10px; font-weight: 800; text-transform: uppercase; padding: 4px 10px; border-radius: 6px; }
                .badge-larkon.paid { background: rgba(34, 197, 94, 0.1); color: var(--success); }
                .badge-larkon.unpaid { background: rgba(239, 68, 68, 0.1); color: var(--error); }
                .badge-larkon.status-tag { background: var(--primary-glow); color: var(--primary); }
                .badge-larkon.secondary { background: var(--surface-light); color: var(--text-secondary); }

                .breadcrumb-row { display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 600; color: var(--text-muted); }
                .breadcrumb-row a { color: var(--text-muted); text-decoration: none; }
                .breadcrumb-row a:hover { color: var(--primary); }
                .breadcrumb-row .date-sep { color: var(--divider); font-weight: 400; margin: 0 4px; }

                .header-actions { display: flex; gap: 10px; }
                .btn-outline-ghost { background: var(--surface); border: 1px solid var(--divider); color: var(--text-primary); font-size: 13px; font-weight: 700; padding: 8px 16px; border-radius: 8px; }
                .btn-outline-ghost:hover { border-color: var(--primary); color: var(--primary); }
                .action-edit { font-size: 13px; padding: 8px 16px; }

                /* Grid */
                .larkon-grid { display: grid; grid-template-columns: 1fr 340px; gap: 24px; }

                .card-header-plain { padding: 16px 20px; border-bottom: 1px solid var(--divider); }
                .card-header-plain h4 { font-size: 14px; font-weight: 700; color: var(--text-primary); }
                .mb-4 { margin-bottom: 24px; }
                .p-0 { padding: 0; }
                .overflow-hidden { overflow: hidden; }

                /* Progress */
                .larkon-progress-container { padding: 24px 30px; }
                .progress-track { display: grid; grid-template-columns: repeat(5, 1fr); gap: 12px; margin-bottom: 24px; }
                .progress-segment { position: relative; }
                .segment-bar { height: 6px; background: var(--surface-light); border-radius: 4px; margin-bottom: 10px; transition: 0.5s; }
                .progress-segment.completed .segment-bar { background: var(--success); }
                .progress-segment.active .segment-bar { background: var(--primary); }
                .segment-label { font-size: 10px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; white-space: nowrap; }
                .progress-segment.completed .segment-label { color: var(--text-primary); }

                .shipping-estimate { display: flex; align-items: center; justify-content: space-between; padding-top: 10px; border-top: 1px dashed var(--divider); }
                .est-info { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--text-secondary); }
                .sm-btn { padding: 8px 16px; font-size: 12px; height: 36px; }

                /* Table */
                .larkon-product-table { width: 100%; border-collapse: collapse; }
                .larkon-product-table th { text-align: left; padding: 12px 20px; font-size: 12px; font-weight: 700; color: var(--text-muted); background: var(--surface-light); text-transform: uppercase; }
                .larkon-product-table td { padding: 16px 20px; font-size: 13px; border-bottom: 1px solid var(--divider); color: var(--text-primary); }
                .product-item-cell { display: flex; align-items: center; gap: 12px; }
                .product-item-cell img { width: 44px; height: 44px; border-radius: 8px; background: #000; object-fit: contain; }
                .p-info { display: flex; flex-direction: column; }
                .p-name { font-weight: 700; font-size: 14px; margin-bottom: 2px; }
                .p-sku { font-size: 11px; color: var(--text-muted); }
                .fw-bold { font-weight: 800; color: var(--primary); }

                /* Timeline */
                .larkon-timeline-v2 { padding: 24px; }
                .timeline-item-v2 { display: flex; gap: 24px; position: relative; padding-bottom: 30px; }
                .timeline-item-v2::before { content: ''; position: absolute; left: 16px; top: 16px; bottom: 0; width: 1px; background: var(--divider); }
                .timeline-item-v2:last-child { padding-bottom: 0; }
                .timeline-item-v2:last-child::before { display: none; }
                .dot-icon { width: 32px; height: 32px; border-radius: 50%; background: var(--surface-light); display: flex; align-items: center; justify-content: center; z-index: 1; border: 1px solid var(--divider); color: var(--text-muted); }
                .dot-icon .dot { width: 8px; height: 8px; border-radius: 50%; background: var(--primary); }
                .dot-icon.success { background: var(--success); color: white; border-color: var(--success); }
                .t-content { flex: 1; }
                .t-title { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .t-desc { font-size: 12px; color: var(--text-muted); }
                .primary-text { color: var(--primary); font-weight: 600; }
                .t-date { font-size: 11px; color: var(--text-muted); min-width: 140px; text-align: right; }
                .btn-link { background: none; border: none; color: var(--primary); font-size: 11px; font-weight: 700; padding: 0; }

                /* Sidebar */
                .summary-list { padding: 20px; }
                .summary-item { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 13px; color: var(--text-secondary); font-weight: 600; }
                .summary-total { display: flex; justify-content: space-between; padding-top: 16px; border-top: 1px solid var(--divider); font-size: 16px; font-weight: 800; color: var(--text-primary); }
                .summary-total .val { color: var(--primary); }

                .payment-body { padding: 20px; }
                .card-details-l { display: flex; align-items: center; gap: 12px; background: var(--surface-light); padding: 12px; border-radius: 10px; }
                .brand-name { font-size: 13px; font-weight: 700; color: var(--text-primary); margin-bottom: 1px; }
                .card-number { font-size: 11px; color: var(--text-muted); }
                .payment-meta p { font-size: 12px; color: var(--text-muted); margin-top: 8px; }
                .text-highlight { color: var(--text-primary); font-weight: 700; }

                .customer-body { padding: 20px; }
                .customer-profile-cell { display: flex; align-items: center; gap: 12px; }
                .avatar-larkon { width: 42px; height: 42px; border-radius: 10px; background: var(--primary-glow); color: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: 800; }
                .c-text h6 { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 2px; }
                .c-text p { font-size: 12px; color: var(--text-muted); }
                .info-section-l .section-title { display: flex; justify-content: space-between; margin-bottom: 6px; font-size: 11px; font-weight: 800; color: var(--text-muted); text-transform: uppercase; }
                .section-val { font-size: 13px; color: var(--text-primary); line-height: 1.5; font-weight: 600; }
                .edit-icon { color: var(--primary); cursor: pointer; }

                .map-placeholder-l { height: 140px; position: relative; }
                .map-placeholder-l img { width: 100%; height: 100%; object-fit: cover; opacity: 0.7; }
                .map-overlay { position: absolute; inset: 0; background: linear-gradient(transparent, rgba(0,0,0,0.6)); display: flex; align-items: flex-end; padding: 12px; gap: 8px; color: white; font-size: 12px; font-weight: 700; }

                .larkon-loading { height: 60vh; display: flex; align-items: center; justify-content: center; }
                .spinner-larkon { width: 40px; height: 40px; border: 3px solid var(--surface-light); border-top-color: var(--primary); border-radius: 50%; animation: spin 0.8s linear infinite; }
                @keyframes spin { to { transform: rotate(360deg); } }

                .ms-auto { margin-left: auto; }
            `}</style>
        </div>
    );
};

export default OrderDetailPage;
