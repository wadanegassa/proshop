import { NavLink } from 'react-router-dom';
import {
    LayoutDashboard,
    ShoppingBag,
    Package,
    Users,
    Settings,
    LogOut,
    Menu,
    ChevronLeft,
    Layers,
    BarChart3
} from 'lucide-react';

const Sidebar = () => {
    const menuItems = [
        { path: '/', label: 'Dashboard', icon: LayoutDashboard },
        { path: '/products', label: 'Products', icon: ShoppingBag },
        { path: '/categories', label: 'Categories', icon: Layers },
        { path: '/orders', label: 'Orders', icon: Package },
        { path: '/users', label: 'Users', icon: Users },
        { path: '/customers', label: 'Customers', icon: Users, hidden: true },
        { path: '/settings', label: 'Settings', icon: Settings, hidden: true },
    ].filter(item => !item.hidden);

    return (
        <aside style={styles.sidebar}>
            <div style={styles.logoContainer}>
                <div style={styles.logoBox}>
                    <ShoppingBag size={20} color="var(--primary)" />
                </div>
                <h2 style={styles.logoText}>Pro<span style={{ color: 'var(--primary)' }}>Shop</span></h2>
            </div>

            <nav style={styles.nav}>
                {menuItems.map((item) => (
                    <NavLink
                        key={item.path}
                        to={item.path}
                        className={({ isActive }) => isActive ? 'nav-active' : ''}
                        style={({ isActive }) => ({
                            ...styles.navLink,
                            color: isActive ? 'var(--primary)' : 'var(--text-secondary)',
                            background: isActive ? 'var(--primary-glow)' : 'transparent',
                        })}
                    >
                        <item.icon size={18} />
                        <span style={styles.navLabel}>{item.label}</span>
                    </NavLink>
                ))}
            </nav>

            <div style={styles.footer}>
                <NavLink
                    to="/settings"
                    style={styles.navLink}
                >
                    <Settings size={18} />
                    <span style={styles.navLabel}>Settings</span>
                </NavLink>
                <button style={styles.logoutBtn}>
                    <LogOut size={18} />
                    <span style={styles.navLabel}>Sign Out</span>
                </button>
            </div>
        </aside>
    );
};

const styles = {
    sidebar: {
        width: '260px',
        height: '100vh',
        background: 'var(--surface)',
        borderRight: '1px solid var(--divider)',
        display: 'flex',
        flexDirection: 'column',
        position: 'fixed',
        left: 0,
        top: 0,
        zIndex: 1000,
    },
    logoContainer: {
        padding: '32px 24px',
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
    },
    logoBox: {
        width: '36px',
        height: '36px',
        background: 'var(--primary-glow)',
        borderRadius: '8px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
    },
    logoText: {
        fontSize: '20px',
        fontWeight: '800',
        letterSpacing: '-0.02em',
    },
    nav: {
        flex: 1,
        padding: '0 16px',
        overflowY: 'auto',
    },
    section: {
        marginBottom: '24px',
    },
    sectionLabel: {
        fontSize: '11px',
        fontWeight: '800',
        color: 'var(--text-muted)',
        padding: '0 12px 12px',
        letterSpacing: '0.05em',
    },
    navLink: {
        display: 'flex',
        alignItems: 'center',
        padding: '12px 14px',
        borderRadius: '10px',
        textDecoration: 'none',
        marginBottom: '4px',
        transition: 'var(--transition)',
        gap: '12px',
    },
    navLabel: {
        fontSize: '14px',
        fontWeight: '600',
    },
    chevron: {
        marginLeft: 'auto',
        opacity: 0.5,
    },
    footer: {
        padding: '20px 16px',
        borderTop: '1px solid var(--divider)',
        display: 'flex',
        flexDirection: 'column',
        gap: '4px',
    },
    logoutBtn: {
        width: '100%',
        display: 'flex',
        alignItems: 'center',
        padding: '12px 14px',
        borderRadius: '10px',
        color: 'var(--error)',
        gap: '12px',
        textAlign: 'left',
    }
};

export default Sidebar;
