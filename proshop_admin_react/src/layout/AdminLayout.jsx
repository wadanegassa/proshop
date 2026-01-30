import { useNavigate, Outlet } from 'react-router-dom';
import Sidebar from './Sidebar';
import {
    Search,
    Menu,
    Bell,
    Moon,
    Settings,
    Globe,
    Grid
} from 'lucide-react';

const AdminLayout = () => {
    return (
        <div style={styles.layout}>
            <Sidebar />
            <div style={styles.main}>
                <header style={styles.header}>
                    <div style={styles.headerLeft}>
                        <button style={styles.iconBtn}><Menu size={20} /></button>
                        <div style={styles.searchBox}>
                            <Search size={18} color="var(--text-muted)" />
                            <input
                                type="text"
                                placeholder="Search..."
                                style={styles.searchInput}
                            />
                        </div>
                    </div>

                    <div style={styles.headerRight}>
                        <div style={styles.actionGroup}>
                            <button style={styles.actionBtn}><Globe size={18} /></button>
                            <button style={styles.actionBtn}><Grid size={18} /></button>
                            <button style={styles.actionBtn}><Moon size={18} /></button>
                            <button style={styles.actionBtn}>
                                <Bell size={18} />
                                <span style={styles.badge}></span>
                            </button>
                        </div>

                        <div style={styles.userSection}>
                            <div style={styles.userInfo}>
                                <p style={styles.userName}>Gail Anderson</p>
                                <p style={styles.userRole}>Admin</p>
                            </div>
                            <div style={styles.avatarBox}>
                                <img
                                    src="https://ui-avatars.com/api/?name=Gail+Anderson&background=FF6C2F&color=fff"
                                    style={styles.avatar}
                                    alt="User"
                                />
                            </div>
                        </div>
                    </div>
                </header>
                <div style={styles.content}>
                    <Outlet />
                </div>
            </div>
        </div>
    );
};

const styles = {
    layout: {
        display: 'flex',
        minHeight: '100vh',
        background: 'var(--background)',
    },
    main: {
        flex: 1,
        marginLeft: '260px',
        display: 'flex',
        flexDirection: 'column',
    },
    header: {
        height: '70px',
        background: 'rgba(13, 14, 15, 0.8)',
        backdropFilter: 'blur(12px)',
        borderBottom: '1px solid var(--divider)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '0 32px',
        position: 'sticky',
        top: 0,
        zIndex: 900,
    },
    headerLeft: {
        display: 'flex',
        alignItems: 'center',
        gap: '24px',
    },
    searchBox: {
        display: 'flex',
        alignItems: 'center',
        background: 'var(--surface)',
        borderRadius: '10px',
        padding: '0 16px',
        width: '320px',
        height: '40px',
        border: '1px solid var(--divider)',
    },
    searchInput: {
        background: 'transparent',
        border: 'none',
        color: 'var(--text-primary)',
        paddingLeft: '12px',
        fontSize: '14px',
        width: '100%',
        outline: 'none',
    },
    headerRight: {
        display: 'flex',
        alignItems: 'center',
        gap: '32px',
    },
    actionGroup: {
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
    },
    actionBtn: {
        width: '38px',
        height: '38px',
        borderRadius: '8px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        color: 'var(--text-secondary)',
        position: 'relative',
        '&:hover': {
            background: 'var(--primary-glow)',
            color: 'var(--primary)',
        }
    },
    badge: {
        position: 'absolute',
        top: '10px',
        right: '10px',
        width: '8px',
        height: '8px',
        background: 'var(--primary)',
        borderRadius: '50%',
        border: '2px solid var(--background)',
    },
    userSection: {
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
        paddingLeft: '24px',
        borderLeft: '1px solid var(--divider)',
    },
    userInfo: {
        textAlign: 'right',
    },
    userName: {
        fontSize: '14px',
        fontWeight: '700',
        color: 'var(--text-primary)',
    },
    userRole: {
        fontSize: '11px',
        color: 'var(--text-muted)',
        fontWeight: '600',
    },
    avatarBox: {
        width: '38px',
        height: '38px',
        borderRadius: '10px',
        overflow: 'hidden',
        border: '1px solid var(--divider)',
    },
    avatar: {
        width: '100%',
        height: '100%',
        objectFit: 'cover',
    },
    content: {
        padding: '32px',
        flex: 1,
    },
    iconBtn: {
        color: 'var(--text-secondary)',
    }
};

export default AdminLayout;
