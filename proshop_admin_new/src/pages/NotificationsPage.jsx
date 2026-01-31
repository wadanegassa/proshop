import React from 'react';
import { useNotifications } from '../context/NotificationContext';
import { ShoppingBag, Bell, AlertTriangle, User, Check, Trash2, ChevronRight, Settings } from 'lucide-react';

const NotificationsPage = () => {
    const { notifications, markAsRead, markAllAsRead, clearAll } = useNotifications();

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
                    <button className="btn-icon"><Settings size={18} /></button>
                </div>
            </div>

            <div className="glass-card notif-container">
                <div className="container-header">
                    <div className="header-info">
                        <h4>Notification Center</h4>
                        <p>Total {notifications.length} notifications</p>
                    </div>
                    <div className="header-btns">
                        <button className="btn-text" onClick={markAllAsRead}>Mark all as read</button>
                        <button className="btn-text danger" onClick={clearAll}>Clear all</button>
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
                            <div key={n._id} className={`notif-item ${n.read ? 'read' : 'unread'}`}>
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
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>

            <style>{`
                .notifications-page { padding: 0; }
                .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .page-header h1 { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                .btn-icon { width: 40px; height: 40px; border-radius: 8px; background: var(--surface); color: var(--text-primary); display: flex; align-items: center; justify-content: center; }

                .notif-container { padding: 0; overflow: hidden; }
                .container-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--divider); }
                .container-header h4 { font-size: 15px; font-weight: 700; color: var(--text-primary); }
                .container-header p { font-size: 11px; color: var(--text-muted); margin-top: 2px; }
                .header-btns { display: flex; gap: 16px; }
                .btn-text { background: transparent; border: none; font-size: 12px; font-weight: 600; color: var(--primary); cursor: pointer; }
                .btn-text.danger { color: var(--error); }

                .notif-list { display: flex; flex-direction: column; }
                .notif-item { display: flex; align-items: flex-start; gap: 16px; padding: 20px 24px; border-bottom: 1px solid var(--divider); transition: var(--transition); }
                .notif-item:last-child { border-bottom: none; }
                .notif-item:hover { background: rgba(255, 255, 255, 0.02); }
                .notif-item.unread { background: rgba(255, 107, 0, 0.03); }
                
                .notif-icon-wrapper { width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
                
                .notif-body { flex: 1; }
                .notif-title-row { display: flex; justify-content: space-between; margin-bottom: 4px; }
                .notif-title { font-size: 13px; font-weight: 700; color: var(--text-primary); }
                .notif-date { font-size: 11px; color: var(--text-muted); }
                .notif-text { font-size: 12px; color: var(--text-secondary); line-height: 1.5; }

                .notif-actions { margin-left: 16px; align-self: center; }
                .mark-btn { background: var(--surface-light); color: var(--text-primary); border: 1px solid var(--divider); padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 600; display: flex; align-items: center; gap: 5px; cursor: pointer; }
                .mark-btn:hover { background: var(--primary); border-color: var(--primary); color: white; }

                .empty-state { padding: 80px 40px; text-align: center; }
                .empty-icon-box { width: 80px; height: 80px; background: var(--surface-light); color: var(--text-muted); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; }
                .empty-state h4 { font-size: 18px; font-weight: 700; color: var(--text-primary); margin-bottom: 8px; }
                .empty-state p { font-size: 14px; color: var(--text-muted); }
            `}</style>
        </div>
    );
};

export default NotificationsPage;
