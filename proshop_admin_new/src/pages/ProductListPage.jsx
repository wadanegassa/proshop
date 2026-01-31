import React, { useState, useEffect } from 'react';
import { productsAPI, getImageUrl } from '../services/api';
import { Edit, Trash2, Plus, Search, Filter, Eye, ChevronRight, MoreVertical } from 'lucide-react';
import { Link } from 'react-router-dom';
import ConfirmModal from '../components/ConfirmModal';

const ProductListPage = () => {
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);

    // Modal state
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [itemToDelete, setItemToDelete] = useState(null);

    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const response = await productsAPI.getAll();
                console.log('ProductListPage: All Products:', response.data.data.products);
                setProducts(response.data.data.products);
            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };
        fetchProducts();
    }, []);

    const handleDeleteClick = (id) => {
        setItemToDelete(id);
        setIsModalOpen(true);
    };

    const confirmDelete = async () => {
        if (!itemToDelete) return;
        try {
            await productsAPI.delete(itemToDelete);
            setProducts(products.filter(p => p._id !== itemToDelete));
        } catch (error) {
            console.error('Delete failed:', error);
        }
    };

    if (loading) return <div className="loading-state">Loading products...</div>;

    return (
        <div className="product-list-page fade-in">
            <div className="page-header">
                <div className="header-left">
                    <h1 className="cool-title">PRODUCTS LIST <span className="title-accent">☰</span></h1>
                    <div className="breadcrumb">
                        <span>List</span> <ChevronRight size={14} /> <span>All Products</span>
                    </div>
                </div>
                <div className="header-actions">
                    <button className="btn-icon"><Filter size={18} /></button>
                    <Link to="/products/create" className="btn-primary btn-cool">
                        <Plus size={18} strokeWidth={3} /> <span>New Product</span>
                    </Link>
                </div>
            </div>

            <div className="table-container glass-card">
                <div className="table-header-row">
                    <h4>All Products ({products.length})</h4>
                    <div className="search-box">
                        <Search size={18} />
                        <input type="text" placeholder="Search products..." />
                    </div>
                </div>

                <div className="table-responsive">
                    <table className="proshop-table">
                        <thead>
                            <tr>
                                <th>Product Image & Name</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Category</th>
                                <th>Rating</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {products.map((product) => (
                                <tr key={product._id}>
                                    <td>
                                        <div className="p-cell">
                                            <div className="p-img">
                                                <img src={getImageUrl(product.images[0])} alt="" />
                                            </div>
                                            <div className="p-info">
                                                <Link to={`/products/details/${product._id}`} className="p-name">{product.name}</Link>
                                                <span className="p-variant">Size: M / Color: Black</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div className="p-price-cell">
                                            <span className="p-current">${product.price}</span>
                                            <span className="p-stock-info">({product.countInStock} Items Left)</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span className={`status-badge ${product.countInStock > 10 ? 'success' : product.countInStock > 0 ? 'warning' : 'error'}`}>
                                            {product.countInStock > 0 ? `${product.countInStock} Left` : 'Out of Stock'}
                                        </span>
                                    </td>
                                    <td>{product.category?.name || 'N/A'}</td>
                                    <td>
                                        <div className="p-rating">
                                            <span className="badge-rating"><Eye size={12} /> {product.rating || 4.5}</span>
                                            <span className="p-reviews">({product.numReviews || 0} Reviews)</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div className="action-btns">
                                            <Link to={`/products/details/${product._id}`} className="action-btn view"><Eye size={16} /></Link>
                                            <Link to={`/products/edit/${product._id}`} className="action-btn edit"><Edit size={16} /></Link>
                                            <button onClick={() => handleDeleteClick(product._id)} className="action-btn delete"><Trash2 size={16} /></button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>

                <div className="table-footer">
                    <div className="footer-info">Showing 1 to {products.length} of {products.length} entries</div>
                    <div className="pagination">
                        <button disabled><ChevronRight size={16} style={{ transform: 'rotate(180deg)' }} /></button>
                        <button className="active">1</button>
                        <button><ChevronRight size={16} /></button>
                    </div>
                </div>
            </div>

            <style>{`
                .product-list-page { padding: 0; }
                .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .page-header h1.cool-title { font-size: 16px; font-weight: 800; color: var(--text-primary); margin-bottom: 4px; letter-spacing: 1px; display: flex; align-items: center; gap: 8px; text-transform: uppercase; }
                .title-accent { color: var(--primary); filter: drop-shadow(0 0 8px var(--primary-glow)); font-size: 18px; line-height: 1; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                .header-actions { display: flex; gap: 12px; }
                .btn-icon { width: 40px; height: 40px; border-radius: 8px; background: var(--surface); color: var(--text-primary); display: flex; align-items: center; justify-content: center; }

                .table-container { padding: 0; overflow: hidden; }
                .table-header-row { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--divider); }
                .table-header-row h4 { font-size: 15px; font-weight: 700; color: var(--text-primary); }
                .search-box { display: flex; align-items: center; gap: 12px; padding: 0 16px; height: 36px; width: 250px; background: var(--surface-light); border-radius: 6px; border: 1px solid var(--divider); }
                .search-box input { background: transparent; border: none; outline: none; color: var(--text-primary); width: 100%; font-size: 13px; }

                .proshop-table { width: 100%; border-collapse: collapse; }
                .proshop-table th { text-align: left; padding: 12px 24px; font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; border-bottom: 1px solid var(--divider); }
                .proshop-table td { padding: 16px 24px; border-bottom: 1px solid var(--divider); vertical-align: middle; }
                
                .p-cell { display: flex; align-items: center; gap: 16px; }
                .p-img { width: 48px; height: 48px; border-radius: 8px; background: var(--surface-light); padding: 4px; display: flex; align-items: center; justify-content: center; }
                .p-img img { max-width: 100%; max-height: 100%; object-fit: contain; }
                .p-info { display: flex; flex-direction: column; gap: 4px; }
                .p-name { font-size: 13px; font-weight: 700; color: var(--text-primary); text-decoration: none; }
                .p-name:hover { color: var(--primary); }
                .p-variant { font-size: 11px; color: var(--text-muted); }

                .p-price-cell { display: flex; flex-direction: column; gap: 2px; }
                .p-current { font-size: 14px; font-weight: 700; color: var(--text-primary); }
                .p-stock-info { font-size: 11px; color: var(--text-muted); }
                
                .status-badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 600; width: fit-content; }
                .status-badge.success { background: rgba(34, 197, 94, 0.1); color: var(--success); }
                .status-badge.warning { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
                .status-badge.error { background: rgba(239, 68, 68, 0.1); color: var(--error); }

                .p-rating { display: flex; flex-direction: column; gap: 4px; }
                .badge-rating { display: flex; align-items: center; gap: 4px; background: var(--surface-light); color: var(--text-primary); padding: 2px 8px; border-radius: 12px; font-size: 11px; width: fit-content; }
                .p-reviews { font-size: 11px; color: var(--text-muted); }

                .action-btns { display: flex; gap: 8px; }
                .action-btn { width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; background: var(--surface-light); color: var(--text-secondary); transition: var(--transition); }
                .action-btn.view:hover { color: var(--primary); background: rgba(255, 107, 0, 0.1); }
                .action-btn.edit:hover { color: var(--success); background: rgba(34, 197, 94, 0.1); }
                .action-btn.delete:hover { color: var(--error); background: rgba(239, 68, 68, 0.1); }

                .table-footer { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; }
                .footer-info { font-size: 13px; color: var(--text-muted); }
                .pagination { display: flex; gap: 8px; }
                .pagination button { width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; background: var(--surface-light); color: var(--text-primary); border: 1px solid var(--divider); }
                .pagination button.active { background: var(--primary); border-color: var(--primary); }
                .pagination button:disabled { opacity: 0.5; cursor: not-allowed; }

                .btn-cool { position: relative; overflow: hidden; }
                .btn-cool span { position: relative; z-index: 1; }
                .btn-cool::after { content: ''; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%; background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent); transform: rotate(45deg); transition: 0.5s; left: -100%; }
                .btn-cool:hover::after { left: 100%; }

                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }
            `}</style>

            <ConfirmModal
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
                onConfirm={confirmDelete}
                title="Delete Product"
                message="Are you sure you want to remove this product from your catalog? This action cannot be undone."
            />
        </div>
    );
};

export default ProductListPage;
