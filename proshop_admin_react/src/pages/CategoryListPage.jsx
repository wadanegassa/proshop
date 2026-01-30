import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { categoriesAPI } from '../services/api';
import {
    Plus,
    Search,
    Edit3,
    Trash2,
    Folder
} from 'lucide-react';

const CategoryListPage = () => {
    const [categories, setCategories] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchCategories = async () => {
            try {
                const response = await categoriesAPI.getAll();
                setCategories(response.data.categories || []);
            } catch (error) {
                console.error('Error fetching categories:', error);
            } finally {
                setLoading(false);
            }
        };
        fetchCategories();
    }, []);

    const [isModalOpen, setIsModalOpen] = useState(false);
    const [editingCategory, setEditingCategory] = useState(null);
    const [formData, setFormData] = useState({ name: '' });

    const handleOpenModal = (category = null) => {
        setEditingCategory(category);
        setFormData({ name: category ? category.name : '' });
        setIsModalOpen(true);
    };

    const handleCloseModal = () => {
        setIsModalOpen(false);
        setEditingCategory(null);
        setFormData({ name: '' });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editingCategory) {
                await categoriesAPI.update(editingCategory._id, formData);
            } else {
                await categoriesAPI.create(formData);
            }
            // Refresh
            const response = await categoriesAPI.getAll();
            setCategories(response.data.categories || []);
            handleCloseModal();
        } catch (error) {
            console.error('Error saving category:', error);
            alert('Failed to save category');
        }
    };

    const handleDelete = async (id) => {
        if (window.confirm('Are you sure you want to delete this category?')) {
            try {
                await categoriesAPI.delete(id);
                setCategories(prev => prev.filter(c => c._id !== id));
            } catch (error) {
                console.error('Error deleting category:', error);
                alert('Failed to delete category');
            }
        }
    };

    if (loading) return <div style={styles.loading}>Loading Categories...</div>;

    return (
        <div style={styles.container}>
            <header style={styles.header}>
                <h1 style={styles.title}>Category <span className="orange-text">List</span></h1>
                <div style={styles.headerActions}>
                    <button style={styles.orangeBtn} onClick={() => handleOpenModal()}><Plus size={18} /> Add Category</button>
                </div>
            </header>

            <div className="larkon-card" style={styles.tableCard}>
                <div style={styles.tableToolbar}>
                    <h4 style={styles.cardTitle}>All Categories</h4>
                    <div style={styles.toolbarActions}>
                        <div style={styles.searchBox}>
                            <Search size={16} color="var(--text-muted)" />
                            <input type="text" placeholder="Search categories..." style={styles.searchInput} />
                        </div>
                    </div>
                </div>

                <table className="larkon-table">
                    <thead>
                        <tr>
                            <th style={{ width: '40px' }}><input type="checkbox" /></th>
                            <th>Category Name</th>
                            <th>Icon</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {categories.map((category) => (
                            <tr key={category._id}>
                                <td><input type="checkbox" /></td>
                                <td>
                                    <div style={styles.categoryCell}>
                                        <div style={styles.categoryThumb}><Folder size={20} color="var(--primary)" /></div>
                                        <span style={styles.categoryName}>{category.name}</span>
                                    </div>
                                </td>
                                <td>-</td>
                                <td>
                                    <div style={styles.actions}>
                                        <button style={styles.actionIcon} title="Edit" onClick={() => handleOpenModal(category)}>
                                            <Edit3 size={16} />
                                        </button>
                                        <button style={styles.actionIcon} title="Delete" onClick={() => handleDelete(category._id)}>
                                            <Trash2 size={16} color="var(--error)" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        ))}
                        {categories.length === 0 && (
                            <tr>
                                <td colSpan="4" style={{ textAlign: 'center', padding: '20px', color: 'var(--text-muted)' }}>
                                    No categories found.
                                </td>
                            </tr>
                        )}
                    </tbody>
                </table>
            </div>

            {/* Modal */}
            {
                isModalOpen && (
                    <div style={styles.modalOverlay}>
                        <div style={styles.modalContent}>
                            <div style={styles.modalHeader}>
                                <h3>{editingCategory ? 'Edit Category' : 'Add Category'}</h3>
                                <button onClick={handleCloseModal} style={styles.closeBtn}>&times;</button>
                            </div>
                            <form onSubmit={handleSubmit} style={styles.form}>
                                <div style={styles.inputGroup}>
                                    <label>Category Name</label>
                                    <input
                                        type="text"
                                        value={formData.name}
                                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                                        style={styles.input}
                                        required
                                        autoFocus
                                    />
                                </div>
                                <div style={styles.modalActions}>
                                    <button type="button" onClick={handleCloseModal} style={styles.cancelBtn}>Cancel</button>
                                    <button type="submit" style={styles.submitBtn}>Save</button>
                                </div>
                            </form>
                        </div>
                    </div>
                )
            }
        </div >
    );
};

