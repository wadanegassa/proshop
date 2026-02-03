import React, { useState, useEffect, useCallback } from 'react';
import { notificationsAPI } from '../services/api';
import Toast from '../components/Toast';
import { ShoppingBag, Bell, AlertTriangle, User, Check, Trash2, ChevronRight, Settings, Square, CheckSquare, Search, Filter, RefreshCw } from 'lucide-react';

const AdminNotificationsPage = () => {
    const [notifications, setNotifications] = useState([]);
    const [isLoading, setIsLoading] = useState(true);
    const [isRefreshing, setIsRefreshing] = useState(false);
    const [selectedIds, setSelectedIds] = useState([]);
    const [showConfirm, setShowConfirm] = useState(false);
    const [searchTerm, setSearchTerm] = useState('');
    const [toast, setToast] = useState(null);

    const fetchAllNotifications = useCallback(async (manual = false) => {
        if (manual) setIsRefreshing(true);
        else setIsLoading(true);

        try {
            const response = await notificationsAPI.adminGetAll();
            setNotifications(response.data.data.notifications);
        } catch (error) {
            console.error('Failed to fetch all notifications:', error);
        } finally {
            setIsLoading(false);
            if (manual) setTimeout(() => setIsRefreshing(false), 600);
        }
    }, []);

    useEffect(() => {
        fetchAllNotifications();
    }, [fetchAllNotifications]);

    const getIcon = (type) => {
        switch (type) {
            case 'order': return <ShoppingBag size={18} />;
            case 'alert': return <AlertTriangle size={18} />;
            case 'user': return <User size={18} />;
            default: return <Bell size={18} />;
        }
    };

    const getIconColor = (type) => {
        switch (type) {
            case 'order': return '#ff6b00';
            case 'alert': return '#ef4444';
            case 'user': return '#3b82f6';
            default: return '#ff6b00';
        }
    };

    const handleSelectOne = (id) => {
        setSelectedIds(prev =>
            prev.includes(id) ? prev.filter(i => i !== id) : [...prev, id]
        );
    };

    const handleSelectAll = () => {
        if (selectedIds.length === filteredNotifications.length) {
            setSelectedIds([]);
        } else {
            setSelectedIds(filteredNotifications.map(n => n._id));
        }
    };

    const handleDeleteSelected = async () => {
        if (window.confirm(`Are you sure you want to delete ${selectedIds.length} notifications?`)) {
            try {
                await notificationsAPI.deleteMultiple(selectedIds);
                setNotifications(prev => prev.filter(n => !selectedIds.includes(n._id)));
                setToast({ message: `${selectedIds.length} notifications deleted permanently.`, type: 'success' });
                setSelectedIds([]);
            } catch (error) {
                console.error(error);
                setToast({ message: 'Failed to delete selected notifications.', type: 'error' });
                fetchAllNotifications();
            }
        }
    };

    const handleDeleteOne = async (id) => {
        try {
            await notificationsAPI.deleteOne(id);
            setNotifications(prev => prev.filter(n => n._id !== id));
            setSelectedIds(prev => prev.filter(i => i !== id));
            setToast({ message: 'Notification deleted permanently.', type: 'success' });
        } catch (error) {
            console.error(error);
            setToast({ message: 'Failed to delete notification.', type: 'error' });
            fetchAllNotifications();
        }
    };

    const handleClearAll = () => setShowConfirm(true);

    const confirmClearAll = async () => {
        try {
            await notificationsAPI.clearAll();
            setNotifications([]);
            setSelectedIds([]);
            setShowConfirm(false);
            setToast({ message: 'All system notifications cleared.', type: 'success' });
        } catch (error) {
            console.error(error);
            setToast({ message: 'Failed to clear system notifications.', type: 'error' });
        }
    };

    const filteredNotifications = notifications.filter(n =>
        n.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        n.message.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (n.user?.name || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
        (n.user?.email || '').toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="admin-notifications-page fade-in">
            {toast && <Toast message={toast.message} type={toast.type} onClose={() => setToast(null)} />}
            <div className="page-header">
                <div className="header-left">
                    <h1>SYSTEM NOTIFICATIONS</h1>
                    <div className="breadcrumb">
                        <span>Admin</span> <ChevronRight size={14} /> <span>System Notifications</span>
                    </div>
                </div>
                <div className="header-actions">
                    <button className="btn-icon refresh-btn" onClick={() => fetchAllNotifications(true)} title="Refresh System Notifications">
                        <RefreshCw size={18} className={isRefreshing ? 'spin' : ''} />
                    </button>
                </div>
            </div>

            <div className="filter-bar glass-card mb-4">
                <div className="search-box">
                    <Search size={18} />
                    <input
                        type="text"
                        placeholder="Search by title, message, user name or email..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
                <div className="stats-badges">
                    <div className="stat-badge">
                        <span className="label">Total System-wide</span>
                        <span className="value">{notifications.length}</span>
                    </div>
                </div>
            </div>

            <div className="glass-card notif-container">
                <div className="container-header">
                    <div className="select-all-section">
                        {filteredNotifications.length > 0 && (
                            <button className="select-all-btn" onClick={handleSelectAll}>
                                {selectedIds.length === filteredNotifications.length && filteredNotifications.length > 0
                                    ? <CheckSquare size={20} color="var(--primary)" />
                                    : <Square size={20} color="var(--text-muted)" />
                                }
                                <span>{selectedIds.length > 0 ? `${selectedIds.length} Selected` : 'Select All'}</span>
                            </button>
                        )}
                        <h4 style={{ marginLeft: '12px' }}>All User Alerts</h4>
                    </div>
                    <div className="header-btns">
                        {selectedIds.length > 0 ? (
                            <button className="btn-text danger" onClick={handleDeleteSelected}>
                                <Trash2 size={16} /> Delete Selected
                            </button>
                        ) : (
                            <button className="btn-text danger" onClick={handleClearAll}>Clear All System</button>
                        )}
                    </div>
                </div>

                {isLoading ? (
                    <div className="loading-state">
                        <div className="spinner"></div>
                        <p>Fetching system notifications...</p>
                    </div>
                ) : filteredNotifications.length === 0 ? (
                    <div className="empty-state">
                        <div className="empty-icon-box">
                            <Bell size={40} />
                        </div>
                        <h4>No Notifications Found</h4>
                        <p>{searchTerm ? 'Try a different search term' : 'The system has no notifications at the moment'}</p>
                    </div>
                ) : (
                    <div className="notif-list">
                        {filteredNotifications.map((n) => (
                            <div key={n._id} className={`notif-item ${selectedIds.includes(n._id) ? 'selected' : ''}`}>
                                <div className="notif-checkbox" onClick={() => handleSelectOne(n._id)}>
                                    {selectedIds.includes(n._id)
                                        ? <CheckSquare size={20} color="var(--primary)" />
                                        : <Square size={20} color="var(--text-muted)" />
                                    }
                                </div>
                                <div className="notif-icon-wrapper" style={{ background: `${getIconColor(n.type)}15`, color: getIconColor(n.type) }}>
                                    {getIcon(n.type)}
                                </div>
                                <div className="notif-body">
                                    <div className="notif-title-row">
                                        <div className="title-group">
                                            <h5 className="notif-title">{n.title}</h5>
                                            <div className="user-tag">
                                                <User size={10} />
                                                <span>{n.user?.name || 'Unknown'} ({n.user?.email || 'No email'})</span>
                                            </div>
                                        </div>
                                        <span className="notif-date">{new Date(n.createdAt).toLocaleString()}</span>
                                    </div>
                                    <p className="notif-text">{n.message}</p>
                                </div>
                                <div className="notif-actions">
                                    <button className="delete-btn-single" onClick={() => handleDeleteOne(n._id)}>
                                        <Trash2 size={16} />
                                    </button>
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>

            {showConfirm && (
                <div className="confirm-modal-overlay">
                    <div className="glass-card confirm-modal">
                        <div className="warn-icon"><AlertTriangle size={32} /></div>
                        <h3>WIPE ALL NOTIFICATIONS?</h3>
                        <p>This is a system-wide action. Every notification for EVERY user will be deleted permanently.</p>
                        <div className="modal-btns">
                            <button className="btn-cancel" onClick={() => setShowConfirm(false)}>Cancel</button>
                            <button className="btn-confirm" onClick={confirmClearAll}>Yes, Delete Everything</button>
                        </div>
                    </div>
                </div>
            )}

            <style>{`
                .admin-notifications-page { padding: 0; }
                .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .page-header h1 { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                
                .btn-icon { width: 40px; height: 40px; border-radius: 8px; background: var(--surface); color: var(--text-primary); display: flex; align-items: center; justify-content: center; cursor: pointer; border: 1px solid var(--divider); transition: var(--transition); }
                .btn-icon:hover { background: var(--surface-light); border-color: var(--primary); color: var(--primary); }
                .refresh-btn:active { transform: scale(0.9); }
                
                .spin { animation: spin 0.6s linear infinite; }
                @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
                
                .filter-bar { padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; gap: 20px; }
                .search-box { flex: 1; display: flex; align-items: center; gap: 12px; background: rgba(255,255,255,0.03); border: 1px solid var(--divider); border-radius: 12px; padding: 10px 16px; transition: var(--transition); }
                .search-box:focus-within { border-color: var(--primary); background: rgba(255,255,255,0.05); }
                .search-box input { background: transparent; border: none; font-size: 13px; color: var(--text-primary); width: 100%; outline: none; }
                
                .stats-badges { display: flex; gap: 12px; }
                .stat-badge { background: var(--surface-light); border: 1px solid var(--divider); padding: 8px 16px; border-radius: 10px; display: flex; flex-direction: column; align-items: flex-end; }
                .stat-badge .label { font-size: 10px; color: var(--text-muted); text-transform: uppercase; font-weight: 700; }
                .stat-badge .value { font-size: 16px; color: var(--primary); font-weight: 800; }

                .notif-container { padding: 0; overflow: hidden; }
                .container-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--divider); background: var(--surface-light); }
                .select-all-section { display: flex; align-items: center; }
                .select-all-btn { background: transparent; border: none; display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 8px; border-radius: 8px; }
                .select-all-btn span { font-size: 13px; font-weight: 600; color: var(--text-primary); }
                
                .header-btns { display: flex; gap: 16px; }
                .btn-text { background: transparent; border: none; font-size: 12px; font-weight: 600; color: var(--primary); cursor: pointer; display: flex; align-items: center; gap: 6px; }
                .btn-text.danger { color: #ef4444; }

                .notif-list { display: flex; flex-direction: column; }
                .notif-item { display: flex; align-items: center; gap: 16px; padding: 16px 24px; border-bottom: 1px solid var(--divider); transition: var(--transition); }
                .notif-item:hover { background: rgba(255, 255, 255, 0.02); }
                .notif-item.selected { background: rgba(255, 107, 0, 0.05); }
                
                .notif-checkbox { cursor: pointer; }
                .notif-icon-wrapper { width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
                
                .notif-body { flex: 1; }
                .notif-title-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 6px; }
                .title-group { display: flex; flex-direction: column; gap: 4px; }
                .notif-title { font-size: 13px; font-weight: 700; color: var(--text-primary); }
                .user-tag { display: flex; align-items: center; gap: 4px; font-size: 10px; color: var(--text-muted); background: var(--surface); padding: 2px 8px; border-radius: 4px; width: fit-content; }
                .notif-date { font-size: 11px; color: var(--text-muted); }
                .notif-text { font-size: 12px; color: var(--text-secondary); line-height: 1.5; }

                .delete-btn-single { width: 32px; height: 32px; border-radius: 6px; background: transparent; border: none; color: var(--text-muted); display: flex; align-items: center; justify-content: center; cursor: pointer; }
                .delete-btn-single:hover { background: #ef444415; color: #ef4444; }

                .loading-state { padding: 60px; text-align: center; }
                .spinner { width: 40px; height: 40px; border: 3px solid var(--divider); border-top-color: var(--primary); border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 16px; }
                @keyframes spin { to { transform: rotate(360deg); } }
                .loading-state p { color: var(--text-muted); font-size: 14px; }

                .confirm-modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.6); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 1000; padding: 20px; }
                .confirm-modal { max-width: 400px; width: 100%; padding: 32px; text-align: center; }
                .warn-icon { width: 64px; height: 64px; background: #ef444415; color: #ef4444; border-radius: 20px; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; }
                .confirm-modal h3 { font-size: 20px; font-weight: 800; color: var(--text-primary); margin-bottom: 12px; }
                .confirm-modal p { font-size: 14px; color: var(--text-muted); line-height: 1.6; margin-bottom: 24px; }
                .modal-btns { display: flex; gap: 12px; }
                .modal-btns button { flex: 1; padding: 12px; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; border: none; }
                .btn-cancel { background: var(--surface); color: var(--text-primary); }
                .btn-confirm { background: #ef4444; color: white; }

                .empty-state { padding: 80px 40px; text-align: center; }
                .empty-icon-box { width: 80px; height: 80px; background: var(--surface-light); color: var(--text-muted); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; }
                .empty-state h4 { font-size: 18px; font-weight: 700; color: var(--text-primary); margin-bottom: 8px; }
                .empty-state p { font-size: 14px; color: var(--text-muted); }
                .mb-4 { margin-bottom: 1.5rem; }
                .fade-in { animation: fadeIn 0.4s ease-out; }
                @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
                .spin { animation: spin 1s linear infinite; }
            `}</style>
        </div>
    );
};

export default AdminNotificationsPage;
