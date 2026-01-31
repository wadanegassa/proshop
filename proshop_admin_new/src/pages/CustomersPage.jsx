import React, { useState, useEffect } from 'react';
import { usersAPI } from '../services/api';
import { Trash2, Search, Filter, ChevronRight, User, Download } from 'lucide-react';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

const CustomersPage = () => {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);

    const generatePDF = () => {
        const doc = new jsPDF();
        doc.setFontSize(18);
        doc.setTextColor(255, 107, 0);
        doc.text('Customer Base Report', 14, 20);

        doc.setFontSize(10);
        doc.setTextColor(100);
        doc.text(`Generated on: ${new Date().toLocaleString()}`, 14, 28);
        doc.text(`Total Customers: ${users.length}`, 14, 33);

        const tableColumn = ["Name", "Email", "Role", "Joined At"];
        const tableRows = users.map(u => [
            u.name,
            u.email,
            u.role.toUpperCase(),
            new Date(u.createdAt).toLocaleDateString()
        ]);

        autoTable(doc, {
            startY: 40,
            head: [tableColumn],
            body: tableRows,
            theme: 'striped',
            headStyles: { fillColor: [255, 107, 0], textColor: [255, 255, 255] },
            styles: { fontSize: 9 }
        });

        doc.save(`customers-report-${new Date().getTime()}.pdf`);
    };

    useEffect(() => {
        const fetchUsers = async () => {
            try {
                const response = await usersAPI.getAll();
                setUsers(response.data.data.users);
            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };
        fetchUsers();
    }, []);

    const handleDelete = async (id) => {
        if (window.confirm('Are you sure you want to delete this user?')) {
            try {
                await usersAPI.delete(id);
                setUsers(users.filter(u => u._id !== id));
            } catch (error) {
                alert('Failed to delete user');
            }
        }
    };

    if (loading) return <div className="loading-state">Loading customers...</div>;

    return (
        <div className="customers-page fade-in">
            <div className="page-header">
                <div className="header-left">
                    <h1>CUSTOMERS LIST</h1>
                    <div className="breadcrumb">
                        <span>Users</span> <ChevronRight size={14} /> <span>Customers</span>
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
                    <h4>All Customers ({users.length})</h4>
                    <div className="search-box">
                        <Search size={18} />
                        <input type="text" placeholder="Search customers..." />
                    </div>
                </div>

                <div className="table-responsive">
                    <table className="proshop-table">
                        <thead>
                            <tr>
                                <th>User Info</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Joined At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {users.map((user) => (
                                <tr key={user._id}>
                                    <td>
                                        <div className="user-cell">
                                            <div className="user-avatar">
                                                {user.name ? user.name.charAt(0).toUpperCase() : <User size={16} />}
                                            </div>
                                            <div className="user-info">
                                                <span className="user-name">{user.name}</span>
                                                <span className="user-id">ID: {user._id.substring(user._id.length - 6)}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>{user.email}</td>
                                    <td>
                                        <span className={`role-badge ${user.role === 'admin' ? 'admin' : 'user'}`}>
                                            {user.role}
                                        </span>
                                    </td>
                                    <td>{new Date(user.createdAt).toLocaleDateString()}</td>
                                    <td>
                                        <button onClick={() => handleDelete(user._id)} className="action-btn delete"><Trash2 size={16} /></button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>

                <div className="table-footer">
                    <div className="footer-info">Showing 1 to {users.length} of {users.length} entries</div>
                </div>
            </div>

            <style>{`
                .customers-page { padding: 0; }
                .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .page-header h1 { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                .btn-icon { width: 40px; height: 40px; border-radius: 8px; background: var(--surface); color: var(--text-primary); display: flex; align-items: center; justify-content: center; }

                .table-container { padding: 0; overflow: hidden; }
                .table-header-row { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--divider); }
                .table-header-row h4 { font-size: 15px; font-weight: 700; color: var(--text-primary); }
                .search-box { display: flex; align-items: center; gap: 12px; padding: 0 16px; height: 36px; width: 250px; background: var(--surface-light); border-radius: 6px; border: 1px solid var(--divider); }
                .search-box input { background: transparent; border: none; outline: none; color: var(--text-primary); width: 100%; font-size: 13px; }

                .proshop-table { width: 100%; border-collapse: collapse; }
                .proshop-table th { text-align: left; padding: 12px 24px; font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; border-bottom: 1px solid var(--divider); }
                .proshop-table td { padding: 16px 24px; border-bottom: 1px solid var(--divider); vertical-align: middle; font-size: 13px; }
                
                .user-cell { display: flex; align-items: center; gap: 12px; }
                .user-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; }
                .user-info { display: flex; flex-direction: column; }
                .user-name { font-weight: 600; color: var(--text-primary); }
                .user-id { font-size: 11px; color: var(--text-muted); }

                .role-badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 600; width: fit-content; text-transform: capitalize; }
                .role-badge.admin { background: rgba(255, 107, 0, 0.1); color: var(--primary); }
                .role-badge.user { background: rgba(59, 130, 246, 0.1); color: #3b82f6; }

                .action-btn { width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; background: var(--surface); color: var(--text-secondary); transition: var(--transition); }
                .action-btn.delete:hover { color: var(--error); background: rgba(239, 68, 68, 0.1); }

                .table-footer { padding: 20px 24px; font-size: 13px; color: var(--text-muted); }
                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }
            `}</style>
        </div>
    );
};

export default CustomersPage;
