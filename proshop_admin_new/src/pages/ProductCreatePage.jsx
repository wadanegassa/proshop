import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-hot-toast';
import { productsAPI, categoriesAPI, uploadAPI, getImageUrl } from '../services/api';
import { Upload, X, Plus, ChevronRight, Save, ArrowLeft, Image, UploadCloud, Star } from 'lucide-react';

const ProductCreatePage = () => {
    const navigate = useNavigate();
    const [categories, setCategories] = useState([]);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [isUploading, setIsUploading] = useState(false);
    const [images, setImages] = useState([]);
    const [formData, setFormData] = useState({
        name: '', category: '', brand: '', price: 0, countInStock: 0,
        description: '', gender: 'N/A', weight: '', sku: '',
        discount: 0, tax: 0, sizes: [], colors: [], shoeSizes: [],
        specifications: [], highlights: [], status: 'Draft'
    });

    const AVAILABLE_SHOE_SIZES = ['38', '39', '40', '41', '42', '43', '44', '45', '46'];

    useEffect(() => {
        const fetchCategories = async () => {
            try {
                const res = await categoriesAPI.getAll();
                setCategories(res.data.data.categories);
            } catch (error) { console.error(error); }
            finally { setLoading(false); }
        };
        fetchCategories();
    }, []);

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
        if (files.length === 0) return;

        setIsUploading(true);
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
        setIsUploading(false);
    };

    const removeImage = (index) => setImages(images.filter((_, i) => i !== index));

    const handleSubmit = async (e) => {
        e.preventDefault();
        setSubmitting(true);

        const submissionData = {
            ...formData,
            price: Number(formData.price) || 0,
            countInStock: Number(formData.countInStock) || 0,
            discount: Number(formData.discount) || 0,
            tax: Number(formData.tax) || 0,
            images
        };

        try {
            await productsAPI.create(submissionData);
            toast.success('Product created successfully!');
            setTimeout(() => navigate('/products'), 500);
        } catch (error) {
            console.error('Create failed:', error);
            toast.error('Failed to create product.');
        } finally { setSubmitting(false); }
    };

    if (loading) return <div className="loading-state">Loading categories...</div>;

    return (
        <div className="admin-page create-product-larkon">
            <div className="page-header-larkon">
                <div className="header-left">
                    <button onClick={() => navigate('/products')} className="back-btn"><ArrowLeft size={18} /></button>
                    <h1>Create Product</h1>
                </div>
            </div>

            <form onSubmit={handleSubmit} className="larkon-content">
                {/* Left Column: Preview */}
                <div className="larkon-sidebar">
                    <div className="glass-card preview-hero">
                        <div className="preview-img-container">
                            {images.length > 0 ? (
                                <img src={getImageUrl(images[0])} alt="Preview" />
                            ) : (
                                <div className="img-placeholder"><Image size={48} /><span>Photo Preview</span></div>
                            )}
                        </div>
                        <div className="preview-details">
                            <h3>{formData.name || 'Product Name'} <small>({categories.find(c => c._id === formData.category)?.name || 'Category'})</small></h3>
                            <div className="preview-price">
                                {formData.discount > 0 ? (
                                    <>
                                        <span className="price-label">Price:</span>
                                        <span className="old-price">${formData.price}</span>
                                        <span className="new-price">${(formData.price * (1 - formData.discount / 100)).toFixed(2)}</span>
                                        <small className="discount-tag">({formData.discount}% off)</small>
                                    </>
                                ) : (
                                    <>
                                        <span className="price-label">Price:</span>
                                        <span className="current-price">${formData.price || '0.00'}</span>
                                    </>
                                )}
                            </div>
                            <div className="preview-rating-larkon" style={{ display: 'flex', alignItems: 'center', gap: '6px', marginTop: '10px', color: '#ffb400' }}>
                                <Star size={14} fill="#ffb400" />
                                <span style={{ fontWeight: '700', fontSize: '14px', color: 'var(--text-primary)' }}>0.0</span>
                                <span style={{ fontSize: '12px', color: 'var(--text-muted)' }}>(0 Reviews)</span>
                            </div>

                            <div className="preview-variants">
                                {formData.sizes.length > 0 && (
                                    <div className="preview-variant-group">
                                        <label>Sizes:</label>
                                        <div className="pill-row">
                                            {formData.sizes.map(s => <span key={s} className="size-pill-small">{s}</span>)}
                                        </div>
                                    </div>
                                )}
                                {formData.colors.length > 0 && (
                                    <div className="preview-variant-group">
                                        <label>Colors:</label>
                                        <div className="dot-row">
                                            {formData.colors.map(c => (
                                                <span key={c} className="color-dot-small" style={{
                                                    backgroundColor:
                                                        c === 'Red' ? '#ef4444' : c === 'Blue' ? '#3b82f6' : c === 'Green' ? '#22c55e' :
                                                            c === 'Black' ? '#000000' : c === 'White' ? '#ffffff' : c === 'Orange' ? '#ff6b00' :
                                                                c === 'Silver' ? '#c0c0c0' : c === 'Gold' ? '#ffd700' : c === 'Pink' ? '#ec4899' :
                                                                    c === 'Purple' ? '#a855f7' : '#555'
                                                }}></span>
                                            ))}
                                        </div>
                                    </div>
                                )}
                                {formData.shoeSizes.length > 0 && (
                                    <div className="preview-variant-group">
                                        <label>Shoe Sizes:</label>
                                        <div className="pill-row">
                                            {formData.shoeSizes.map(s => <span key={s} className="size-pill-small">{s}</span>)}
                                        </div>
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>
                </div>

                {/* Right Column: Main Form */}
                <div className="larkon-main">
                    {/* Hero Upload Section */}
                    <div className="glass-card hero-upload-card">
                        <div className="card-header"><h4>Add Product Photo</h4></div>
                        <div className={`upload-zone ${isUploading ? 'uploading' : ''}`} onClick={() => document.getElementById('image-upload').click()}>
                            <input type="file" id="image-upload" multiple onChange={handleImageUpload} style={{ display: 'none' }} />
                            <div className="upload-content">
                                <div className="upload-icon-circle"><UploadCloud size={32} /></div>
                                <h3>Drop your images here, or <span>click to browse</span></h3>
                                <p>1600 x 1200 (4:3) recommended. PNG, JPG and GIF files are allowed</p>
                            </div>
                            {isUploading && <div className="upload-overlay"><div className="loader-spinner"></div></div>}
                        </div>
                        {images.length > 0 && (
                            <div className="images-grid-mini">
                                {images.map((img, i) => (
                                    <div key={i} className="mini-img-item" title="Click to remove" onClick={() => removeImage(i)}>
                                        <img src={getImageUrl(img)} alt={`Upload ${i}`} />
                                        <div className="img-remove-overlay"><X size={14} /></div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>

                    {/* Product Information Form */}
                    <div className="glass-card info-card-larkon">
                        <div className="card-header"><h4>Product Information</h4></div>
                        <div className="larkon-grid">
                            <div className="input-field col-8">
                                <label>Product Name</label>
                                <input type="text" name="name" value={formData.name} onChange={handleInputChange} placeholder="Enter product name" required />
                            </div>
                            <div className="input-field col-4">
                                <label>Product Category</label>
                                <select name="category" value={formData.category} onChange={handleInputChange} required>
                                    <option value="">Select Category</option>
                                    {categories.map(c => <option key={c._id} value={c._id}>{c.name}</option>)}
                                </select>
                            </div>

                            <div className="input-field col-4">
                                <label>Brand</label>
                                <input type="text" name="brand" value={formData.brand} onChange={handleInputChange} placeholder="Brand Name" />
                            </div>
                            <div className="input-field col-4">
                                <label>Weight</label>
                                <input type="text" name="weight" value={formData.weight} onChange={handleInputChange} placeholder="800gm" />
                            </div>
                            <div className="input-field col-4">
                                <label>Gender</label>
                                <select name="gender" value={formData.gender} onChange={handleInputChange}>
                                    <option value="N/A">N/A</option>
                                    <option value="Men">Men</option>
                                    <option value="Women">Women</option>
                                    <option value="Unisex">Unisex</option>
                                    <option value="Kids">Kids</option>
                                </select>
                            </div>

                            <div className="variant-section col-6">
                                <label>Sizes (Optional)</label>
                                <div className="size-selector-larkon">
                                    {['XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'].map(s => (
                                        <button key={s} type="button" onClick={() => toggleSize(s)} className={`size-pill-larkon ${formData.sizes.includes(s) ? 'active' : ''}`}>{s}</button>
                                    ))}
                                </div>
                            </div>
                            <div className="variant-section col-6">
                                <label>Colors (Optional)</label>
                                <div className="color-selector-larkon">
                                    {[
                                        { name: 'Red', hex: '#ef4444' }, { name: 'Blue', hex: '#3b82f6' },
                                        { name: 'Green', hex: '#22c55e' }, { name: 'Black', hex: '#000000' },
                                        { name: 'White', hex: '#ffffff' }, { name: 'Orange', hex: '#ff6b00' },
                                        { name: 'Silver', hex: '#c0c0c0' }, { name: 'Gold', hex: '#ffd700' },
                                        { name: 'Pink', hex: '#ec4899' }, { name: 'Purple', hex: '#a855f7' }
                                    ].map(c => (
                                        <button key={c.name} type="button" onClick={() => toggleColor(c.name)} className={`color-dot-larkon ${formData.colors.includes(c.name) ? 'active' : ''}`} style={{ backgroundColor: c.hex }} title={c.name}></button>
                                    ))}
                                </div>
                            </div>

                            <div className="variant-section col-12">
                                <label>Shoe Sizes (Optional)</label>
                                <div className="size-selector-larkon">
                                    {AVAILABLE_SHOE_SIZES.map(s => (
                                        <button key={s} type="button" onClick={() => toggleShoeSize(s)} className={`size-pill-larkon ${formData.shoeSizes.includes(s) ? 'active' : ''}`}>{s}</button>
                                    ))}
                                </div>
                            </div>

                            <div className="input-field col-12">
                                <label>Description (Required)</label>
                                <textarea name="description" value={formData.description} onChange={handleInputChange} placeholder="Type description..." rows="5" required></textarea>
                            </div>

                            <div className="input-field col-4">
                                <label>Tag Number</label>
                                <input type="text" name="sku" value={formData.sku} onChange={handleInputChange} placeholder="SKU-XXXXXX" />
                            </div>
                            <div className="input-field col-4">
                                <label>Stock</label>
                                <input type="number" name="countInStock" value={formData.countInStock} onChange={handleInputChange} placeholder="0" />
                            </div>
                            <div className="input-field col-4">
                                <label>Status</label>
                                <select name="status" value={formData.status} onChange={handleInputChange}>
                                    <option value="Draft">Draft</option>
                                    <option value="Published">Published</option>
                                    <option value="Private">Private</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    {/* Pricing Details Form */}
                    <div className="glass-card pricing-card-larkon">
                        <div className="card-header"><h4>Pricing Details</h4></div>
                        <div className="larkon-grid">
                            <div className="input-field col-4">
                                <label>Price</label>
                                <input type="number" name="price" value={formData.price} onChange={handleInputChange} placeholder="0.00" required />
                            </div>
                            <div className="input-field col-4">
                                <label>Discount (%)</label>
                                <input type="number" name="discount" value={formData.discount} onChange={handleInputChange} placeholder="0" min="0" max="100" />
                            </div>
                            <div className="input-field col-4">
                                <label>Tax (%)</label>
                                <input type="number" name="tax" value={formData.tax} onChange={handleInputChange} placeholder="0" />
                            </div>
                        </div>
                    </div>

                    <div className="larkon-form-actions">
                        <button type="button" onClick={() => navigate('/products')} className="larkon-btn btn-outline">Cancel</button>
                        <button type="submit" disabled={submitting} className="larkon-btn btn-primary">
                            {submitting ? 'Creating...' : 'Create Product'}
                        </button>
                    </div>
                </div>
            </form>

            <style>{`
                .create-product-larkon { padding: 30px; background: var(--background); min-height: 100vh; color: var(--text-primary); font-family: 'Inter', sans-serif; }
                
                .page-header-larkon { margin-bottom: 30px; }
                .header-left { display: flex; align-items: center; gap: 15px; }
                .header-left h1 { font-size: 20px; font-weight: 700; }
                .back-btn { background: var(--surface); border: 1px solid var(--divider); color: var(--text-primary); padding: 8px; border-radius: 8px; cursor: pointer; transition: var(--transition); }
                .back-btn:hover { background: var(--primary); border-color: var(--primary); box-shadow: 0 4px 12px var(--primary-glow); }

                .larkon-content { display: grid; grid-template-columns: 320px 1fr; gap: 24px; align-items: start; }
                
                .glass-card { background: var(--surface); border: 1px solid var(--divider); border-radius: var(--radius-md); padding: 24px; overflow: hidden; }
                .card-header { margin-bottom: 20px; padding-bottom: 12px; border-bottom: 1px solid var(--divider); }
                .card-header h4 { font-size: 15px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-primary); }

                .preview-hero { padding: 0; }
                .preview-img-container { width: 100%; height: 320px; background: #000; display: flex; align-items: center; justify-content: center; overflow: hidden; position: relative; }
                .preview-img-container img { width: 100%; height: 100%; object-fit: cover; }
                .img-placeholder { color: var(--text-secondary); display: flex; flex-direction: column; align-items: center; gap: 10px; }
                
                .preview-details { padding: 20px; }
                .preview-details h3 { font-size: 18px; margin-bottom: 10px; }
                .preview-details h3 small { color: var(--primary); font-size: 13px; display: block; margin-top: 4px; }
                .preview-price { margin-bottom: 20px; display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
                .price-label { font-size: 13px; color: var(--text-secondary); }
                .old-price { text-decoration: line-through; color: var(--text-secondary); }
                .new-price { font-size: 18px; font-weight: 700; color: var(--text-primary); }
                .discount-tag { background: rgba(239, 68, 68, 0.15); color: #ef4444; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 700; }

                .preview-variants { display: flex; flex-direction: column; gap: 15px; }
                .preview-variant-group label { display: block; font-size: 12px; color: var(--text-secondary); margin-bottom: 8px; }
                .size-pill-small { background: var(--surface-light); padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 600; margin-right: 5px; margin-bottom: 5px; display: inline-block; }
                .dot-row { display: flex; gap: 6px; flex-wrap: wrap; }
                .color-dot-small { width: 14px; height: 14px; border-radius: 50%; border: 1px solid rgba(255,255,255,0.1); }

                .upload-zone { 
                    border: 2px dashed var(--divider); border-radius: var(--radius-md); padding: 40px; text-align: center; cursor: pointer;
                    transition: var(--transition); position: relative;
                }
                .upload-zone:hover { border-color: var(--primary); background: rgba(255,107,0,0.05); }
                .upload-icon-circle { width: 64px; height: 64px; background: rgba(255,107,0,0.1); color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; }
                .upload-content h3 { font-size: 16px; margin-bottom: 8px; color: var(--text-primary); }
                .upload-content h3 span { color: var(--primary); font-weight: 700; }
                .upload-content p { font-size: 13px; color: var(--text-secondary); }

                .images-grid-mini { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 20px; }
                .mini-img-item { width: 60px; height: 60px; border-radius: 8px; overflow: hidden; position: relative; border: 1px solid var(--divider); cursor: pointer; }
                .mini-img-item img { width: 100%; height: 100%; object-fit: cover; }
                .img-remove-overlay { position: absolute; inset: 0; background: rgba(239, 68, 68, 0.8); display: flex; align-items: center; justify-content: center; opacity: 0; transition: 0.2s; }
                .mini-img-item:hover .img-remove-overlay { opacity: 1; }

                .larkon-grid { display: grid; grid-template-columns: repeat(12, 1fr); gap: 20px; }
                .col-12 { grid-column: span 12; }
                .col-8 { grid-column: span 8; }
                .col-6 { grid-column: span 6; }
                .col-4 { grid-column: span 4; }

                .input-field label { display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px; }
                .input-field input, .input-field select, .input-field textarea { 
                    width: 100%; background: var(--surface-light); border: 1px solid transparent; border-radius: 8px; 
                    padding: 12px 16px; color: var(--text-primary); font-size: 14px; transition: var(--transition);
                }
                .input-field input:focus, .input-field select:focus, .input-field textarea:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-glow); outline: none; }

                .variant-section label { display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 12px; }
                .size-selector-larkon, .color-selector-larkon { display: flex; flex-wrap: wrap; gap: 8px; }
                
                .size-pill-larkon { 
                    padding: 8px 14px; border-radius: 6px; background: var(--surface-light); border: 1px solid transparent;
                    color: var(--text-secondary); font-size: 12px; font-weight: 600; cursor: pointer; transition: 0.2s;
                }
                .size-pill-larkon.active { background: var(--text-primary); color: var(--background); }
                .size-pill-larkon:hover:not(.active) { border-color: var(--primary); color: var(--text-primary); }

                .color-dot-larkon { 
                    width: 24px; height: 24px; border-radius: 50%; border: 2px solid transparent; cursor: pointer; transition: 0.2s;
                }
                .color-dot-larkon.active { border-color: var(--primary); transform: scale(1.15); box-shadow: 0 0 8px var(--primary-glow); }

                .pricing-card-larkon { margin-top: 24px; }
                
                .larkon-form-actions { margin-top: 30px; display: flex; justify-content: flex-end; gap: 12px; }
                .larkon-btn { padding: 12px 30px; border-radius: 8px; font-size: 14px; font-weight: 700; cursor: pointer; transition: var(--transition); border: none; }
                .btn-outline { background: transparent; border: 1px solid var(--divider); color: var(--text-secondary); }
                .btn-outline:hover { background: var(--surface-light); color: var(--text-primary); }
                .btn-primary { background: var(--primary); border: 1px solid var(--primary); color: white; }
                .btn-primary:hover { filter: brightness(1.1); box-shadow: 0 6px 16px var(--primary-glow); transform: translateY(-2px); }

                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }
                
                @keyframes popIn {
                    from { opacity: 0; transform: scale(0.9); }
                    to { opacity: 1; transform: scale(1); }
                }
                .glass-card { animation: popIn 0.4s ease-out backwards; }
            `}</style>
        </div>
    );
};

export default ProductCreatePage;