const styles = {
    loading: {
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: '18px',
        color: 'var(--primary)',
        background: 'var(--background)',
    },
    modalOverlay: {
        position: 'fixed',
        top: 0, left: 0, right: 0, bottom: 0,
        background: 'rgba(0,0,0,0.7)',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        zIndex: 100,
    },
    modalContent: {
        background: 'var(--surface)',
        padding: '24px',
        borderRadius: '12px',
        width: '400px',
        border: '1px solid var(--divider)',
    },
    modalHeader: {
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: '20px',
    },
    closeBtn: {
        background: 'none',
        border: 'none',
        color: 'var(--text-muted)',
        fontSize: '24px',
        cursor: 'pointer',
    },
    form: {
        display: 'flex',
        flexDirection: 'column',
        gap: '20px',
    },
    input: {
        width: '100%',
        padding: '10px',
        borderRadius: '8px',
        border: '1px solid var(--divider)',
        background: 'var(--background)',
        color: 'var(--text-primary)',
        marginTop: '8px',
        outline: 'none',
    },
    modalActions: {
        display: 'flex',
        justifyContent: 'flex-end',
        gap: '12px',
    },
    submitBtn: {
        background: 'var(--primary)',
        color: 'black',
        padding: '8px 16px',
        borderRadius: '6px',
        fontWeight: '600',
    },
    cancelBtn: {
        background: 'transparent',
        color: 'var(--text-secondary)',
        padding: '8px 16px',
        border: '1px solid var(--divider)',
        borderRadius: '6px',
    },
    container: {
        display: 'flex',
        flexDirection: 'column',
        gap: '24px',
    },
    header: {
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    title: {
        fontSize: '24px',
        fontWeight: '800',
    },
    headerActions: {
        display: 'flex',
        gap: '12px',
    },
    orangeBtn: {
        background: 'var(--primary)',
        color: 'var(--background)',
        padding: '10px 20px',
        borderRadius: '8px',
        fontSize: '14px',
        fontWeight: '700',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
    },
    tableCard: {
        padding: '0',
    },
    tableToolbar: {
        padding: '24px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottom: '1px solid var(--divider)',
    },
    cardTitle: {
        fontSize: '16px',
        fontWeight: '700',
    },
    toolbarActions: {
        display: 'flex',
        gap: '12px',
    },
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
    },
    categoryCell: {
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
    },
    categoryThumb: {
        width: '40px',
        height: '40px',
        background: 'var(--background)',
        borderRadius: '8px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
    },
    categoryName: {
        fontSize: '14px',
        fontWeight: '600',
        color: 'var(--text-primary)',
    },
    actions: {
        display: 'flex',
        gap: '8px',
    },
    actionIcon: {
        width: '32px',
        height: '32px',
        borderRadius: '6px',
        background: 'var(--background)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        color: 'var(--text-secondary)',
        border: '1px solid var(--divider)',
        cursor: 'pointer',
        transition: 'var(--transition)',
        '&:hover': { background: 'var(--surface-hover)' }
    }
};

export default CategoryListPage;
