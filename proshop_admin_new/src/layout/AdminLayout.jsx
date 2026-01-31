import React from 'react';
import { Outlet, useLocation } from 'react-router-dom';
import Sidebar from './Sidebar';
import { Search, Bell, Moon, Sun, User as UserIcon } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { useNotifications } from '../context/NotificationContext';
import { useTheme } from '../context/ThemeContext';

const AdminLayout = () => {
    const { user } = useAuth();
    const { unreadCount } = useNotifications();
    const { isDarkMode, toggleTheme } = useTheme();
    const location = useLocation();

    const getPageTitle = () => {
        const path = location.pathname;
        if (path === '/') return 'DASHBOARD';
        const parts = path.split('/').filter(Boolean);
        return parts[parts.length - 1].toUpperCase().replace(/-/g, ' ');
    };

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
                            <button className="topbar-btn" onClick={toggleTheme}>
                                {isDarkMode ? <Sun size={20} /> : <Moon size={20} />}
                            </button>
                            <button className="topbar-btn notification-btn">
                                <Bell size={20} />
                                {unreadCount > 0 && <span className="notification-badge">{unreadCount}</span>}
                            </button>

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
                .notification-badge {
                    position: absolute;
                    top: 8px;
                    right: 8px;
                    width: 16px;
                    height: 16px;
                    background: var(--error);
                    color: #ffffff;
                    font-size: 10px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
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
