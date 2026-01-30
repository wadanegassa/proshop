import { useState, useEffect } from 'react';
import { usersAPI } from '../services/api';
import { Search, UserX, UserCheck, Shield, User } from 'lucide-react';

const UserListPage = () => {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchUsers();
    }, []);

    const fetchUsers = async () => {
        try {
            const response = await usersAPI.getAll();
            setUsers(response.data.users);
        } catch (error) {
            console.error('Error fetching users:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleToggleBlock = async (user) => {
        if (user.role === 'admin') {
            alert("Cannot block admin users.");
            return;
        }

        try {
            if (user.active) {
                if (window.confirm(`Are you sure you want to block ${user.name}?`)) {
                    await usersAPI.block(user._id);
                }
            } else {
                await usersAPI.unblock(user._id);
            }
            fetchUsers();
        } catch (error) {
            console.error('Error updating user status:', error);
            alert('Failed to update user status');
        }
    };

    if (loading) return <div style={styles.loading}>Loading Users...</div>;

    return (
        <div style={styles.container}>
            <header style={styles.header}>
                <h1 style={styles.title}>User <span className="orange-text">Management</span></h1>
            </header>

            <div className="larkon-card" style={styles.tableCard}>
                <div style={styles.tableToolbar}>
                    <h4 style={styles.cardTitle}>All Users</h4>
                    <div style={styles.toolbarActions}>
                        <div style={styles.searchBox}>
                            <Search size={16} color="var(--text-muted)" />
                            <input type="text" placeholder="Search users..." style={styles.searchInput} />
                        </div>
                    </div>
                </div>

                <table className="larkon-table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Current Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {users.map((user) => (
                            <tr key={user._id}>
                                <td>
                                    <div style={styles.userCell}>
                                        <div style={styles.avatar}>
                                            <User size={20} color="var(--primary)" />
                                        </div>
                                        <div>
                                            <p style={styles.userName}>{user.name}</p>
                                            <p style={styles.userEmail}>{user.email}</p>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style={styles.roleTag}>
                                        <Shield size={12} color={user.role === 'admin' ? 'var(--primary)' : 'var(--text-muted)'} />
                                        <span>{user.role}</span>
                                    </div>
                                </td>
                                <td>
                                    <span style={{
                                        ...styles.statusBadge,
                                        background: user.active ? 'rgba(34, 197, 94, 0.1)' : 'rgba(239, 68, 68, 0.1)',
                                        color: user.active ? 'var(--success)' : 'var(--error)'
                                    }}>
                                        {user.active ? 'Active' : 'Blocked'}
                                    </span>
                                </td>
                                <td>
                                    {user.role !== 'admin' && (
                                        <button
                                            style={styles.actionBtn}
                                            onClick={() => handleToggleBlock(user)}
                                            title={user.active ? "Block User" : "Unblock User"}
                                        >
                                            {user.active ? (
                                                <><UserX size={16} color="var(--error)" /> Block</>
                                            ) : (
                                                <><UserCheck size={16} color="var(--success)" /> Unblock</>
                                            )}
                                        </button>
                                    )}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
};

const styles = {
    loading: {
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        color: 'var(--primary)'
    },
    container: { display: 'flex', flexDirection: 'column', gap: '24px' },
    header: { marginBottom: '8px' },
    title: { fontSize: '24px', fontWeight: '800' },
    tableCard: { padding: '0', overflow: 'hidden' },
    tableToolbar: {
        padding: '24px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottom: '1px solid var(--divider)',
    },
    cardTitle: { fontSize: '16px', fontWeight: '700' },
    searchBox: {
        background: 'var(--background)',
        border: '1px solid var(--divider)',
        borderRadius: '8px',
        padding: '0 12px',
        display: 'flex',
        alignItems: 'center',
        height: '38px',
    },
    searchInput: {
        background: 'transparent',
        border: 'none',
        color: 'var(--text-primary)',
        paddingLeft: '8px',
        fontSize: '13px',
        outline: 'none',
        width: '200px',
    },
    userCell: { display: 'flex', alignItems: 'center', gap: '12px' },
    avatar: {
        width: '40px',
        height: '40px',
        borderRadius: '50%',
        background: 'var(--surface-hover)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
    },
    userName: { fontSize: '14px', fontWeight: '700' },
    userEmail: { fontSize: '12px', color: 'var(--text-muted)' },
    roleTag: { display: 'flex', alignItems: 'center', gap: '6px', fontSize: '13px', textTransform: 'capitalize' },
    statusBadge: { padding: '4px 10px', borderRadius: '6px', fontSize: '12px', fontWeight: '600' },
    actionBtn: {
        background: 'var(--surface)',
        border: '1px solid var(--divider)',
        borderRadius: '6px',
        padding: '6px 12px',
        display: 'flex',
        alignItems: 'center',
        gap: '6px',
        fontSize: '12px',
        fontWeight: '600',
        color: 'var(--text-primary)',
        cursor: 'pointer',
        transition: 'var(--transition)',
    }
};

export default UserListPage;
