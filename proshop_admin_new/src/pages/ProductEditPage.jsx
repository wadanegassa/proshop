import React, { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { toast } from 'react-hot-toast';
import { productsAPI, categoriesAPI, uploadAPI, getImageUrl } from '../services/api';
import { Upload, X, Plus, ChevronRight, Save, Trash2, ArrowLeft, Star } from 'lucide-react';

const ProductEditPage = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [categories, setCategories] = useState([]);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [images, setImages] = useState([]);
    const [formData, setFormData] = useState({
        name: '', category: '', brand: '', price: 0, countInStock: 0,
        description: '', gender: 'Men', weight: '', sku: '',
        discount: 0, tax: 0, sizes: [], colors: [], shoeSizes: []
    });

    const AVAILABLE_SIZES = ['XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'];
    const AVAILABLE_SHOE_SIZES = ['38', '39', '40', '41', '42', '43', '44', '45', '46'];
    const AVAILABLE_COLORS = [
        { name: 'Red', hex: '#ef4444' }, { name: 'Blue', hex: '#3b82f6' },
        { name: 'Green', hex: '#22c55e' }, { name: 'Black', hex: '#000000' },
        { name: 'White', hex: '#ffffff' }, { name: 'Orange', hex: '#ff6b00' },
    ];

    useEffect(() => {
        const fetchData = async () => {
            try {
                const [productRes, catRes] = await Promise.all([
                    productsAPI.getOne(id),
                    categoriesAPI.getAll()
                ]);
                const product = productRes.data.data.product;
                setFormData({
                    name: product.name,
                    category: product.category?._id || '',
                    brand: product.brand || '',
                    price: product.price,
                    countInStock: product.countInStock,
                    description: product.description,
                    gender: product.gender || 'Men',
                    weight: product.weight || '',
                    sku: product.sku || '',
                    discount: product.discount || 0,
                    tax: product.tax || 0,
                    sizes: product.sizes || [],
                    colors: product.colors || [],
                    shoeSizes: product.shoeSizes || [],
                    rating: product.rating,
                    numReviews: product.numReviews
                });
                setImages(product.images || []);
                setCategories(catRes.data.data.categories);
            } catch (error) { console.error(error); }
            finally { setLoading(false); }
        };
        fetchData();
    }, [id]);

    const toggleSize = (size) => {
        setFormData(prev => ({
            ...prev, sizes: prev.sizes.includes(size) ? prev.sizes.filter(s => s !== size) : [...prev.sizes, size]
        }));
    };

    const toggleShoeSize = (size) => {
        setFormData(prev => ({
            ...prev, shoeSizes: prev.shoeSizes.includes(size) ? prev.shoeSizes.filter(s => s !== size) : [...prev.shoeSizes, size]
        }));
    };

    const toggleColor = (color) => {
        setFormData(prev => ({
            ...prev, colors: prev.colors.includes(color) ? prev.colors.filter(c => c !== color) : [...prev.colors, color]
        }));
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleImageUpload = async (e) => {
        const files = Array.from(e.target.files);
        const uploadedImages = [];
        for (const file of files) {
            const data = new FormData();
            data.append('image', file);
            try {
                const res = await uploadAPI.uploadImage(data);
                uploadedImages.push(res.data.image);
            } catch (error) { console.error('Upload failed', error); }
        }
        setImages(prev => [...prev, ...uploadedImages]);
    };

    const removeImage = (index) => setImages(images.filter((_, i) => i !== index));

    const handleSubmit = async (e) => {
        e.preventDefault();
        setSubmitting(true);
        try {
            const submissionData = {
                ...formData,
                price: Number(formData.price),
                countInStock: Number(formData.countInStock),
                discount: Number(formData.discount),
                tax: Number(formData.tax),
                images
            };

            console.log('Submitting Product Update:', submissionData);

            await productsAPI.update(id, submissionData);
            toast.success('Product updated successfully!');
            setTimeout(() => navigate('/products'), 500);
        } catch (error) {
            console.error('Update failed:', error);
            const errorMsg = error.response?.data?.message || 'Failed to update product.';
            toast.error(errorMsg);
        } finally { setSubmitting(false); }
    };

    if (loading) return <div className="loading-state">Loading product details...</div>;

    return (
        <div className="product-form-page fade-in">
            <div className="form-header">
                <div className="header-info">
                    <h1 className="cool-title">EDIT PRODUCT <span className="title-edit">✎</span></h1>
                    <div className="breadcrumb">
                        <Link to="/products">Products</Link> <ChevronRight size={14} /> <span>Edit</span>
                    </div>
                </div>
                <div className="header-btns">
                    <Link to="/products" className="btn-secondary">
                        <ArrowLeft size={16} /> Go Back
                    </Link>
                </div>
            </div>

            <form onSubmit={handleSubmit} className="form-layout">
                <div className="form-sidebar">
                    <div className="preview-card glass-card">
                        <div className="preview-image">
                            {images.length > 0 ? (
                                <img src={getImageUrl(images[0])} alt="Preview" />
                            ) : (
                                <div className="placeholder-icon"><Upload size={48} color="var(--divider)" /></div>
                            )}
                        </div>
                        <div className="preview-info">
                            <h3>{formData.name || 'Product Name'}</h3>
                            <div className="p-price">
                                {formData.discount > 0 ? (
                                    <>
                                        <span className="price-label">Price:</span>
                                        <span className="old-price">${Number(formData.price).toFixed(2)}</span>
                                        <span className="new-price">${(formData.price * (1 - formData.discount / 100)).toFixed(2)}</span>
                                        <small className="discount-tag">({formData.discount}% off)</small>
                                    </>
                                ) : (
                                    <>
                                        <span className="price-label">Price:</span>
                                        <div className="current-price">${Number(formData.price).toFixed(2)}</div>
                                    </>
                                )}
                            </div>
                            <div className="p-rating-preview">
                                <Star size={14} fill="#ffb400" color="#ffb400" />
                                <span className="preview-rating-val">{formData.rating || 0}</span>
                                <span className="preview-review-count">({formData.reviewCount || formData.numReviews || 0})</span>
                            </div>
                            <div className="p-sizes">
                                <span>Size:</span>
                                <div className="size-tags">
                                    {formData.sizes.map(s => <span key={s}>{s}</span>)}
                                </div>
                            </div>
                            {formData.shoeSizes.length > 0 && (
                                <div className="p-sizes">
                                    <span>Shoe Size:</span>
                                    <div className="size-tags">
                                        {formData.shoeSizes.map(s => <span key={s}>{s}</span>)}
                                    </div>
                                </div>
                            )}
                        </div>
                    </div>

                    <div className="image-upload-card glass-card">
                        <label className="upload-box">
                            <Upload size={32} />
                            <span>Click to upload images</span>
                            <input type="file" multiple onChange={handleImageUpload} hidden />
                        </label>
                        <div className="uploaded-list">
                            {images.map((img, i) => (
                                <div key={i} className="mini-thumb">
                                    <img src={getImageUrl(img)} alt="" />
                                    <button type="button" onClick={() => removeImage(i)} className="remove-btn"><X size={12} /></button>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>

                <div className="form-main">
                    <div className="glass-card main-info-card">
                        <div className="card-header"><h4>Product Information</h4></div>
                        <div className="form-grid">
                            <div className="input-field full">
                                <label>Product Name</label>
                                <input type="text" name="name" value={formData.name} onChange={handleInputChange} placeholder="Items Name" required />
                            </div>
                            <div className="input-field">
                                <label>Category</label>
                                <select name="category" value={formData.category} onChange={handleInputChange} required>
                                    <option value="">Select Category</option>
                                    {categories.map(c => <option key={c._id} value={c._id}>{c.name}</option>)}
                                </select>
                            </div>
                            <div className="input-field">
                                <label>Brand</label>
                                <input type="text" name="brand" value={formData.brand} onChange={handleInputChange} placeholder="Brand Name" />
                            </div>
                            <div className="input-field">
                                <label>Weight</label>
                                <input type="text" name="weight" value={formData.weight} onChange={handleInputChange} placeholder="Weight (e.g. 500g)" />
                            </div>
                            <div className="input-field">
                                <label>Gender</label>
                                <select name="gender" value={formData.gender} onChange={handleInputChange}>
                                    <option value="Men">Men</option>
                                    <option value="Women">Women</option>
                                    <option value="Unisex">Unisex</option>
                                </select>
                            </div>
                            <div className="input-field">
                                <label>SKU</label>
                                <input type="text" name="sku" value={formData.sku} onChange={handleInputChange} placeholder="PRO-SKU-001" />
                            </div>
                        </div>

                        <div className="divider"></div>

                        <div className="card-header"><h4>Pricing & Stock</h4></div>
                        <div className="form-grid">
                            <div className="input-field">
                                <label>Base Price ($)</label>
                                <input type="number" name="price" value={formData.price} onChange={handleInputChange} required />
                            </div>
                            <div className="input-field">
                                <label>Discount (%)</label>
                                <input type="number" name="discount" value={formData.discount} onChange={handleInputChange} />
                            </div>
                            <div className="input-field">
                                <label>Tax (%)</label>
                                <input type="number" name="tax" value={formData.tax} onChange={handleInputChange} />
                            </div>
                            <div className="input-field">
                                <label>Stock Quantity</label>
                                <input type="number" name="countInStock" value={formData.countInStock} onChange={handleInputChange} required />
                            </div>
                        </div>

                        <div className="divider"></div>

                        <div className="card-header"><h4>Description</h4></div>
                        <div className="input-field full">
                            <textarea name="description" value={formData.description} onChange={handleInputChange} placeholder="Product description..." rows="5"></textarea>
                        </div>
                    </div>

                    <div className="glass-card variants-card">
                        <div className="card-header"><h4>Variants & Options</h4></div>
                        <div className="variant-selectors">
                            <div className="variant-section">
                                <label>Sizes</label>
                                <div className="size-selector">
                                    {AVAILABLE_SIZES.map(s => (
                                        <button key={s} type="button" onClick={() => toggleSize(s)} className={`size-btn ${formData.sizes.includes(s) ? 'active' : ''}`}>{s}</button>
                                    ))}
                                </div>
                            </div>
                            <div className="variant-section">
                                <label>Colors</label>
                                <div className="color-selector">
                                    {AVAILABLE_COLORS.map(c => (
                                        <button key={c.name} type="button" onClick={() => toggleColor(c.name)} className={`color-btn-select ${formData.colors.includes(c.name) ? 'active' : ''}`} style={{ backgroundColor: c.hex }} title={c.name}></button>
                                    ))}
                                </div>
                            </div>
                            <div className="variant-section">
                                <label>Shoe Sizes</label>
                                <div className="size-selector">
                                    {AVAILABLE_SHOE_SIZES.map(s => (
                                        <button key={s} type="button" onClick={() => toggleShoeSize(s)} className={`size-btn ${formData.shoeSizes.includes(s) ? 'active' : ''}`}>{s}</button>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="form-actions">
                        <button type="button" onClick={() => navigate('/products')} className="btn-secondary-cancel">Cancel</button>
                        <button type="submit" disabled={submitting} className="btn-primary">
                            <Save size={18} /> {submitting ? 'Saving...' : 'Save Changes'}
                        </button>
                    </div>
                </div>
            </form>

            <style>{`
                .product-form-page { padding: 0; }
                .form-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .form-header h1.cool-title { font-size: 18px; font-weight: 800; color: var(--text-primary); margin-bottom: 4px; letter-spacing: 1px; display: flex; align-items: center; gap: 8px; }
                .title-edit { color: var(--primary); filter: drop-shadow(0 0 8px var(--primary-glow)); font-size: 20px; line-height: 1; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                .breadcrumb a { color: inherit; text-decoration: none; }
                .breadcrumb a:hover { color: var(--primary); }

                .header-btns { display: flex; gap: 12px; }
                .btn-secondary { 
                    height: 35px; padding: 0 12px; display: flex; align-items: center; justify-content: center; gap: 6px;
                    background: var(--surface-light); border: 1px solid var(--divider); border-radius: 6px; color: var(--text-primary); 
                    transition: var(--transition); text-decoration: none; font-size: 12px; font-weight: 600;
                }
                .btn-secondary:hover { background: var(--surface); border-color: var(--text-muted); color: var(--text-primary); }

                .form-layout { display: grid; grid-template-columns: 350px 1fr; gap: 24px; }
                
                .form-sidebar { display: flex; flex-direction: column; gap: 24px; }
                .preview-card { padding: 24px; }
                .preview-image { aspect-ratio: 1; background: var(--sidebar-bg); border-radius: 12px; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px solid var(--divider); margin-bottom: 20px; }
                .preview-image img { width: 100%; height: 100%; object-fit: contain; }
                .preview-info h3 { font-size: 16px; margin-bottom: 12px; color: var(--text-primary); }
                .preview-info h3 { font-size: 16px; margin-bottom: 12px; color: var(--text-primary); }
                .p-price { font-size: 18px; font-weight: 700; color: var(--primary); display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
                .price-label { font-size: 13px; color: var(--text-secondary); font-weight: 400; }
                .old-price { text-decoration: line-through; color: var(--text-secondary); font-size: 14px; font-weight: 400; }
                .new-price { font-size: 18px; font-weight: 700; color: var(--text-primary); }
                .discount-tag { background: rgba(239, 68, 68, 0.15); color: #ef4444; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 700; }
                .p-rating-preview { display: flex; align-items: center; gap: 6px; margin-top: 8px; }
                .preview-rating-val { font-size: 14px; font-weight: 700; color: var(--text-primary); }
                .preview-review-count { font-size: 12px; color: var(--text-muted); }
                .current-price { color: var(--text-primary); }
                .size-tags { display: flex; gap: 6px; margin-top: 8px; }
                .size-tags span { background: var(--surface-light); padding: 2px 8px; font-size: 11px; border-radius: 4px; }

                .image-upload-card { padding: 20px; }
                .upload-box { border: 2px dashed var(--divider); border-radius: 12px; height: 120px; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 10px; cursor: pointer; transition: var(--transition); }
                .upload-box:hover { border-color: var(--primary); background: rgba(255,107,0,0.05); }
                .uploaded-list { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin-top: 16px; }
                .mini-thumb { aspect-ratio: 1; position: relative; border-radius: 6px; overflow: hidden; border: 1px solid var(--divider); }
                .mini-thumb img { width: 100%; height: 100%; object-fit: cover; }
                .remove-btn { position: absolute; top: 2px; right: 2px; width: 16px; height: 16px; border-radius: 50%; background: var(--error); color: white; }

                .form-main { display: flex; flex-direction: column; gap: 24px; }
                .main-info-card, .variants-card { padding: 32px; }
                .card-header { margin-bottom: 24px; }
                .card-header h4 { font-size: 15px; font-weight: 700; color: var(--text-primary); }
                .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px 24px; }
                .input-field { display: flex; flex-direction: column; gap: 8px; }
                .input-field.full { grid-column: span 2; }
                .input-field label { font-size: 13px; font-weight: 600; color: var(--text-secondary); }
                .input-field input, .input-field select, .input-field textarea { background: var(--surface-light); border: 1px solid var(--divider); border-radius: 8px; padding: 10px 16px; color: var(--text-primary); font-size: 13px; }
                
                .divider { height: 1px; background: var(--divider); margin: 32px 0; }

                .variant-selectors { display: flex; flex-direction: column; gap: 24px; }
                .size-selector { display: flex; gap: 8px; flex-wrap: wrap; }
                .size-btn { width: 44px; height: 44px; border-radius: 8px; background: var(--surface-light); border: 1px solid var(--divider); color: var(--text-muted); font-weight: 600; }
                .size-btn.active { background: var(--primary); color: white; border-color: var(--primary); }
                .color-selector { display: flex; gap: 12px; }
                .color-btn-select { width: 32px; height: 32px; border-radius: 50%; border: 2px solid transparent; box-shadow: 0 0 0 1px var(--divider); }
                .color-btn-select.active { border-color: white; box-shadow: 0 0 0 2px var(--primary); }

                .form-actions { display: flex; gap: 16px; margin-top: 8px; margin-bottom: 40px; }
                .btn-primary, .btn-secondary-cancel { height: 44px; padding: 0 32px; font-weight: 700; border-radius: 8px; }
                .btn-secondary-cancel { background: var(--surface-light); color: var(--text-primary); border: 1px solid var(--divider); }
                
                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }
            `}</style>
        </div>
    );
};

export default ProductEditPage;
