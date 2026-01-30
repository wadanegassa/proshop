import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { productsAPI } from '../services/api';
import {
    ShoppingBag,
    Star,
    Edit3,
    Trash2,
    ArrowLeft,
    Package,
    Layers,
    DollarSign,
    BarChart3
} from 'lucide-react';

const ProductDetailsPage = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [product, setProduct] = useState(null);
    const [loading, setLoading] = useState(true);
    const [selectedImage, setSelectedImage] = useState(0);

    useEffect(() => {
        fetchProduct();
    }, [id]);

    const fetchProduct = async () => {
        try {
            const response = await productsAPI.getOne(id);
            setProduct(response.data.product);
        } catch (error) {
            console.error('Error fetching product:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleDelete = async () => {
        if (window.confirm('Are you sure you want to delete this product?')) {
            try {
                await productsAPI.delete(id);
                navigate('/products');
            } catch (error) {
                console.error('Error deleting product:', error);
                alert('Failed to delete product');
            }
        }
    };

    if (loading) return <div style={styles.loading}>Loading Product...</div>;
    if (!product) return <div style={styles.error}>Product not found</div>;

    const images = product.images && product.images.length > 0 ? product.images : [''];

    return (
        <div style={styles.container}>
            <header style={styles.header}>
                <div style={styles.headerLeft}>
                    <button onClick={() => navigate('/products')} style={styles.backBtn}><ArrowLeft size={18} /> Back</button>
                    <div>
                        <h1 style={styles.title}>Product <span className="orange-text">Details</span></h1>
                        <p style={styles.subtitle}>ID: {product._id}</p>
                    </div>
                </div>
                <div style={styles.headerActions}>
                    <button style={styles.editBtn} onClick={() => navigate(`/products/edit/${product._id}`)}>
                        <Edit3 size={18} /> Edit Product
                    </button>
                    <button style={styles.deleteBtn} onClick={handleDelete}>
                        <Trash2 size={18} /> Delete
                    </button>
                </div>
            </header>

            <div style={styles.detailsGrid}>
                {/* Left: Gallery */}
                <div className="larkon-card" style={styles.galleryCard}>
                    <div style={styles.mainImageContainer}>
                        {images[selectedImage] ? (
                            <img src={images[selectedImage]} alt={product.name} style={styles.mainImage} />
                        ) : (
                            <div style={styles.placeholderImg}>No Image</div>
                        )}
                    </div>
                    <div style={styles.thumbnails}>
                        {images.map((img, idx) => (
                            <div
                                key={idx}
                                style={{
                                    ...styles.thumbnail,
                                    border: selectedImage === idx ? '2px solid var(--primary)' : '2px solid transparent'
                                }}
                                onClick={() => setSelectedImage(idx)}
                            >
                                <img src={img || ''} alt="" style={styles.thumbImg} />
                            </div>
                        ))}
                    </div>
                </div>

                {/* Right: Info */}
                <div className="larkon-card" style={styles.infoCard}>
                    <div style={styles.infoHeader}>
                        <div style={styles.categoryBadge}>
                            <Layers size={12} />
                            {product.category?.name || 'Uncategorized'}
                        </div>
                        <div style={styles.ratingBox}>
                            <Star size={14} fill="var(--warning)" color="var(--warning)" />
                            <span>{product.rating} ({product.numReviews} reviews)</span>
                        </div>
                    </div>

                    <h2 style={styles.productName}>{product.name}</h2>

                    <div style={styles.priceRow}>
                        <span style={styles.price}>${product.price?.toFixed(2)}</span>
                        {product.countInStock > 0 ? (
                            <span style={styles.stockBadge}>In Stock ({product.countInStock})</span>
                        ) : (
                            <span style={styles.outStockBadge}>Out of Stock</span>
                        )}
                    </div>

                    <div style={styles.divider}></div>

                    <div style={styles.section}>
                        <h4 style={styles.sectionTitle}>Description</h4>
                        <p style={styles.description}>{product.description}</p>
                    </div>

                    <div style={styles.divider}></div>

                    <div style={styles.statsGrid}>
                        <div style={styles.statBox}>
                            <Package size={20} color="var(--primary)" />
                            <span style={styles.statLabel}>Stock</span>
                            <span style={styles.statValue}>{product.countInStock}</span>
                        </div>
                        <div style={styles.statBox}>
                            <BarChart3 size={20} color="var(--primary)" />
                            <span style={styles.statLabel}>Sales</span>
                            <span style={styles.statValue}>-</span> {/* Need analytics API for this */}
                        </div>
                        <div style={styles.statBox}>
                            <DollarSign size={20} color="var(--primary)" />
                            <span style={styles.statLabel}>Revenue</span>
                            <span style={styles.statValue}>-</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

const styles = {
    loading: { height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--primary)' },
    error: { padding: '40px', textAlign: 'center', color: 'var(--error)' },
    container: { display: 'flex', flexDirection: 'column', gap: '24px' },
    header: { display: 'flex', justifyContent: 'space-between', alignItems: 'center' },
    headerLeft: { display: 'flex', flexDirection: 'column', gap: '8px' },
    backBtn: { background: 'none', border: 'none', display: 'flex', alignItems: 'center', gap: '6px', color: 'var(--text-muted)', cursor: 'pointer', fontSize: '13px', padding: 0 },
    title: { fontSize: '24px', fontWeight: '800' },
    subtitle: { fontSize: '12px', color: 'var(--text-muted)', fontWeight: '600', marginTop: '4px' },
    headerActions: { display: 'flex', gap: '12px' },
    editBtn: { background: 'var(--primary)', color: 'black', padding: '10px 20px', borderRadius: '8px', fontSize: '14px', fontWeight: '700', display: 'flex', alignItems: 'center', gap: '8px', cursor: 'pointer' },
    deleteBtn: { background: 'rgba(239, 68, 68, 0.1)', color: 'var(--error)', border: '1px solid var(--error)', padding: '10px 20px', borderRadius: '8px', fontSize: '14px', fontWeight: '700', display: 'flex', alignItems: 'center', gap: '8px', cursor: 'pointer' },
    detailsGrid: { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px', alignItems: 'start' },
    galleryCard: { padding: '24px', display: 'flex', flexDirection: 'column', gap: '20px' },
    mainImageContainer: { width: '100%', aspectRatio: '1', background: 'var(--background)', borderRadius: '12px', overflow: 'hidden', display: 'flex', alignItems: 'center', justifyContent: 'center' },
    mainImage: { width: '100%', height: '100%', objectFit: 'contain' },
    placeholderImg: { color: 'var(--text-muted)', fontSize: '14px', fontWeight: '600' },
    thumbnails: { display: 'flex', gap: '12px', overflowX: 'auto', paddingBottom: '4px' },
    thumbnail: { width: '80px', height: '80px', borderRadius: '8px', cursor: 'pointer', overflow: 'hidden', background: 'var(--background)' },
    thumbImg: { width: '100%', height: '100%', objectFit: 'cover' },
    infoCard: { padding: '32px' },
    infoHeader: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' },
    categoryBadge: { display: 'flex', alignItems: 'center', gap: '6px', fontSize: '12px', fontWeight: '700', color: 'var(--primary)', background: 'var(--primary-glow)', padding: '4px 10px', borderRadius: '6px', textTransform: 'uppercase' },
    ratingBox: { display: 'flex', alignItems: 'center', gap: '6px', fontSize: '13px', fontWeight: '600', color: 'var(--text-secondary)' },
    productName: { fontSize: '28px', fontWeight: '800', lineHeight: '1.2', marginBottom: '16px' },
    priceRow: { display: 'flex', alignItems: 'center', gap: '16px', marginBottom: '24px' },
    price: { fontSize: '24px', fontWeight: '700', color: 'var(--primary)' },
    stockBadge: { color: 'var(--success)', background: 'rgba(34, 197, 94, 0.1)', padding: '4px 10px', borderRadius: '6px', fontSize: '12px', fontWeight: '700' },
    outStockBadge: { color: 'var(--error)', background: 'rgba(239, 68, 68, 0.1)', padding: '4px 10px', borderRadius: '6px', fontSize: '12px', fontWeight: '700' },
    divider: { height: '1px', background: 'var(--divider)', margin: '24px 0' },
    section: { marginBottom: '12px' },
    sectionTitle: { fontSize: '14px', fontWeight: '700', marginBottom: '12px', color: 'var(--text-primary)' },
    description: { fontSize: '14px', color: 'var(--text-secondary)', lineHeight: '1.6' },
    statsGrid: { display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '16px' },
    statBox: { background: 'var(--background)', padding: '16px', borderRadius: '12px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '8px', textAlign: 'center' },
    statLabel: { fontSize: '12px', color: 'var(--text-muted)', fontWeight: '600' },
    statValue: { fontSize: '16px', fontWeight: '800', color: 'var(--text-primary)' }
};

export default ProductDetailsPage;
