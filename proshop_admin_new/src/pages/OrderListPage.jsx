import React, { useState, useEffect } from 'react';
import { ordersAPI } from '../services/api';
import { ShoppingCart, Eye, Clock, CheckCircle, Truck, XCircle, ChevronRight, Search, Filter } from 'lucide-react';
import { Link } from 'react-router-dom';

const OrderListPage = () => {
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchOrders = async () => {
            try {
                const response = await ordersAPI.getAll();
                setOrders(response.data.data.orders);
            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };
        fetchOrders();
    }, []);

    const getStatusBadge = (status) => {
        switch (status) {
            case 'pending': return <span className="status-badge warning">Pending</span>;
            case 'delivered': return <span className="status-badge success">Delivered</span>;
            case 'shipped': return <span className="status-badge info">Shipped</span>;
            case 'cancelled': return <span className="status-badge error">Cancelled</span>;
            default: return <span className="status-badge warning">Pending</span>;
        }
    };

    if (loading) return <div className="loading-state">Loading order list...</div>;

    return (
        <div className="order-list-page fade-in">
            <div className="page-header">
                <div className="header-left">
                    <h1>ORDERS LIST</h1>
                    <div className="breadcrumb">
                        <span>List</span> <ChevronRight size={14} /> <span>All Orders</span>
                    </div>
                </div>
                <div className="header-actions">
                    <button className="btn-icon"><Filter size={18} /></button>
                </div>
            </div>

            <div className="table-container glass-card">
                <div className="table-header-row">
                    <h4>All Orders ({orders.length})</h4>
                    <div className="search-box">
                        <Search size={18} />
                        <input type="text" placeholder="Search orders..." />
                    </div>
                </div>

                <div className="table-responsive">
                    <table className="proshop-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Created at</th>
                                <th>Customer</th>
                                <th>Priority</th>
                                <th>Total</th>
                                <th>Payment Statistics</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {orders.map((order) => (
                                <tr key={order._id}>
                                    <td className="order-id">#{order._id.substring(order._id.length - 6).toUpperCase()}</td>
                                    <td>{new Date(order.createdAt).toLocaleDateString()}</td>
                                    <td>
                                        <div className="customer-cell">
                                            <img src={`https://ui-avatars.com/api/?name=${order.user?.name || 'G'}&background=ff6b00&color=fff`} alt="" />
                                            <span>{order.user?.name || 'Guest'}</span>
                                        </div>
                                    </td>
                                    <td><span className="priority-tag high">High</span></td>
                                    <td className="order-total">${order.totalPrice.toFixed(2)}</td>
                                    <td>
                                        <span className={`payment-status ${order.isPaid ? 'success' : 'pending'}`}>
                                            {order.isPaid ? 'Success' : 'Pending'}
                                        </span>
                                    </td>
                                    <td>{getStatusBadge(order.status || 'pending')}</td>
                                    <td>
                                        <div className="action-btns">
                                            <button className="action-btn view"><Eye size={16} /></button>
                                            <button className="action-btn delete"><XCircle size={16} /></button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>

                <div className="table-footer">
                    <div className="footer-info">Showing 1 to {orders.length} of {orders.length} entries</div>
                </div>
            </div>

            <style>{`
                .order-list-page { padding: 0; }
                .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .page-header h1 { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }

                .table-container { padding: 0; overflow: hidden; }
                .table-header-row { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--divider); }
                .table-header-row h4 { font-size: 15px; font-weight: 700; color: var(--text-primary); }
                .search-box { display: flex; align-items: center; gap: 12px; padding: 0 16px; height: 36px; width: 250px; background: var(--surface-light); border-radius: 6px; border: 1px solid var(--divider); }
                .search-box input { background: transparent; border: none; outline: none; color: var(--text-primary); width: 100%; font-size: 13px; }

                .proshop-table { width: 100%; border-collapse: collapse; }
                .proshop-table th { text-align: left; padding: 12px 24px; font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; border-bottom: 1px solid var(--divider); }
                .proshop-table td { padding: 16px 24px; border-bottom: 1px solid var(--divider); vertical-align: middle; font-size: 13px; }
                
                .order-id { font-weight: 700; color: #3b82f6; }
                .customer-cell { display: flex; align-items: center; gap: 10px; }
                .customer-cell img { width: 32px; height: 32px; border-radius: 50%; }
                .customer-cell span { font-weight: 600; color: var(--text-primary); }

                .priority-tag { font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 4px; }
                .priority-tag.high { background: rgba(239, 68, 68, 0.1); color: var(--error); }
                
                .order-total { font-weight: 700; color: var(--text-primary); }

                .payment-status { font-size: 12px; font-weight: 600; }
                .payment-status.success { color: var(--success); }
                .payment-status.pending { color: #f59e0b; }

                .status-badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 600; width: fit-content; }
                .status-badge.success { background: rgba(34, 197, 94, 0.1); color: var(--success); }
                .status-badge.warning { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
                .status-badge.info { background: rgba(59, 130, 246, 0.1); color: #3b82f6; }
                .status-badge.error { background: rgba(239, 68, 68, 0.1); color: var(--error); }

                .action-btns { display: flex; gap: 8px; }
                .action-btn { width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; background: var(--surface-light); color: var(--text-secondary); transition: var(--transition); }
                .action-btn.view:hover { color: var(--primary); background: rgba(255, 107, 0, 0.1); }
                .action-btn.delete:hover { color: var(--error); background: rgba(239, 68, 68, 0.1); }

                .table-footer { padding: 20px 24px; font-size: 13px; color: var(--text-muted); }
                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }
            `}</style>
        </div>
    );
};

export default OrderListPage;
