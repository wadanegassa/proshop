import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { productsAPI, getImageUrl } from '../services/api';
import { Star, ChevronRight, Edit, ArrowLeft, Check, Truck, Gift, Headphones, Tag, Clock, Share2, Heart } from 'lucide-react';

const ProductDetailsPage = () => {
    const { id } = useParams();
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
            <div className="spinner"></div>
        </div>
    );

    if (!product) return <div className="error-state glass-card">Product not found.</div>;

    return (
        <div className="product-details-page fade-in">
            {/* Header Area */}
            <div className="details-top-header">
                <div className="header-info">
                    <h1>PRODUCT DETAILS</h1>
                    <div className="breadcrumb">
                        <Link to="/products">Products</Link> <ChevronRight size={12} /> <span>Product Details</span>
                    </div>
                </div>
                <div className="header-btns">
                    <Link to="/products" className="btn-secondary">
                        <ArrowLeft size={16} /> Go Back
                    </Link>
                    <Link to={`/products/edit/${product._id}`} className="btn-primary">
                        <Edit size={16} /> Edit Product
                    </Link>
                </div>
            </div>

            {/* Main Content Grid */}
            <div className="details-main-grid">
                {/* Visuals Column (1 part) */}
                <div className="gallery-section">
                    <div className="glass-card gallery-card">
                        <div className="main-display">
                            <img
                                src={getImageUrl(product.images?.[activeImage])}
                                alt={product.name}
                                onError={(e) => { e.target.onerror = null; e.target.src = 'https://via.placeholder.com/600x600?text=No+Image'; }}
                            />
                            <div className="floating-actions">
                                <button className="action-circle"><Heart size={18} /></button>
                                <button className="action-circle"><Share2 size={18} /></button>
                            </div>
                        </div>
                        <div className="thumbs-row">
                            {product.images?.map((img, i) => (
                                <div key={i} className={`thumb-item ${activeImage === i ? 'active' : ''}`} onClick={() => setActiveImage(i)}>
                                    <img src={getImageUrl(img)} alt="" />
                                </div>
                            ))}
                        </div>
                        <div className="visual-mock-btns">
                            <button className="btn-mock-primary"><Tag size={18} /> Preview Cart</button>
                            <button className="btn-mock-outline">View Order Flow</button>
                        </div>
                    </div>
                </div>

                {/* Info Column (2 parts) */}
                <div className="info-section">
                    <div className="glass-card info-card">
                        <div className="new-badge">New Arrival</div>
                        <h2 className="p-title">{product.name}</h2>
                        <div className="rating-row">
                            <div className="stars-group">
                                {[...Array(5)].map((_, i) => <Star key={i} size={14} fill={i < Math.floor(product.rating || 5) ? "currentColor" : "none"} color="#ffb400" />)}
                            </div>
                            <span className="rating-text">{product.rating || '4.5'} (53 Reviews)</span>
                        </div>

                        <div className="price-row">
                            <span className="current-price">${product.price}</span>
                            {product.discount > 0 && (
                                <>
                                    <span className="old-price">${(product.price * (1 + product.discount / 100)).toFixed(2)}</span>
                                    <span className="disc-badge">({product.discount}% OFF)</span>
                                </>
                            )}
                        </div>

                        <div className="selectors">
                            <div className="select-group">
                                <label>Colors &gt; <span>Dark</span></label>
                                <div className="color-dots">
                                    {product.colors?.map(c => (
                                        <div key={c} className="color-circle" style={{ backgroundColor: c.toLowerCase() }}></div>
                                    ))}
                                </div>
                            </div>
                            <div className="select-group">
                                <label>Size &gt; <span>{product.sizes?.[0] || 'M'}</span></label>
                                <div className="size-boxes">
                                    {product.sizes?.map(s => <div key={s} className="size-box">{s}</div>)}
                                </div>
                            </div>
                        </div>

                        <div className="check-list">
                            <div className="check-item"><Check size={14} /> {product.countInStock > 0 ? 'In Stock' : 'Out of Stock'}</div>
                            <div className="check-item"><Check size={14} /> Free delivery available</div>
                            <div className="check-item"><Check size={14} /> Sales 10% Off Use Code: CODE123</div>
                        </div>

                        <div className="desc-block">
                            <h4>Description :</h4>
                            <p>{product.description || "Top in sweatshirt fabric made from a cotton blend with a soft brushed inside. Relaxed fit with dropped shoulders, long sleeves and ribbing around the neckline, cuffs and hem. Small metal text applique."}</p>
                        </div>
                    </div>
                </div>
            </div>

            {/* Service Bar */}
            <div className="service-grid">
                <div className="glass-card service-box">
                    <div className="icon-wrap"><Truck size={20} /></div>
                    <div className="text-wrap">
                        <h5>Free shipping for all orders over $200</h5>
                        <span>Only in this week</span>
                    </div>
                </div>
                <div className="glass-card service-box">
                    <div className="icon-wrap"><Tag size={20} /></div>
                    <div className="text-wrap">
                        <h5>Special discounts for customers</h5>
                        <span>Coupons up to $100</span>
                    </div>
                </div>
                <div className="glass-card service-box">
                    <div className="icon-wrap"><Gift size={20} /></div>
                    <div className="text-wrap">
                        <h5>Free gift wrapping</h5>
                        <span>With 100 letters custom note</span>
                    </div>
                </div>
                <div className="glass-card service-box">
                    <div className="icon-wrap"><Headphones size={20} /></div>
                    <div className="text-wrap">
                        <h5>Expert Customer Service</h5>
                        <span>8:00 - 20:00, 7 days / week</span>
                    </div>
                </div>
            </div>

            {/* Footer Grid */}
            <div className="bottom-grid">
                <div className="glass-card table-card">
                    <div className="card-top">
                        <div className="icon-label"><Clock size={16} /> Items Detail</div>
                    </div>
                    <div className="detail-table">
                        <div className="d-row"><span>Category :</span> <span>{product.category?.name || 'Uncategorized'}</span></div>
                        <div className="d-row"><span>Brand :</span> <span>{product.brand || 'N/A'}</span></div>
                        <div className="d-row"><span>SKU :</span> <span>{product.sku || 'N/A'}</span></div>
                        <div className="d-row"><span>Gender :</span> <span>{product.gender || 'N/A'}</span></div>
                        <div className="d-row"><span>Weight :</span> <span>{product.weight || 'N/A'}</span></div>
                        <div className="d-row"><span>Department :</span> <span>Men</span></div>
                        <div className="d-row"><span>Created At :</span> <span>{new Date(product.createdAt).toLocaleDateString()}</span></div>
                    </div>
                </div>

                <div className="glass-card review-card">
                    <div className="card-top"><h4>Top Review From World</h4></div>
                    <div className="review-box">
                        <div className="rev-header">
                            <div className="rev-avatar"><img src="https://i.pravatar.cc/100?u=sarah" alt="" /></div>
                            <div className="rev-user">
                                <div className="rev-name">Sarah Johnson <span className="rev-date">16 November 2023</span></div>
                                <div className="stars-group">
                                    {[...Array(5)].map((_, i) => <Star key={i} size={10} fill="#ffb400" color="#ffb400" />)}
                                </div>
                            </div>
                        </div>
                        <div className="rev-content">
                            <h6>Excellent Quality</h6>
                            <p>"Reviewed in United States. Absolutely love this product! The quality is outstanding and the fit is perfect. Highly recommended for anyone looking for premium quality gear."</p>
                        </div>
                        <div className="rev-footer">
                            <button>Helpful</button>
                            <button>Report</button>
                        </div>
                    </div>
                </div>
            </div>

            <style>{`
                .product-details-page { padding: 0; max-width: 1400px; margin: 0 auto; }
                .details-top-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .header-info h1 { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                .breadcrumb a { color: inherit; text-decoration: none; }
                .breadcrumb a:hover { color: var(--primary); }
                .header-btns { display: flex; gap: 12px; }
                
                .btn-secondary { height: 38px; padding: 0 16px; background: var(--surface-light); border: 1px solid var(--divider); color: var(--text-primary); text-decoration: none; border-radius: 8px; font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 8px; transition: var(--transition); }
                .btn-secondary:hover { background: var(--surface); color: var(--text-primary); }

                .details-main-grid { display: grid; grid-template-columns: 1fr 1.8fr; gap: 24px; margin-bottom: 24px; }
                .gallery-card { padding: 24px; }
                .main-display { position: relative; width: 100%; aspect-ratio: 4/5; background: var(--sidebar-bg); border-radius: 12px; display: flex; align-items: center; justify-content: center; padding: 40px; border: 1px solid var(--divider); margin-bottom: 24px; }
                .main-display img { max-width: 100%; max-height: 100%; object-fit: contain; filter: drop-shadow(0 0 20px rgba(0,0,0,0.3)); }
                
                .floating-actions { position: absolute; top: 16px; right: 16px; display: flex; flex-direction: column; gap: 8px; }
                .action-circle { width: 36px; height: 36px; border-radius: 50%; background: rgba(0,0,0,0.4); backdrop-filter: blur(4px); border: 1px solid rgba(255,255,255,0.1); color: white; }
                .action-circle:hover { color: var(--primary); }

                .thumbs-row { display: flex; gap: 12px; margin-bottom: 32px; overflow-x: auto; padding-bottom: 4px; }
                .thumb-item { width: 64px; height: 64px; border-radius: 8px; background: var(--sidebar-bg); border: 2px solid transparent; padding: 6px; cursor: pointer; }
                .thumb-item.active { border-color: var(--primary); }
                .thumb-item img { width: 100%; height: 100%; object-fit: contain; }

                .visual-mock-btns { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
                .btn-mock-primary { height: 48px; background: var(--primary); color: white; border-radius: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; font-size: 13px; gap: 8px; }
                .btn-mock-outline { height: 48px; background: transparent; border: 1px solid var(--divider); color: var(--text-primary); border-radius: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; font-size: 13px; }

                .info-card { padding: 32px; height: 100%; }
                .new-badge { background: #0088ff1a; color: #0088ff; font-size: 10px; font-weight: 800; text-transform: uppercase; padding: 2px 8px; border-radius: 4px; width: fit-content; margin-bottom: 12px; }
                .p-title { font-size: 24px; font-weight: 700; color: var(--text-primary); margin-bottom: 8px; }
                .rating-row { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding-bottom: 20px; border-bottom: 1px solid var(--divider); }
                .stars-group { display: flex; gap: 2px; }
                .rating-text { font-size: 13px; color: var(--text-muted); }

                .price-row { display: flex; align-items: baseline; gap: 12px; margin-bottom: 32px; }
                .current-price { font-size: 32px; font-weight: 700; color: var(--text-primary); }
                .old-price { font-size: 16px; color: var(--text-muted); text-decoration: line-through; }
                .disc-badge { font-size: 14px; color: var(--error); font-weight: 600; }

                .selectors { display: flex; flex-direction: column; gap: 24px; margin-bottom: 32px; }
                .select-group label { font-size: 13px; font-weight: 700; color: var(--text-primary); margin-bottom: 12px; display: block; }
                .select-group label span { color: var(--text-muted); font-weight: 400; }
                .color-dots { display: flex; gap: 12px; }
                .color-circle { width: 28px; height: 28px; border-radius: 50%; border: 2px solid rgba(255,255,255,0.1); cursor: pointer; }
                .size-boxes { display: flex; gap: 8px; }
                .size-box { width: 36px; height: 36px; background: var(--surface-light); border: 1px solid var(--divider); color: var(--text-secondary); display: flex; align-items: center; justify-content: center; border-radius: 6px; font-size: 12px; font-weight: 600; }

                .check-list { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 32px; }
                .check-item { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--text-secondary); font-weight: 500; }
                .check-item :first-child { color: var(--success); }

                .desc-block h4 { font-size: 13px; font-weight: 700; color: var(--text-primary); margin-bottom: 8px; text-transform: uppercase; }
                .desc-block p { font-size: 13px; line-height: 1.6; color: var(--text-muted); }

                .service-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 24px; }
                .service-box { padding: 20px; display: flex; align-items: center; gap: 16px; }
                .icon-wrap { width: 44px; height: 44px; border-radius: 10px; background: rgba(255,107,0,0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; }
                .text-wrap h5 { font-size: 12px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; line-height: 1.3; }
                .text-wrap span { font-size: 10px; color: var(--text-muted); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; }

                .bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
                .table-card, .review-card { padding: 32px; }
                .card-top { margin-bottom: 24px; border-bottom: 1px solid var(--divider); padding-bottom: 12px; }
                .icon-label { font-size: 14px; font-weight: 700; color: var(--text-primary); display: flex; align-items: center; gap: 8px; }
                .card-top h4 { font-size: 14px; font-weight: 700; color: var(--text-primary); }

                .detail-table .d-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--divider); font-size: 13px; }
                .detail-table .d-row:last-child { border: none; }
                .detail-table .d-row span:first-child { color: var(--text-muted); }
                .detail-table .d-row span:last-child { color: var(--text-primary); font-weight: 500; }

                .review-box { background: var(--sidebar-bg); border-radius: 12px; border: 1px solid var(--divider); padding: 24px; }
                .rev-header { display: flex; gap: 16px; margin-bottom: 16px; }
                .rev-avatar { width: 44px; height: 44px; border-radius: 50%; overflow: hidden; }
                .rev-avatar img { width: 100%; height: 100%; object-fit: cover; }
                .rev-user { display: flex; flex-direction: column; gap: 4px; }
                .rev-name { font-size: 14px; font-weight: 700; color: var(--text-primary); }
                .rev-date { font-size: 11px; color: var(--text-muted); font-weight: 400; margin-left: 8px; }
                .rev-content h6 { font-size: 13px; font-weight: 700; color: var(--text-primary); margin-bottom: 8px; }
                .rev-content p { font-size: 12px; color: var(--text-muted); line-height: 1.6; }
                .rev-footer { margin-top: 16px; display: flex; gap: 16px; }
                .rev-footer button { background: transparent; color: var(--text-muted); font-size: 11px; font-weight: 700; text-transform: uppercase; }
                .rev-footer button:hover { color: var(--primary); }

                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; }
                .spinner { width: 40px; height: 40px; border: 3px solid rgba(255,107,0,0.1); border-top-color: var(--primary); border-radius: 50%; animation: spin 0.8s linear infinite; }
                @keyframes spin { to { transform: rotate(360deg); } }
                .error-state { padding: 40px; text-align: center; color: var(--error); margin-top: 40px; }

                @media (max-width: 1100px) {
                    .details-main-grid { grid-template-columns: 1fr; }
                    .service-grid { grid-template-columns: 1fr 1fr; }
                    .bottom-grid { grid-template-columns: 1fr; }
                }
                @media (max-width: 600px) {
                    .service-grid { grid-template-columns: 1fr; }
                }
            `}</style>
        </div>
    );
};

export default ProductDetailsPage;
