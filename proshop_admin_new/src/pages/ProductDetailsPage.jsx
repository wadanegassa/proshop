import React, { useState, useEffect } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { productsAPI, getImageUrl } from '../services/api';
import { Star, ChevronRight, Edit, ArrowLeft, Check, Truck, Tag, Clock, Share2, Heart, Award, ShieldCheck, Zap, Info, MoreHorizontal } from 'lucide-react';

const ProductDetailsPage = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [product, setProduct] = useState(null);
    const [loading, setLoading] = useState(true);
    const [activeImage, setActiveImage] = useState(0);

    useEffect(() => {
        const fetchProduct = async () => {
            try {
                const response = await productsAPI.getOne(id);
                setProduct(response.data.data.product);
            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };
        fetchProduct();
    }, [id]);

    if (loading) return (
        <div className="loading-state">
            <div className="spinner-larkon"></div>
        </div>
    );

    if (!product) return (
        <div className="error-state-larkon">
            <div className="glass-card error-card">
                <Info size={48} />
                <h2>Product not found</h2>
                <p>The product you are looking for does not exist or has been removed.</p>
                <Link to="/products" className="larkon-btn btn-primary">Back to List</Link>
            </div>
        </div>
    );

    return (
        <div className="product-details-larkon fade-in">
            {/* Header Area */}
            <div className="page-header-larkon">
                <div className="header-left">
                    <button className="back-btn" onClick={() => navigate('/products')}><ArrowLeft size={18} /></button>
                    <div>
                        <h1>Product Details</h1>
                        <div className="larkon-breadcrumb">
                            <Link to="/">Dashboard</Link> <ChevronRight size={12} /> <Link to="/products">Products</Link> <ChevronRight size={12} /> <span>{product.name}</span>
                        </div>
                    </div>
                </div>
                <div className="header-right">
                    <button className="larkon-btn btn-outline"><Share2 size={18} /> Share</button>
                    <Link to={`/products/edit/${product._id}`} className="larkon-btn btn-primary">
                        <Edit size={18} /> Edit Product
                    </Link>
                </div>
            </div>

            {/* Main Content Grid */}
            <div className="details-content-larkon">
                {/* Visuals Column */}
                <div className="visuals-column">
                    <div className="glass-card gallery-card-larkon">
                        <div className="main-preview-larkon">
                            <img
                                src={getImageUrl(product.images?.[activeImage])}
                                alt={product.name}
                                onError={(e) => { e.target.onerror = null; e.target.src = 'https://via.placeholder.com/600x600?text=No+Image'; }}
                            />
                            <div className="preview-badges">
                                {product.discount > 0 && <span className="badge-disc">-{product.discount}%</span>}
                                {product.status === 'Draft' && <span className="badge-status draft">Draft</span>}
                            </div>
                        </div>
                        <div className="thumbnails-larkon">
                            {product.images?.map((img, i) => (
                                <div
                                    key={i}
                                    className={`thumb-box ${activeImage === i ? 'active' : ''}`}
                                    onClick={() => setActiveImage(i)}
                                >
                                    <img src={getImageUrl(img)} alt="" />
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* Features/Service Bar */}
                    <div className="features-grid-larkon">
                        <div className="feature-item-larkon glass-card">
                            <div className="feat-icon"><Truck size={20} /></div>
                            <div className="feat-text">
                                <h6>Free Shipping</h6>
                                <span>On orders over $200</span>
                            </div>
                        </div>
                        <div className="feature-item-larkon glass-card">
                            <div className="feat-icon"><ShieldCheck size={20} /></div>
                            <div className="feat-text">
                                <h6>Authentic</h6>
                                <span>100% Genuine Product</span>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Info Column */}
                <div className="info-column-larkon">
                    <div className="glass-card primary-info-card">
                        <div className="top-meta">
                            <span className="cat-tag">{product.category?.name || 'Uncategorized'}</span>
                            <span className="sku-tag">SKU: {product.sku || 'N/A'}</span>
                        </div>
                        <h2 className="product-title-larkon">{product.name}</h2>
                        <div className="stats-row">
                            <div className="rating-summary-larkon">
                                <div className="stars-larkon">
                                    {[...Array(5)].map((_, i) => (
                                        <Star key={i} size={16} fill={i < Math.floor(product.rating || 0) ? "var(--primary)" : "none"} color={i < Math.floor(product.rating || 0) ? "var(--primary)" : "var(--text-muted)"} />
                                    ))}
                                </div>
                                <span className="rating-val">{product.rating?.toFixed(1) || '0.0'}</span>
                                <span className="review-count-larkon">({product.numReviews || 0} Reviews)</span>
                            </div>
                            <div className="stock-info-larkon">
                                {product.countInStock > 0 ? (
                                    <span className="stock-pill in"><Check size={14} /> In Stock ({product.countInStock})</span>
                                ) : (
                                    <span className="stock-pill out">Out of Stock</span>
                                )}
                            </div>
                        </div>

                        <div className="price-display-larkon">
                            <span className="main-price">${product.price?.toFixed(2)}</span>
                            {product.discount > 0 && (
                                <span className="original-price">${(product.price * (1 + product.discount / 100)).toFixed(2)}</span>
                            )}
                        </div>

                        <div className="specs-larkon">
                            {product.gender && product.gender !== 'N/A' && (
                                <div className="spec-group">
                                    <label>Gender</label>
                                    <span className="spec-val">{product.gender}</span>
                                </div>
                            )}
                            {product.sizes?.length > 0 && (
                                <div className="spec-group">
                                    <label>Available Sizes</label>
                                    <div className="pills-row">
                                        {product.sizes.map(s => <span key={s} className="larkon-pill">{s}</span>)}
                                    </div>
                                </div>
                            )}
                            {product.colors?.length > 0 && (
                                <div className="spec-group">
                                    <label>Available Colors</label>
                                    <div className="dots-row">
                                        {product.colors.map(c => <div key={c} className="larkon-dot" style={{ backgroundColor: c }}></div>)}
                                    </div>
                                </div>
                            )}
                        </div>

                        <div className="description-larkon">
                            <h5>Description</h5>
                            <p>{product.description}</p>
                        </div>
                    </div>

                    <div className="glass-card specifications-card-larkon">
                        <div className="card-header-larkon">
                            <h4><Zap size={18} /> Specifications</h4>
                        </div>
                        <div className="specs-table-larkon">
                            <div className="spec-row"><span>Brand</span><span>{product.brand || 'N/A'}</span></div>
                            <div className="spec-row"><span>Weight</span><span>{product.weight || 'N/A'}</span></div>
                            <div className="spec-row"><span>Manufacturer</span><span>{product.manufacturer || 'N/A'}</span></div>
                            {product.specifications?.map((s, i) => (
                                <div key={i} className="spec-row"><span>{s.label}</span><span>{s.value}</span></div>
                            ))}
                        </div>
                    </div>
                </div>
            </div>

            {/* Reviews Section */}
            <div className="reviews-section-larkon">
                <div className="glass-card reviews-card-larkon">
                    <div className="reviews-header-larkon">
                        <h4>Customer Reviews</h4>
                        <button className="larkon-btn btn-outline small">View All</button>
                    </div>

                    <div className="reviews-list-larkon">
                        {product.reviews && product.reviews.length > 0 ? (
                            product.reviews.map((rev, i) => (
                                <div key={i} className="review-item-larkon">
                                    <div className="rev-user-info">
                                        <div className="rev-avatar-larkon">
                                            {rev.name.charAt(0)}
                                        </div>
                                        <div className="rev-meta">
                                            <h6>{rev.name}</h6>
                                            <span>{new Date(rev.createdAt).toLocaleDateString()}</span>
                                        </div>
                                        <div className="rev-stars">
                                            {[...Array(5)].map((_, starI) => (
                                                <Star key={starI} size={12} fill={starI < rev.rating ? "var(--primary)" : "none"} color={starI < rev.rating ? "var(--primary)" : "var(--text-muted)"} />
                                            ))}
                                        </div>
                                    </div>
                                    <p className="rev-text">{rev.comment}</p>
                                </div>
                            ))
                        ) : (
                            <div className="empty-reviews">
                                <Award size={40} />
                                <p>No reviews yet for this product.</p>
                                <span>Reviews from the mobile app will appear here.</span>
                            </div>
                        )}
                    </div>
                </div>
            </div>

            <style>{`
                .product-details-larkon { padding: 30px; background: var(--background); min-height: 100vh; color: var(--text-primary); }
                
                .page-header-larkon { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
                .header-left { display: flex; align-items: center; gap: 20px; }
                .back-btn { width: 42px; height: 42px; border-radius: 10px; background: var(--surface); border: 1px solid var(--divider); color: var(--text-primary); display: flex; align-items: center; justify-content: center; transition: var(--transition); }
                .back-btn:hover { background: var(--primary); border-color: var(--primary); color: white; transform: translateX(-4px); }
                .page-header-larkon h1 { font-size: 20px; font-weight: 700; margin-bottom: 4px; }
                .larkon-breadcrumb { font-size: 13px; color: var(--text-muted); display: flex; align-items: center; gap: 8px; }
                .larkon-breadcrumb a { color: inherit; text-decoration: none; transition: 0.2s; }
                .larkon-breadcrumb a:hover { color: var(--primary); }
                .header-right { display: flex; gap: 12px; }

                .larkon-btn { display: flex; align-items: center; gap: 8px; padding: 10px 20px; border-radius: 8px; font-size: 14px; font-weight: 700; cursor: pointer; transition: var(--transition); border: none; }
                .btn-outline { background: var(--surface); color: var(--text-primary); border: 1px solid var(--divider); }
                .btn-outline:hover { background: var(--surface-light); border-color: var(--primary); }
                .btn-primary { background: var(--primary); color: white; box-shadow: 0 4px 12px var(--primary-glow); }
                .btn-primary:hover { filter: brightness(1.1); transform: translateY(-2px); }

                .details-content-larkon { display: grid; grid-template-columns: 420px 1fr; gap: 24px; margin-bottom: 24px; }
                
                .gallery-card-larkon { padding: 0; overflow: hidden; }
                .main-preview-larkon { width: 100%; aspect-ratio: 1; background: #000; position: relative; display: flex; align-items: center; justify-content: center; padding: 20px; }
                .main-preview-larkon img { max-width: 100%; max-height: 100%; object-fit: contain; }
                .preview-badges { position: absolute; top: 16px; left: 16px; display: flex; flex-direction: column; gap: 8px; }
                .badge-disc { background: #ef4444; color: white; font-size: 12px; font-weight: 800; padding: 4px 10px; border-radius: 6px; }
                .badge-status { font-size: 10px; font-weight: 800; text-transform: uppercase; padding: 4px 10px; border-radius: 6px; }
                .badge-status.draft { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }

                .thumbnails-larkon { display: flex; gap: 12px; padding: 20px; overflow-x: auto; background: var(--surface); border-top: 1px solid var(--divider); }
                .thumb-box { width: 64px; height: 64px; border-radius: 8px; background: #000; border: 2px solid transparent; padding: 4px; cursor: pointer; transition: 0.2s; flex-shrink: 0; }
                .thumb-box.active { border-color: var(--primary); }
                .thumb-box img { width: 100%; height: 100%; object-fit: contain; }

                .features-grid-larkon { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 24px; }
                .feature-item-larkon { display: flex; align-items: center; gap: 12px; padding: 16px; }
                .feat-icon { width: 40px; height: 40px; border-radius: 10px; background: var(--primary-glow); color: var(--primary); display: flex; align-items: center; justify-content: center; }
                .feat-text h6 { font-size: 13px; font-weight: 700; color: var(--text-primary); margin-bottom: 2px; }
                .feat-text span { font-size: 11px; color: var(--text-muted); }

                .info-column-larkon { display: flex; flex-direction: column; gap: 24px; }
                .primary-info-card { padding: 30px; }
                .top-meta { display: flex; gap: 15px; margin-bottom: 12px; }
                .cat-tag { font-size: 11px; font-weight: 800; color: var(--primary); text-transform: uppercase; background: var(--primary-glow); padding: 2px 10px; border-radius: 4px; }
                .sku-tag { font-size: 12px; color: var(--text-muted); }
                .product-title-larkon { font-size: 28px; font-weight: 800; color: var(--text-primary); margin-bottom: 15px; }

                .stats-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding-bottom: 20px; border-bottom: 1px solid var(--divider); }
                .rating-summary-larkon { display: flex; align-items: center; gap: 12px; }
                .stars-larkon { display: flex; gap: 2px; }
                .rating-val { font-size: 15px; font-weight: 800; color: var(--text-primary); }
                .review-count-larkon { font-size: 13px; color: var(--text-muted); }
                .stock-pill { font-size: 12px; font-weight: 700; padding: 4px 12px; border-radius: 20px; display: flex; align-items: center; gap: 6px; }
                .stock-pill.in { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
                .stock-pill.out { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

                .price-display-larkon { display: flex; align-items: baseline; gap: 15px; margin-bottom: 30px; }
                .main-price { font-size: 36px; font-weight: 800; color: var(--text-primary); }
                .original-price { font-size: 18px; color: var(--text-muted); text-decoration: line-through; }

                .specs-larkon { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 30px; }
                .spec-group label { display: block; font-size: 12px; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
                .spec-val { font-size: 14px; font-weight: 700; color: var(--text-primary); }
                .pills-row { display: flex; gap: 6px; flex-wrap: wrap; }
                .larkon-pill { font-size: 11px; font-weight: 700; padding: 4px 8px; background: var(--surface-light); border: 1px solid var(--divider); border-radius: 6px; }
                .dots-row { display: flex; gap: 8px; }
                .larkon-dot { width: 18px; height: 18px; border-radius: 50%; border: 1px solid var(--divider); }

                .description-larkon h5 { font-size: 14px; font-weight: 700; margin-bottom: 10px; text-transform: uppercase; color: var(--text-primary); }
                .description-larkon p { font-size: 14px; line-height: 1.7; color: var(--text-muted); }

                .specifications-card-larkon { padding: 0; }
                .card-header-larkon { padding: 16px 24px; border-bottom: 1px solid var(--divider); display: flex; align-items: center; gap: 10px; }
                .card-header-larkon h4 { font-size: 14px; font-weight: 700; }
                .specs-table-larkon { padding: 10px 0; }
                .spec-row { display: flex; justify-content: space-between; padding: 12px 24px; border-bottom: 1px solid var(--divider); font-size: 13px; }
                .spec-row:last-child { border: none; }
                .spec-row span:first-child { color: var(--text-muted); }
                .spec-row span:last-child { color: var(--text-primary); font-weight: 600; }

                .reviews-section-larkon { margin-top: 24px; }
                .reviews-card-larkon { padding: 24px; }
                .reviews-header-larkon { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .reviews-header-larkon h4 { font-size: 16px; font-weight: 700; }
                
                .review-item-larkon { padding: 20px; background: var(--surface-light); border-radius: 12px; margin-bottom: 16px; }
                .rev-user-info { display: flex; align-items: center; gap: 15px; margin-bottom: 12px; }
                .rev-avatar-larkon { width: 36px; height: 36px; border-radius: 10px; background: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 16px; }
                .rev-meta h6 { font-size: 14px; font-weight: 700; margin-bottom: 2px; }
                .rev-meta span { font-size: 11px; color: var(--text-muted); }
                .rev-stars { margin-left: auto; display: flex; gap: 2px; }
                .rev-text { font-size: 13px; color: var(--text-muted); line-height: 1.6; }

                .empty-reviews { padding: 60px 0; text-align: center; color: var(--text-muted); display: flex; flex-direction: column; align-items: center; gap: 12px; }
                .empty-reviews p { font-size: 15px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .empty-reviews span { font-size: 13px; }

                .loading-state { height: 80vh; display: flex; align-items: center; justify-content: center; }
                .spinner-larkon { width: 44px; height: 44px; border: 3px solid var(--surface-light); border-top-color: var(--primary); border-radius: 50%; animation: spin 0.8s linear infinite; }
                @keyframes spin { to { transform: rotate(360deg); } }

                @keyframes popIn {
                    from { opacity: 0; transform: scale(0.95); }
                    to { opacity: 1; transform: scale(1); }
                }
                .glass-card { background: var(--surface); border: 1px solid var(--divider); border-radius: 16px; animation: popIn 0.4s ease-out backwards; }
            `}</style>
        </div>
    );
};

export default ProductDetailsPage;
