import React, { useState, useEffect } from 'react';
import { categoriesAPI } from '../services/api';
import { Edit, Trash2, Plus, Search, ChevronRight, MoreVertical } from 'lucide-react';
import ConfirmModal from '../components/ConfirmModal';

const CategoryListPage = () => {
    const [categories, setCategories] = useState([]);
    const [loading, setLoading] = useState(true);
    const [newCatName, setNewCatName] = useState('');

    // Modal state
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [itemToDelete, setItemToDelete] = useState(null);

    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = async () => {
        try {
            const response = await categoriesAPI.getAll();
            setCategories(response.data.data.categories);
        } catch (error) {
            console.error(error);
        } finally {
            setLoading(false);
        }
    };

    const handleCreate = async (e) => {
        e.preventDefault();
        if (!newCatName) return;
        try {
            await categoriesAPI.create({ name: newCatName });
            setNewCatName('');
            fetchCategories();
        } catch (error) {
            alert('Failed to create category');
        }
    };

    const handleDeleteClick = (id) => {
        setItemToDelete(id);
        setIsModalOpen(true);
    };

    const confirmDelete = async () => {
        if (!itemToDelete) return;
        try {
            await categoriesAPI.delete(itemToDelete);
            fetchCategories();
        } catch (error) {
            console.error('Delete failed:', error);
        }
    };

    if (loading) return <div className="loading-state">Loading categories...</div>;

    return (
        <div className="category-list-page fade-in">
            <div className="page-header">
                <div className="header-left">
                    <h1>CATEGORIES</h1>
                    <div className="breadcrumb">
                        <span>List</span> <ChevronRight size={14} /> <span>All Categories</span>
                    </div>
                </div>
                <div className="header-actions">
                    <button className="btn-icon"><Search size={18} /></button>
                </div>
            </div>

            <div className="category-layout">
                <div className="glass-card cat-form-card">
                    <h4>Create Category</h4>
                    <form onSubmit={handleCreate}>
                        <div className="input-field">
                            <label>Category Name</label>
                            <input
                                type="text"
                                value={newCatName}
                                onChange={(e) => setNewCatName(e.target.value)}
                                placeholder="e.g. Electronics"
                            />
                        </div>
                        <button type="submit" className="btn-primary w-full">Create Category</button>
                    </form>
                </div>

                <div className="glass-card cat-table-card">
                    <div className="table-header-row">
                        <h4>All Categories ({categories.length})</h4>
                    </div>
                    <div className="table-responsive">
                        <table className="proshop-table">
                            <thead>
                                <tr>
                                    <th>Category Name</th>
                                    <th>Slug</th>
                                    <th>Products</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {categories.map((cat) => (
                                    <tr key={cat._id}>
                                        <td className="cat-name">{cat.name}</td>
                                        <td className="text-muted">/{cat.name.toLowerCase()}</td>
                                        <td><span className="badge-count">12 Items</span></td>
                                        <td>
                                            <div className="action-btns">
                                                <button className="action-btn edit"><Edit size={16} /></button>
                                                <button className="action-btn delete" onClick={() => handleDeleteClick(cat._id)}>
                                                    <Trash2 size={16} />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <style>{`
                .category-list-page { padding: 0; }
                .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .page-header h1 { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                .header-actions { display: flex; gap: 12px; }
                .btn-icon { width: 40px; height: 40px; border-radius: 8px; background: var(--surface); color: var(--text-primary); display: flex; align-items: center; justify-content: center; }

                .category-layout { display: grid; grid-template-columns: 350px 1fr; gap: 24px; align-items: start; }
                .cat-form-card { padding: 24px; }
                .cat-form-card h4 { font-size: 15px; font-weight: 700; color: var(--text-primary); margin-bottom: 24px; border-bottom: 1px solid var(--divider); padding-bottom: 12px; }
                .input-field { display: flex; flex-direction: column; gap: 8px; margin-bottom: 20px; }
                .input-field label { font-size: 12px; font-weight: 600; color: var(--text-secondary); }
                .input-field input { background: var(--surface-light); border: 1px solid var(--divider); border-radius: 8px; padding: 12px; color: var(--text-primary); font-size: 13px; outline: none; }
                .w-full { width: 100%; justify-content: center; height: 44px; }

                .cat-table-card { padding: 0; overflow: hidden; }
                .table-header-row { padding: 20px 24px; border-bottom: 1px solid var(--divider); }
                .table-header-row h4 { font-size: 15px; font-weight: 700; color: var(--text-primary); }

                .proshop-table { width: 100%; border-collapse: collapse; }
                .proshop-table th { text-align: left; padding: 12px 24px; font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; border-bottom: 1px solid var(--divider); }
                .proshop-table td { padding: 16px 24px; border-bottom: 1px solid var(--divider); vertical-align: middle; }
                .cat-name { font-size: 13px; font-weight: 700; color: var(--text-primary); }
                .badge-count { background: var(--surface-light); color: var(--text-secondary); padding: 2px 8px; border-radius: 4px; font-size: 11px; }

                .action-btns { display: flex; gap: 8px; }
                .action-btn { width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; background: var(--surface-light); color: var(--text-secondary); transition: var(--transition); }
                .action-btn.edit:hover { color: var(--success); background: rgba(34, 197, 94, 0.1); }
                .action-btn.delete:hover { color: var(--error); background: rgba(239, 68, 68, 0.1); }

                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }
            `}</style>

            <ConfirmModal
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
                onConfirm={confirmDelete}
                title="Delete Category"
                message="Are you sure you want to delete this category? All related product linkages might be affected."
            />
        </div>
    );
};

export default CategoryListPage;
