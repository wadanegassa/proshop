import React, { useState } from 'react';
import { useNotifications } from '../context/NotificationContext';
import { ShoppingBag, Bell, AlertTriangle, User, Check, Trash2, ChevronRight, RefreshCw, Square, CheckSquare } from 'lucide-react';

const NotificationsPage = () => {
    const {
        notifications,
        markAsRead,
        markAllAsRead,
        clearAll,
        deleteNotification,
        deleteSelectedNotifications,
        refresh
    } = useNotifications();

    const [selectedIds, setSelectedIds] = useState([]);
    const [showConfirm, setShowConfirm] = useState(false);
    const [isRefreshing, setIsRefreshing] = useState(false);

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
        if (selectedIds.length === notifications.length) {
            setSelectedIds([]);
        } else {
            setSelectedIds(notifications.map(n => n._id));
        }
    };

    const handleDeleteSelected = () => {
        if (window.confirm(`Are you sure you want to delete ${selectedIds.length} notifications?`)) {
            deleteSelectedNotifications(selectedIds);
            setSelectedIds([]);
        }
    };

    const handleClearAll = () => {
        setShowConfirm(true);
    };

    const confirmClearAll = async () => {
        await clearAll();
        setShowConfirm(false);
    };

    const handleRefresh = async () => {
        setIsRefreshing(true);
        await refresh();
        setTimeout(() => setIsRefreshing(false), 600);
    };

    return (
        <div className="notifications-page fade-in">
            <div className="page-header">
                <div className="header-left">
                    <h1>NOTIFICATIONS</h1>
                    <div className="breadcrumb">
                        <span>Admin</span> <ChevronRight size={14} /> <span>Notifications</span>
                    </div>
                </div>
                <div className="header-actions">
                    <button className="btn-icon refresh-btn" onClick={handleRefresh} title="Refresh Notifications">
                        <RefreshCw size={18} className={isRefreshing ? 'spin' : ''} />
                    </button>
                </div>
            </div>

            <div className="glass-card notif-container">
                <div className="container-header">
                    <div className="select-all-section">
                        {notifications.length > 0 && (
                            <button className="select-all-btn" onClick={handleSelectAll}>
                                {selectedIds.length === notifications.length && notifications.length > 0
                                    ? <CheckSquare size={20} color="var(--primary)" />
                                    : <Square size={20} color="var(--text-muted)" />
                                }
                                <span>{selectedIds.length > 0 ? `${selectedIds.length} Selected` : 'Select All'}</span>
                            </button>
                        )}
                        <div className="header-info">
                            <h4>Notification Center</h4>
                            <p>Total {notifications.length} notifications</p>
                        </div>
                    </div>
                    <div className="header-btns">
                        {selectedIds.length > 0 ? (
                            <button className="btn-text danger" onClick={handleDeleteSelected}>
                                <Trash2 size={16} style={{ marginRight: '6px' }} /> Delete Selected
                            </button>
                        ) : (
                            <>
                                <button className="btn-text" onClick={markAllAsRead}>Mark all as read</button>
                                <button className="btn-text danger" onClick={handleClearAll}>Clear all</button>
                            </>
                        )}
                    </div>
                </div>

                {notifications.length === 0 ? (
                    <div className="empty-state">
                        <div className="empty-icon-box">
                            <Bell size={40} />
                        </div>
                        <h4>No Notifications Yet</h4>
                        <p>When you have alerts, they will appear here</p>
                    </div>
                ) : (
                    <div className="notif-list">
                        {notifications.map((n) => (
                            <div key={n._id} className={`notif-item ${n.read ? 'read' : 'unread'} ${selectedIds.includes(n._id) ? 'selected' : ''}`}>
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
                                        <h5 className="notif-title">{n.title}</h5>
                                        <span className="notif-date">{new Date(n.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                                    </div>
                                    <p className="notif-text">{n.message}</p>
                                </div>
                                <div className="notif-actions">
                                    {!n.read && (
                                        <button className="mark-btn" onClick={() => markAsRead(n._id)}>
                                            <Check size={16} /> Mark Read
                                        </button>
                                    )}
                                    <button className="delete-btn-single" onClick={() => deleteNotification(n._id)}>
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
                        <h3>Clear All Notifications?</h3>
                        <p>This action will permanently delete all your notifications. This cannot be undone.</p>
                        <div className="modal-btns">
                            <button className="btn-cancel" onClick={() => setShowConfirm(false)}>Cancel</button>
                            <button className="btn-confirm" onClick={confirmClearAll}>Yes, Clear All</button>
                        </div>
                    </div>
                </div>
            )}

            <style>{`
                .notifications-page { padding: 0; }
                .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .page-header h1 { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                .btn-icon { width: 40px; height: 40px; border-radius: 8px; background: var(--surface); color: var(--text-primary); display: flex; align-items: center; justify-content: center; cursor: pointer; border: 1px solid var(--divider); transition: var(--transition); }
                .btn-icon:hover { background: var(--surface-light); border-color: var(--primary); color: var(--primary); }
                .refresh-btn:active { transform: scale(0.9); }
                
                .spin { animation: spin 0.6s linear infinite; }
                @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
                
                .notif-container { padding: 0; overflow: hidden; }
                .container-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--divider); background: var(--surface-light); }
                .select-all-section { display: flex; align-items: center; gap: 20px; }
                .select-all-btn { background: transparent; border: none; display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 8px; border-radius: 8px; transition: var(--transition); }
                .select-all-btn:hover { background: rgba(255, 107, 0, 0.05); }
                .select-all-btn span { font-size: 13px; font-weight: 600; color: var(--text-primary); }
                
                .header-info h4 { font-size: 15px; font-weight: 700; color: var(--text-primary); }
                .header-info p { font-size: 11px; color: var(--text-muted); margin-top: 2px; }
                
                .header-btns { display: flex; gap: 16px; align-items: center; }
                .btn-text { background: transparent; border: none; font-size: 12px; font-weight: 600; color: var(--primary); cursor: pointer; display: flex; align-items: center; }
                .btn-text.danger { color: #ef4444; }

                .notif-list { display: flex; flex-direction: column; }
                .notif-item { display: flex; align-items: center; gap: 16px; padding: 16px 24px; border-bottom: 1px solid var(--divider); transition: var(--transition); position: relative; }
                .notif-item:last-child { border-bottom: none; }
                .notif-item:hover { background: rgba(255, 255, 255, 0.02); }
                .notif-item.unread { background: rgba(255, 107, 0, 0.02); }
                .notif-item.selected { background: rgba(255, 107, 0, 0.05); }
                
                .notif-checkbox { cursor: pointer; padding: 4px; display: flex; align-items: center; justify-content: center; }
                .notif-icon-wrapper { width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
                
                .notif-body { flex: 1; }
                .notif-title-row { display: flex; justify-content: space-between; margin-bottom: 4px; }
                .notif-title { font-size: 13px; font-weight: 700; color: var(--text-primary); }
                .notif-date { font-size: 11px; color: var(--text-muted); }
                .notif-text { font-size: 12px; color: var(--text-secondary); line-height: 1.5; }

                .notif-actions { display: flex; gap: 8px; align-items: center; margin-left:16px;}
                .mark-btn { background: var(--surface-light); color: var(--text-primary); border: 1px solid var(--divider); padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 600; display: flex; align-items: center; gap: 5px; cursor: pointer; }
                .mark-btn:hover { background: var(--primary); border-color: var(--primary); color: white; }
                
                .delete-btn-single { width: 32px; height: 32px; border-radius: 6px; background: transparent; border: none; color: var(--text-muted); display: flex; align-items: center; justify-content: center; cursor: pointer; transition: var(--transition); }
                .delete-btn-single:hover { background: #ef444415; color: #ef4444; }

                .confirm-modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.6); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 1000; padding: 20px; }
                .confirm-modal { max-width: 400px; width: 100%; padding: 32px; text-align: center; }
                .warn-icon { width: 64px; height: 64px; background: #ef444415; color: #ef4444; border-radius: 20px; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; }
                .confirm-modal h3 { font-size: 20px; font-weight: 800; color: var(--text-primary); margin-bottom: 12px; }
                .confirm-modal p { font-size: 14px; color: var(--text-muted); line-height: 1.6; margin-bottom: 24px; }
                .modal-btns { display: flex; gap: 12px; }
                .modal-btns button { flex: 1; padding: 12px; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; transition: var(--transition); border: none; }
                .btn-cancel { background: var(--surface); color: var(--text-primary); }
                .btn-cancel:hover { background: var(--surface-light); }
                .btn-confirm { background: #ef4444; color: white; }
                .btn-confirm:hover { background: #dc2626; box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3); }

                .empty-state { padding: 80px 40px; text-align: center; }
                .empty-icon-box { width: 80px; height: 80px; background: var(--surface-light); color: var(--text-muted); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; }
                .empty-state h4 { font-size: 18px; font-weight: 700; color: var(--text-primary); margin-bottom: 8px; }
                .empty-state p { font-size: 14px; color: var(--text-muted); }
            `}</style>
        </div>
    );
};

export default NotificationsPage;
