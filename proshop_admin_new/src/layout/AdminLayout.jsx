import React from 'react';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';
import Sidebar from './Sidebar';
import { Search, Bell, Moon, Sun, User as UserIcon } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { useNotifications } from '../context/NotificationContext';
import { useTheme } from '../context/ThemeContext';

const AdminLayout = () => {
    const { user } = useAuth();
    const { notifications, unreadCount, markAsRead, markAllAsRead } = useNotifications();
    const { isDarkMode, toggleTheme } = useTheme();
    const location = useLocation();
    const navigate = useNavigate();
    const [showNotifications, setShowNotifications] = React.useState(false);
    const dropdownRef = React.useRef(null);

    const getPageTitle = () => {
        const path = location.pathname;
        if (path === '/') return 'DASHBOARD';
        const parts = path.split('/').filter(Boolean);
        return parts[parts.length - 1].toUpperCase().replace(/-/g, ' ');
    };

    React.useEffect(() => {
        const handleClickOutside = (event) => {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
                setShowNotifications(false);
            }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    return (
        <div className="admin-layout">
            <Sidebar />

            <main className="main-content">
                <header className="topbar">
                    <div className="topbar-left">
                        <h2 className="page-title">{getPageTitle()}</h2>
                    </div>

                    <div className="topbar-right">
                        <div className="topbar-actions">
                            <button className="topbar-btn" onClick={toggleTheme} title="Toggle Theme">
                                {isDarkMode ? <Sun size={20} /> : <Moon size={20} />}
                            </button>

                            <div className="notification-wrapper" ref={dropdownRef}>
                                <button
                                    className={`topbar-btn notification-btn ${showNotifications ? 'active' : ''}`}
                                    onClick={() => setShowNotifications(!showNotifications)}
                                    title="Notifications"
                                >
                                    <Bell size={20} />
                                    {unreadCount > 0 && <span className="notification-badge">{unreadCount}</span>}
                                </button>

                                {showNotifications && (
                                    <div className="notification-dropdown glass-card fade-in">
                                        <div className="dropdown-header">
                                            <h4>Notifications</h4>
                                            {notifications.length > 0 && (
                                                <div className="header-links">
                                                    <button onClick={markAllAsRead}>Mark all read</button>
                                                    <button className="clear-all" onClick={clearAll}>Clear all</button>
                                                </div>
                                            )}
                                        </div>
                                        <div className="dropdown-body">
                                            {notifications.length > 0 ? (
                                                notifications.slice(0, 5).map((notif) => (
                                                    <div
                                                        key={notif._id}
                                                        className={`notification-item ${!notif.read ? 'unread' : ''}`}
                                                        onClick={() => markAsRead(notif._id)}
                                                    >
                                                        <div className="notif-icon-circle">
                                                            <Bell size={14} />
                                                        </div>
                                                        <div className="notif-details">
                                                            <p className="notif-title">{notif.title}</p>
                                                            <p className="notif-msg">{notif.message}</p>
                                                            <span className="notif-time">{new Date(notif.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                                                        </div>
                                                        {!notif.read && <span className="unread-dot"></span>}
                                                    </div>
                                                ))
                                            ) : (
                                                <div className="empty-notifications">
                                                    <Bell size={32} />
                                                    <p>No new notifications</p>
                                                </div>
                                            )}
                                        </div>
                                        <div className="dropdown-footer">
                                            <button onClick={() => { setShowNotifications(false); navigate('/notifications'); }}>View All Notifications</button>
                                        </div>
                                    </div>
                                )}
                            </div>

                            <div className="user-dropdown">
                                <img src={`https://ui-avatars.com/api/?name=${user?.name || 'Admin'}&background=ff6b00&color=fff`} alt="user" className="user-avatar" />
                                <span className="user-name">{user?.name || 'Admin'}</span>
                            </div>

                            <div className="topbar-search">
                                <Search size={18} />
                                <input type="text" placeholder="Search..." />
                            </div>
                        </div>
                    </div>
                </header>

                <div className="page-wrapper">
                    <Outlet />
                </div>
            </main>

            <style>{`
                .admin-layout {
                    display: flex;
                    min-height: 100vh;
                    background: var(--background);
                }
                .main-content {
                    flex: 1;
                    margin-left: 260px;
                    display: flex;
                    flex-direction: column;
                }
                .topbar {
                    height: 70px;
                    background: var(--background);
                    border-bottom: 1px solid var(--divider);
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding: 0 24px;
                    position: sticky;
                    top: 0;
                    z-index: 999;
                }
                .page-title {
                    font-size: 14px;
                    font-weight: 700;
                    color: var(--text-primary);
                    letter-spacing: 0.5px;
                }
                .topbar-actions {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }
                .topbar-btn {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    color: var(--text-secondary);
                    background: transparent;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .topbar-btn:hover {
                    background: var(--surface);
                    color: var(--text-primary);
                }
                .theme-toggle {
                    color: var(--primary) !important;
                    background: var(--surface-light) !important;
                    border: 1px solid var(--divider) !important;
                }
                .theme-toggle:hover {
                    background: var(--primary-glow) !important;
                    transform: scale(1.05);
                }
                .notification-btn {
                    position: relative;
                }
                .notification-btn.active {
                    background: var(--surface-light);
                    color: var(--primary);
                }
                .notification-badge {
                    position: absolute;
                    top: 6px;
                    right: 6px;
                    width: 16px;
                    height: 16px;
                    background: var(--primary);
                    color: #ffffff;
                    font-size: 10px;
                    font-weight: 800;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border: 2px solid var(--background);
                }

                .notification-wrapper {
                    position: relative;
                }
                .notification-dropdown {
                    position: absolute;
                    top: calc(100% + 12px);
                    right: 0;
                    width: 320px;
                    background: var(--surface);
                    border: 1px solid var(--divider);
                    border-radius: 12px;
                    box-shadow: var(--shadow-lg);
                    z-index: 1000;
                    overflow: hidden;
                    display: flex;
                    flex-direction: column;
                }
                .dropdown-header {
                    padding: 16px 20px;
                    border-bottom: 1px solid var(--divider);
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }
                .dropdown-header h4 {
                    font-size: 14px;
                    font-weight: 700;
                    margin: 0;
                }
                .dropdown-header button {
                    background: transparent;
                    border: none;
                    color: var(--primary);
                    font-size: 11px;
                    font-weight: 600;
                    cursor: pointer;
                }
                .header-links {
                    display: flex;
                    gap: 12px;
                }
                .clear-all {
                    color: var(--text-muted) !important;
                }
                .clear-all:hover {
                    color: #ef4444 !important;
                }
                .dropdown-body {
                    max-height: 360px;
                    overflow-y: auto;
                }
                .notification-item {
                    padding: 15px 20px;
                    display: flex;
                    gap: 12px;
                    border-bottom: 1px solid var(--divider);
                    cursor: pointer;
                    transition: 0.2s;
                    position: relative;
                }
                .notification-item:hover {
                    background: var(--surface-light);
                }
                .notification-item.unread {
                    background: rgba(255, 107, 0, 0.03);
                }
                .notif-icon-circle {
                    width: 32px;
                    height: 32px;
                    background: var(--surface-light);
                    border-radius: 8px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: var(--text-muted);
                    flex-shrink: 0;
                }
                .unread .notif-icon-circle {
                    background: var(--primary-glow);
                    color: var(--primary);
                }
                .notif-details {
                    flex: 1;
                }
                .notif-title {
                    font-size: 13px;
                    font-weight: 700;
                    margin: 0 0 2px 0;
                    color: var(--text-primary);
                }
                .notif-msg {
                    font-size: 12px;
                    color: var(--text-muted);
                    margin: 0 0 6px 0;
                    line-height: 1.4;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }
                .notif-time {
                    font-size: 10px;
                    color: var(--text-muted);
                    text-transform: uppercase;
                    font-weight: 600;
                }
                .unread-dot {
                    width: 6px;
                    height: 6px;
                    background: var(--primary);
                    border-radius: 50%;
                    position: absolute;
                    top: 15px;
                    right: 15px;
                }
                .empty-notifications {
                    padding: 40px 20px;
                    text-align: center;
                    color: var(--text-muted);
                }
                .empty-notifications p {
                    font-size: 13px;
                    margin-top: 10px;
                }
                .dropdown-footer {
                    padding: 12px;
                    border-top: 1px solid var(--divider);
                    text-align: center;
                    background: var(--surface-light);
                }
                .dropdown-footer button {
                    background: transparent;
                    border: none;
                    color: var(--text-primary);
                    font-size: 12px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.2s;
                }
                .dropdown-footer button:hover {
                    color: var(--primary);
                }

                .user-dropdown {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding: 4px 12px;
                    cursor: pointer;
                    margin-left: 8px;
                }
                .user-avatar {
                    width: 32px;
                    height: 32px;
                    border-radius: 50%;
                    object-fit: cover;
                }
                .user-name {
                    font-size: 13px;
                    font-weight: 600;
                    color: var(--text-primary);
                }
                .topbar-search {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    background: var(--surface-light);
                    border: 1px solid var(--divider);
                    padding: 0 16px;
                    height: 38px;
                    border-radius: 8px;
                    margin-left: 16px;
                    width: 200px;
                }
                .topbar-search input {
                    background: transparent;
                    border: none;
                    color: var(--text-primary);
                    font-size: 13px;
                    outline: none;
                    width: 100%;
                }
                .page-wrapper {
                    padding: 24px;
                    flex: 1;
                }
            `}</style>
        </div>
    );
};

export default AdminLayout;
