import React, { useState, useEffect } from 'react';
import { productsAPI, getImageUrl } from '../services/api';
import { Edit, Trash2, Plus, Search, Filter, Eye, ChevronRight, MoreVertical, Download } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import ConfirmModal from '../components/ConfirmModal';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

const ProductListPage = () => {
    const navigate = useNavigate();
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');

    const [isModalOpen, setIsModalOpen] = useState(false);
    const [itemToDelete, setItemToDelete] = useState(null);

    const generatePDF = () => {
        const doc = new jsPDF();
        doc.setFontSize(18);
        doc.setTextColor(255, 107, 0);
        doc.text('Product Catalog Report', 14, 20);

        doc.setFontSize(10);
        doc.setTextColor(100);
        doc.text(`Generated on: ${new Date().toLocaleString()}`, 14, 28);
        doc.text(`Total Products: ${filteredProducts.length}`, 14, 33);

        const tableColumn = ["Product Name", "Category", "Price", "Stock", "Rating"];
        const tableRows = filteredProducts.map(p => [
            p.name,
            p.category?.name || 'N/A',
            `$${p.price}`,
            p.countInStock > 0 ? `${p.countInStock} Items` : 'Out of Stock',
            `★ ${p.rating || 0} (${p.numReviews || 0})`
        ]);

        autoTable(doc, {
            startY: 40,
            head: [tableColumn],
            body: tableRows,
            theme: 'striped',
            headStyles: { fillColor: [255, 107, 0], textColor: [255, 255, 255] },
            styles: { fontSize: 8 }
        });

        doc.save(`product-catalog-${new Date().getTime()}.pdf`);
    };

    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const response = await productsAPI.getAll();
                setProducts(response.data.data.products);
            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };
        fetchProducts();
    }, []);

    const handleDeleteClick = (e, id) => {
        e.stopPropagation();
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

    const filteredProducts = products.filter(p =>
        p.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        p.category?.name.toLowerCase().includes(searchTerm.toLowerCase())
    );

    if (loading) return <div className="loading-state">Loading products...</div>;

    return (
        <div className="product-list-larkon fade-in">
            <div className="page-header-larkon">
                <div className="header-left">
                    <h1>Products List</h1>
                </div>
                <div className="header-right">
                    <button className="larkon-btn btn-primary" onClick={generatePDF}>
                        <Download size={18} /> Export PDF
                    </button>
                    <Link to="/products/create" className="larkon-btn btn-primary">
                        <Plus size={18} /> Create Product
                    </Link>
                </div>
            </div>

            <div className="glass-card table-card-larkon">
                <div className="card-controls">
                    <div className="search-box-larkon">
                        <Search size={18} />
                        <input
                            type="text"
                            placeholder="Search products..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </div>
                </div>

                <div className="table-wrapper">
                    <table className="larkon-table">
                        <thead>
                            <tr>
                                <th>Product Name & Size</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Category</th>
                                <th>Rating</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredProducts.map((product) => (
                                <tr key={product._id} onClick={() => navigate(`/products/edit/${product._id}`)}>
                                    <td>
                                        <div className="product-info-cell">
                                            <div className="product-thumb">
                                                <img src={getImageUrl(product.images[0])} alt="" />
                                            </div>
                                            <div className="product-text">
                                                <span className="p-title">{product.name}</span>
                                                <span className="p-subtitle">Size: {product.sizes?.[0] || 'N/A'}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div className="price-cell">
                                            {product.discount > 0 ? (
                                                <div className="price-discounted">
                                                    <span className="val-new">${(product.price * (1 - product.discount / 100)).toFixed(2)}</span>
                                                    <span className="val-old">${product.price.toFixed(2)}</span>
                                                    <span className="discount-pill-table">-{product.discount}%</span>
                                                </div>
                                            ) : (
                                                <span className="val">${product.price.toFixed(2)}</span>
                                            )}
                                        </div>
                                    </td>
                                    <td>
                                        <div className="stock-cell">
                                            <span className={`status-pill ${product.countInStock > 0 ? 'in-stock' : 'out-of-stock'}`}>
                                                {product.countInStock > 0 ? `${product.countInStock} Items` : 'Out of Stock'}
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <span className="cat-pill">{product.category?.name || 'N/A'}</span>
                                    </td>
                                    <td>
                                        <div className="rating-cell">
                                            <div className="rating-badge">
                                                ★ {product.rating || 0}
                                            </div>
                                            <span className="review-count">({product.numReviews || 0})</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div className="action-row">
                                            <button className="action-icn view" onClick={(e) => { e.stopPropagation(); navigate(`/products/details/${product._id}`); }} title="View Details"><Eye size={16} /></button>
                                            <button className="action-icn edit" onClick={(e) => { e.stopPropagation(); navigate(`/products/edit/${product._id}`); }} title="Edit"><Edit size={16} /></button>
                                            <button className="action-icn delete" onClick={(e) => handleDeleteClick(e, product._id)} title="Delete"><Trash2 size={16} /></button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>

                <div className="card-footer-larkon">
                    <div className="footer-stats">
                        Showing {filteredProducts.length} of {products.length} entries
                    </div>
                    <div className="larkon-pagination">
                        <button className="pag-btn" disabled><ChevronRight size={18} style={{ transform: 'rotate(180deg)' }} /></button>
                        <button className="pag-btn active">1</button>
                        <button className="pag-btn">2</button>
                        <button className="pag-btn"><ChevronRight size={18} /></button>
                    </div>
                </div>
            </div>

            <style>{`
                .product-list-larkon { padding: 30px; background: var(--background); min-height: 100vh; color: var(--text-primary); font-family: 'Inter', sans-serif; }
                
                .page-header-larkon { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
                .page-header-larkon h1 { font-size: 20px; font-weight: 700; }
                .header-right { display: flex; gap: 12px; }

                .larkon-btn { 
                    display: flex; align-items: center; gap: 8px; padding: 10px 20px; border-radius: 8px; 
                    font-size: 14px; font-weight: 600; cursor: pointer; transition: var(--transition); border: none;
                }
                .btn-outline { background: var(--surface); color: var(--text-primary); border: 1px solid var(--divider); }
                .btn-outline:hover { background: var(--surface-light); border-color: var(--primary); }
                .btn-primary { background: var(--primary); color: white; box-shadow: 0 4px 12px var(--primary-glow); }
                .btn-primary:hover { filter: brightness(1.1); transform: translateY(-2px); }

                .table-card-larkon { padding: 0; }
                .card-controls { padding: 20px 24px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--divider); }
                
                .search-box-larkon { 
                    display: flex; align-items: center; gap: 12px; padding: 0 16px; height: 42px; width: 320px; 
                    background: var(--surface-light); border-radius: 8px; border: 1px solid transparent; transition: var(--transition);
                }
                .search-box-larkon:focus-within { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-glow); }
                .search-box-larkon input { background: transparent; border: none; outline: none; color: var(--text-primary); width: 100%; font-size: 14px; }
                .search-box-larkon input::placeholder { color: var(--text-secondary); }

                .filter-actions { display: none; }
                .control-btn { display: none; }
                .control-btn:hover { border-color: var(--primary); color: var(--primary); }

                .table-wrapper { overflow-x: auto; }
                .larkon-table { width: 100%; border-collapse: collapse; }
                .larkon-table th { 
                    text-align: left; padding: 16px 24px; font-size: 13px; font-weight: 600; 
                    color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid var(--divider); 
                }
                .larkon-table td { padding: 16px 24px; border-bottom: 1px solid var(--divider); vertical-align: middle; transition: var(--transition); cursor: pointer; }
                .larkon-table tbody tr:hover td { background: rgba(255, 255, 255, 0.02); }

                .product-info-cell { display: flex; align-items: center; gap: 15px; }
                .product-thumb { width: 50px; height: 50px; border-radius: 8px; background: #000; padding: 5px; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px solid var(--divider); }
                .product-thumb img { max-width: 100%; max-height: 100%; object-fit: contain; }
                .product-text { display: flex; flex-direction: column; gap: 4px; }
                .p-title { font-size: 14px; font-weight: 700; color: var(--text-primary); }
                .p-subtitle { font-size: 12px; color: var(--text-secondary); }

                .p-subtitle { font-size: 12px; color: var(--text-secondary); }
                
                .price-discounted { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
                .val-new { font-size: 15px; font-weight: 700; color: var(--text-primary); }
                .val-old { font-size: 12px; text-decoration: line-through; color: var(--text-secondary); }
                .discount-pill-table { font-size: 10px; background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 2px 5px; border-radius: 4px; font-weight: 700; }
                .price-cell .val { font-size: 15px; font-weight: 700; color: var(--text-primary); }
                
                .status-pill { 
                    padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase;
                    display: inline-block;
                }
                .status-pill.in-stock { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
                .status-pill.out-of-stock { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

                .cat-pill { padding: 4px 10px; background: var(--surface-light); border-radius: 6px; font-size: 12px; color: var(--text-secondary); }

                .rating-cell { display: flex; align-items: center; gap: 8px; }
                .rating-badge { background: #facc15; color: #000; padding: 2px 8px; border-radius: 4px; font-size: 12px; font-weight: 700; }
                .review-count { font-size: 12px; color: var(--text-secondary); }

                .action-row { display: flex; gap: 8px; }
                .action-icn { 
                    width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; 
                    background: var(--surface-light); border: 1px solid transparent; border-radius: 6px; color: var(--text-secondary); cursor: pointer; transition: 0.2s;
                }
                .action-icn:hover { transform: scale(1.1); }
                .action-icn.view:hover { background: rgba(59, 130, 246, 0.1); color: #3b82f6; border-color: #3b82f6; }
                .action-icn.edit:hover { background: rgba(34, 197, 94, 0.1); color: #22c55e; border-color: #22c55e; }
                .action-icn.delete:hover { background: rgba(239, 68, 68, 0.1); color: #ef4444; border-color: #ef4444; }

                .card-footer-larkon { padding: 20px 24px; display: flex; justify-content: space-between; align-items: center; }
                .footer-stats { font-size: 13px; color: var(--text-secondary); }

                .larkon-pagination { display: flex; gap: 6px; }
                .pag-btn { 
                    width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; 
                    background: var(--surface-light); border: 1px solid var(--divider); border-radius: 8px; color: var(--text-primary); cursor: pointer; transition: 0.2s;
                }
                .pag-btn:hover:not(:disabled) { border-color: var(--primary); color: var(--primary); }
                .pag-btn.active { background: var(--primary); border-color: var(--primary); color: white; }
                .pag-btn:disabled { opacity: 0.3; cursor: not-allowed; }

                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }
                
                @keyframes popIn {
                    from { opacity: 0; transform: scale(0.95); }
                    to { opacity: 1; transform: scale(1); }
                }
                .glass-card { animation: popIn 0.4s ease-out; background: var(--surface); border: 1px solid var(--divider); border-radius: var(--radius-md); overflow: hidden; }
            `}</style>

            <ConfirmModal
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
                onConfirm={confirmDelete}
                title="Delete Product"
                message="Are you sure you want to remove this product from your catalog? This action cannot be undone."
            />
        </div >
    );
};

export default ProductListPage;
