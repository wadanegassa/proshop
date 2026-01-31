import React from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import {
    LayoutDashboard,
    ShoppingBag,
    ShoppingCart,
    Package,
    Layers,
    Users2,
    Store,
    LogOut
} from 'lucide-react';
import { useAuth } from '../context/AuthContext';

const Sidebar = () => {
    const { logout } = useAuth();
    const location = useLocation();

    const menuGroups = [
        {
            title: 'GENERAL',
            items: [
                { icon: <LayoutDashboard size={18} />, label: 'Dashboard', path: '/' },
                {
                    icon: <Package size={18} />, label: 'Products', path: '/products', expanded: true, subItems: [
                        { label: 'List', path: '/products' },
                        { label: 'Grid', path: '/products/grid' },
                    ]
                },
                {
                    icon: <ShoppingCart size={18} />, label: 'Orders', path: '/orders', subItems: [
                        { label: 'List', path: '/orders' },
                        { label: 'Details', path: '/orders/details/active' },
                    ]
                },
                { icon: <Layers size={18} />, label: 'Category', path: '/categories' },
            ]
        },
        {
            title: 'USERS',
            items: [
                { icon: <Users2 size={18} />, label: 'Customers', path: '/customers' },
            ]
        }
    ];

    const [expanded, setExpanded] = React.useState({ Products: true });

    const toggleMenu = (label) => {
        setExpanded(prev => ({ ...prev, [label]: !prev[label] }));
    };

    return (
        <aside className="sidebar">
            <div className="sidebar-logo">
                <div className="logo-box">
                    <Store size={20} color="white" fill="white" />
                </div>
                <span className="logo-text">Pro<span className="accent">Shop</span></span>
            </div>

            <div className="sidebar-scroll">
                <nav className="sidebar-nav">
                    {menuGroups.map((group) => (
                        <div key={group.title} className="nav-group">
                            <h3 className="group-title">{group.title}</h3>
                            {group.items.map((item) => (
                                <div key={item.label}>
                                    <div
                                        className={`nav-item ${location.pathname === item.path ? 'active' : ''}`}
                                        onClick={() => item.subItems ? toggleMenu(item.label) : null}
                                        style={{ cursor: 'pointer' }}
                                    >
                                        {!item.subItems ? (
                                            <NavLink to={item.path} className="nav-link-content" style={{ display: 'flex', flex: 1, alignItems: 'center', color: 'inherit', textDecoration: 'none' }}>
                                                <span className="item-icon">{item.icon}</span>
                                                <span className="item-label">{item.label}</span>
                                            </NavLink>
                                        ) : (
                                            <>
                                                <span className="item-icon">{item.icon}</span>
                                                <span className="item-label">{item.label}</span>
                                                <span className="arrow-icon" style={{ transform: expanded[item.label] ? 'rotate(90deg)' : 'rotate(0deg)', transition: 'transform 0.2s' }}>›</span>
                                            </>
                                        )}
                                    </div>

                                    {item.subItems && (
                                        <div className="sub-menu" style={{
                                            height: expanded[item.label] ? 'auto' : 0,
                                            overflow: 'hidden',
                                            opacity: expanded[item.label] ? 1 : 0,
                                            transition: 'all 0.3s ease'
                                        }}>
                                            {item.subItems.map(sub => (
                                                <NavLink key={sub.label} to={sub.path} className="sub-item">
                                                    {sub.label}
                                                </NavLink>
                                            ))}
                                        </div>
                                    )}
                                </div>
                            ))}
                        </div>
                    ))}
                </nav>
            </div>

            <button className="logout-btn" onClick={logout}>
                <LogOut size={18} />
                <span>Logout Session</span>
            </button>

            <style>{`
                .sidebar {
                    width: 260px;
                    height: 100vh;
                    background: var(--sidebar-bg);
                    display: flex;
                    flex-direction: column;
                    padding: 20px 0;
                    position: fixed;
                    left: 0;
                    top: 0;
                    z-index: 1000;
                    border-right: 1px solid var(--divider);
                }
                .sidebar-logo {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    padding: 0 24px 24px;
                    color: var(--text-primary);
                }
                .logo-text {
                    font-size: 22px;
                    font-weight: 900;
                    letter-spacing: -0.5px;
                    color: var(--text-primary);
                }
                .logo-text .accent {
                    color: var(--primary);
                    filter: drop-shadow(0 0 8px var(--primary-glow));
                }
                .logo-box {
                    width: 32px;
                    height: 32px;
                    background: var(--primary);
                    border-radius: 6px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .sidebar-scroll {
                    flex: 1;
                    overflow-y: auto;
                    padding: 0 16px;
                }
                .nav-group {
                    margin-bottom: 24px;
                }
                .group-title {
                    font-size: 11px;
                    font-weight: 600;
                    color: var(--text-muted);
                    padding: 0 12px 12px;
                    letter-spacing: 0.5px;
                }
                .nav-item {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    padding: 10px 12px;
                    color: var(--text-secondary);
                    text-decoration: none;
                    border-radius: 8px;
                    transition: var(--transition);
                    margin-bottom: 2px;
                    font-size: 14px;
                }
                .nav-item:hover {
                    color: var(--text-primary);
                    background: var(--surface-light);
                }
                .nav-item.active {
                    background: var(--primary-glow);
                    color: var(--primary);
                }
                .item-icon {
                    display: flex;
                    align-items: center;
                    color: inherit;
                }
                .item-label {
                    flex: 1;
                }
                .arrow-icon {
                    font-size: 18px;
                    opacity: 0.5;
                }
                .sub-menu {
                    padding-left: 42px;
                    margin-top: 4px;
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }
                .sub-item {
                    color: var(--text-muted);
                    text-decoration: none;
                    font-size: 13px;
                    padding: 4px 0;
                    transition: var(--transition);
                }
                .sub-item:hover, .sub-item.active {
                    color: var(--text-primary);
                }
                .logout-btn {
                    margin: 20px 16px 0;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding: 12px;
                    color: #ff4d4d;
                    background: rgba(255, 77, 77, 0.05);
                    border-radius: 8px;
                    font-size: 14px;
                    font-weight: 500;
                }
                .logout-btn:hover {
                    background: rgba(255, 77, 77, 0.1);
                }
            `}</style>
        </aside>
    );
};

export default Sidebar;
