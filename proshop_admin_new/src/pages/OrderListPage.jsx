import React, { useState, useEffect } from 'react';
import { ordersAPI } from '../services/api';
import { toast } from 'react-hot-toast';
import { ShoppingCart, Eye, Clock, CheckCircle, Truck, XCircle, ChevronRight, Search, Filter, Download, Trash2 } from 'lucide-react';
import { Link } from 'react-router-dom';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import ConfirmModal from '../components/ConfirmModal';

const OrderListPage = () => {
    const [orders, setOrders] = useState([]);
    const [filteredOrders, setFilteredOrders] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchQuery, setSearchQuery] = useState('');
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [orderToDelete, setOrderToDelete] = useState(null);

    const generatePDF = () => {
        const doc = new jsPDF();
        doc.setFontSize(18);
        doc.setTextColor(255, 107, 0);
        doc.text('Orders Report', 14, 20);

        doc.setFontSize(10);
        doc.setTextColor(100);
        doc.text(`Generated on: ${new Date().toLocaleString()}`, 14, 28);
        doc.text(`Total Orders: ${orders.length}`, 14, 33);

        const tableColumn = ["Order ID", "Date", "Customer", "Total", "Payment", "Status"];
        const tableRows = orders.map(o => [
            `#${o._id.substring(o._id.length - 6).toUpperCase()}`,
            new Date(o.createdAt).toLocaleDateString(),
            o.user?.name || 'Guest',
            `$${o.totalPrice.toFixed(2)}`,
            o.isPaid ? 'Paid' : 'Pending',
            o.status.toUpperCase()
        ]);

        autoTable(doc, {
            startY: 40,
            head: [tableColumn],
            body: tableRows,
            theme: 'striped',
            headStyles: { fillColor: [255, 107, 0], textColor: [255, 255, 255] },
            styles: { fontSize: 8 }
        });

        doc.save(`orders-report-${new Date().getTime()}.pdf`);
    };

    useEffect(() => {
        const fetchOrders = async () => {
            try {
                const response = await ordersAPI.getAll();
                const fetchedOrders = response.data.data.orders;
                setOrders(fetchedOrders);
                setFilteredOrders(fetchedOrders);
            } catch (error) {
                console.error(error);
                toast.error('Failed to load orders');
            } finally {
                setLoading(false);
            }
        };
        fetchOrders();
    }, []);

    // Search functionality
    useEffect(() => {
        if (!searchQuery.trim()) {
            setFilteredOrders(orders);
            return;
        }

        const query = searchQuery.toLowerCase();
        const filtered = orders.filter(order => {
            const orderId = order._id.substring(order._id.length - 6).toUpperCase();
            const customerName = (order.user?.name || '').toLowerCase();
            const city = (order.shippingAddress?.city || '').toLowerCase();
            const country = (order.shippingAddress?.country || '').toLowerCase();
            const status = (order.status || '').toLowerCase();
            const total = order.totalPrice.toFixed(2);

            return orderId.toLowerCase().includes(query) ||
                customerName.includes(query) ||
                city.includes(query) ||
                country.includes(query) ||
                status.includes(query) ||
                total.includes(query);
        });

        setFilteredOrders(filtered);
    }, [searchQuery, orders]);

    const handleDeleteClick = (orderId) => {
        setOrderToDelete(orderId);
        setIsModalOpen(true);
    };

    const confirmDelete = async () => {
        if (!orderToDelete) return;

        try {
            await ordersAPI.delete(orderToDelete);
            const updatedOrders = orders.filter(order => order._id !== orderToDelete);
            setOrders(updatedOrders);
            setFilteredOrders(updatedOrders.filter(order => {
                if (!searchQuery.trim()) return true;
                const query = searchQuery.toLowerCase();
                const orderId = order._id.substring(order._id.length - 6).toUpperCase();
                return orderId.toLowerCase().includes(query) ||
                    (order.user?.name || '').toLowerCase().includes(query);
            }));
            toast.success('Order deleted successfully!');
        } catch (error) {
            console.error('Delete failed:', error);
            toast.error('Failed to delete order');
        }
    };

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
                    <button className="larkon-btn btn-primary" onClick={generatePDF}>
                        <Download size={18} /> Export PDF
                    </button>
                </div>
            </div>

            <div className="table-container glass-card">
                <div className="table-header-row">
                    <h4>All Orders ({filteredOrders.length})</h4>
                    <div className="cool-search-box">
                        <Search size={18} className="search-icon" />
                        <input
                            type="text"
                            placeholder="Search by ID, customer, location, status..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                        />
                        {searchQuery && (
                            <button
                                className="clear-search"
                                onClick={() => setSearchQuery('')}
                            >
                                <XCircle size={16} />
                            </button>
                        )}
                    </div>
                </div>

                <div className="table-responsive">
                    <table className="proshop-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Created at</th>
                                <th>Customer</th>
                                <th>Shipping To</th>
                                <th>Total</th>
                                <th>Payment Statistics</th>
                                <th>Method</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredOrders.map((order) => (
                                <tr key={order._id}>
                                    <td className="order-id">#{order._id.substring(order._id.length - 6).toUpperCase()}</td>
                                    <td>{new Date(order.createdAt).toLocaleDateString()}</td>
                                    <td>
                                        <div className="customer-cell">
                                            <img src={`https://ui-avatars.com/api/?name=${order.user?.name || 'G'}&background=ff6b00&color=fff`} alt="" />
                                            <span>{order.user?.name || 'Guest'}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div className="location-cell">
                                            <span className="city">{order.shippingAddress?.city || 'N/A'}</span>
                                            <span className="country">{order.shippingAddress?.country || 'N/A'}</span>
                                        </div>
                                    </td>
                                    <td className="order-total">${order.totalPrice.toFixed(2)}</td>
                                    <td>
                                        <span className={`payment-status ${order.isPaid ? 'success' : 'pending'}`}>
                                            {order.isPaid ? 'Success' : 'Pending'}
                                        </span>
                                    </td>
                                    <td className="payment-method">{order.paymentMethod || 'N/A'}</td>
                                    <td>{getStatusBadge(order.status || 'pending')}</td>
                                    <td>
                                        <div className="action-btns">
                                            <Link to={`/orders/details/${order._id}`} className="action-btn view"><Eye size={16} /></Link>
                                            <button
                                                className="action-btn delete"
                                                onClick={() => handleDeleteClick(order._id)}
                                            >
                                                <Trash2 size={16} />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>

                <div className="table-footer">
                    <div className="footer-info">Showing {filteredOrders.length} of {orders.length} entries{searchQuery && ` (filtered)`}</div>
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
                /* .search-box removed as per instructions */

                .proshop-table { width: 100%; border-collapse: collapse; }
                .proshop-table th { text-align: left; padding: 12px 24px; font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; border-bottom: 1px solid var(--divider); }
                .proshop-table td { padding: 16px 24px; border-bottom: 1px solid var(--divider); vertical-align: middle; font-size: 13px; }
                
                .order-id { font-weight: 700; color: #3b82f6; }
                .customer-cell { display: flex; align-items: center; gap: 10px; }
                .customer-cell img { width: 32px; height: 32px; border-radius: 50%; }
                .customer-cell span { font-weight: 600; color: var(--text-primary); }

                .location-cell { display: flex; flex-direction: column; }
                .location-cell .city { font-weight: 600; color: var(--text-primary); font-size: 13px; }
                .location-cell .country { font-size: 11px; color: var(--text-muted); }
                
                .order-total { font-weight: 700; color: var(--text-primary); }

                .payment-status { font-size: 12px; font-weight: 600; }
                .payment-status.success { color: var(--success); }
                .payment-status.pending { color: #f59e0b; }

                .payment-method { font-weight: 600; color: var(--text-secondary); font-size: 12px; }

                .status-badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 600; width: fit-content; }
                .status-badge.success { background: rgba(34, 197, 94, 0.1); color: var(--success); }
                .status-badge.warning { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
                .status-badge.info { background: rgba(59, 130, 246, 0.1); color: #3b82f6; }
                .status-badge.error { background: rgba(239, 68, 68, 0.1); color: var(--error); }

                .action-btns { display: flex; gap: 8px; }
                .action-btn { width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; background: var(--surface); color: var(--text-secondary); transition: var(--transition); }
                .action-btn.view:hover { color: var(--primary); background: rgba(255, 107, 0, 0.1); }
                .action-btn.delete:hover { color: var(--error); background: rgba(239, 68, 68, 0.1); }

                .table-footer { padding: 20px 24px; font-size: 13px; color: var(--text-muted); }
                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }

                /* Cool Search Box Styles */
                .cool-search-box {
                    position: relative;
                    display: flex;
                    align-items: center;
                    background: linear-gradient(135deg, rgba(255, 107, 0, 0.05), rgba(255, 150, 50, 0.03));
                    border: 1px solid rgba(255, 107, 0, 0.2);
                    border-radius: 12px;
                    padding: 0 16px;
                    transition: all 0.3s ease;
                    min-width: 350px;
                }

                .cool-search-box:focus-within {
                    background: linear-gradient(135deg, rgba(255, 107, 0, 0.1), rgba(255, 150, 50, 0.05));
                    border-color: var(--primary);
                    box-shadow: 0 0 0 3px rgba(255, 107, 0, 0.1),
                                0 4px 12px rgba(255, 107, 0, 0.15);
                    transform: translateY(-1px);
                }

                .cool-search-box .search-icon {
                    color: var(--primary);
                    transition: all 0.3s ease;
                }

                .cool-search-box:focus-within .search-icon {
                    transform: scale(1.1);
                }

                .cool-search-box input {
                    flex: 1;
                    background: transparent;
                    border: none;
                    outline: none;
                    color: var(--text-primary);
                    font-size: 14px;
                    padding: 12px 12px 12px 12px;
                }

                .cool-search-box input::placeholder {
                    color: var(--text-muted);
                }

                .clear-search {
                    background: rgba(255, 107, 0, 0.1);
                    border: none;
                    border-radius: 6px;
                    width: 26px;
                    height: 26px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: var(--primary);
                    cursor: pointer;
                    transition: all 0.2s;
                }

                .clear-search:hover {
                    background: rgba(255, 107, 0, 0.2);
                    transform: rotate(90deg);
                }
            `}</style>

            <ConfirmModal
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
                onConfirm={confirmDelete}
                title="Delete Order?"
                message="Are you sure you want to delete this order? This action cannot be undone."
                confirmText="Delete"
                type="danger"
            />
        </div >
    );
};

export default OrderListPage;
