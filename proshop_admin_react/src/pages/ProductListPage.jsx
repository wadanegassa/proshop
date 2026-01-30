import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { productsAPI } from '../services/api';
import {
    Plus,
    Search,
    Filter,
    Edit3,
    Trash2,
    Eye,
    Star,
    ChevronLeft,
    ChevronRight,
    Download
} from 'lucide-react';

const ProductListPage = () => {
    const navigate = useNavigate();
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const response = await productsAPI.getAll();
                // response is { success: true, data: { products: [...] } }
                setProducts(response.data.products || []);
            } catch (error) {
                console.error('Error fetching products:', error);
            } finally {
                setLoading(false);
            }
        };
        fetchProducts();
    }, []);

    if (loading) return <div style={styles.loading}>Loading Products...</div>;

    return (
        <div style={styles.container}>
            <header style={styles.header}>
                <h1 style={styles.title}>Product <span className="orange-text">List</span></h1>
                <div style={styles.headerActions}>
                    <button style={styles.exportBtn}><Download size={18} /> Export</button>
                    <button style={styles.addBtn} onClick={() => navigate('/products/add')}><Plus size={18} /> Add Product</button>
                </div>
            </header>

            <div className="larkon-card" style={styles.tableCard}>
                <div style={styles.tableToolbar}>
                    <h4 style={styles.cardTitle}>All Product List</h4>
                    <div style={styles.toolbarActions}>
                        <div style={styles.searchBox}>
                            <Search size={16} color="var(--text-muted)" />
                            <input type="text" placeholder="Search products..." style={styles.searchInput} />
                        </div>
                    </div>
                </div>

                <table className="larkon-table">
                    <thead>
                        <tr>
                            <th style={{ width: '40px' }}><input type="checkbox" /></th>
                            <th>Product Name & Brand</th>
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
                                <td><input type="checkbox" /></td>
                                <td>
                                    <div style={styles.productCell}>
                                        <div style={styles.productThumb}>
                                            {product.image ? <img src={product.image} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover', borderRadius: '4px' }} /> : '📦'}
                                        </div>
                                        <div>
                                            <p style={styles.productName}>{product.name}</p>
                                            <p style={styles.productSize}>Brand: {product.brand || 'N/A'}</p>
                                        </div>
                                    </div>
                                </td>
                                <td style={styles.price}>${product.price}</td>
                                <td>
                                    <div style={styles.stockInfo}>
                                        <p>{product.countInStock} Left</p>
                                        <p style={styles.soldText}>{product.numReviews} Reviews</p>
                                    </div>
                                </td>
                                <td>{product.category?.name || 'General'}</td>
                                <td>
                                    <div style={styles.ratingBox}>
                                        <Star size={14} fill="var(--warning)" color="var(--warning)" />
                                        <span>{product.rating || 0}</span>
                                    </div>
                                </td>
                                <td>
                                    <div style={styles.actions}>
                                        <button style={styles.actionIcon} onClick={() => navigate(`/products/detail/${product._id}`)} title="View">
                                            <Eye size={16} />
                                        </button>
                                        <button style={styles.actionIcon} onClick={() => navigate(`/products/edit/${product._id}`)} title="Edit">
                                            <Edit3 size={16} />
                                        </button>
                                        <button style={styles.actionIcon} title="Delete">
                                            <Trash2 size={16} color="var(--error)" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>

                <div style={styles.pagination}>
                    <p style={styles.paginationText}>Showing {products.length} products</p>
                    <div style={styles.pageButtons}>
                        <button style={styles.pageBtn}><ChevronLeft size={16} /></button>
                        <button style={{ ...styles.pageBtn, background: 'var(--primary)', color: 'var(--background)' }}>1</button>
                        <button style={styles.pageBtn}>2</button>
                        <button style={styles.pageBtn}>3</button>
                        <button style={styles.pageBtn}><ChevronRight size={16} /></button>
                    </div>
                </div>
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
        fontSize: '18px',
        color: 'var(--primary)',
        background: 'var(--background)',
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
    exportBtn: {
        background: 'var(--surface)',
        border: '1px solid var(--divider)',
        color: 'var(--text-secondary)',
        padding: '10px 20px',
        borderRadius: '8px',
        fontSize: '14px',
        fontWeight: '600',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        cursor: 'pointer',
    },
    addBtn: {
        background: 'var(--primary)',
        color: 'var(--background)',
        padding: '10px 20px',
        borderRadius: '8px',
        fontSize: '14px',
        fontWeight: '700',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        border: 'none',
        cursor: 'pointer',
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
    filterDropdown: {
        background: 'var(--surface)',
        border: '1px solid var(--divider)',
        padding: '10px 16px',
        borderRadius: '8px',
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
        fontSize: '13px',
        fontWeight: '600',
        color: 'var(--text-secondary)',
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
    productCell: {
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
    },
    productThumb: {
        width: '40px',
        height: '40px',
        background: 'var(--background)',
        borderRadius: '8px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: '20px',
        overflow: 'hidden',
    },
    productName: {
        fontSize: '14px',
        fontWeight: '700',
        color: 'var(--text-primary)',
    },
    productSize: {
        fontSize: '12px',
        color: 'var(--text-muted)',
    },
    price: {
        fontWeight: '700',
        color: 'var(--text-primary)',
    },
    stockInfo: {
        display: 'flex',
        flexDirection: 'column',
        gap: '2px',
    },
    soldText: {
        fontSize: '11px',
        color: 'var(--text-muted)',
    },
    ratingBox: {
        display: 'flex',
        alignItems: 'center',
        gap: '6px',
        fontWeight: '700',
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
    },
    pagination: {
        padding: '20px 24px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderTop: '1px solid var(--divider)',
    },
    paginationText: {
        fontSize: '13px',
        color: 'var(--text-muted)',
    },
    pageButtons: {
        display: 'flex',
        gap: '6px',
    },
    pageBtn: {
        width: '32px',
        height: '32px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: '6px',
        background: 'var(--surface)',
        border: '1px solid var(--divider)',
        fontSize: '13px',
        fontWeight: '600',
        color: 'var(--text-secondary)',
    }
};

export default ProductListPage;
