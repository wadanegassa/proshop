import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { productsAPI, categoriesAPI, uploadAPI } from '../services/api';
import {
    Save,
    X,
    Upload,
    Plus,
    Info,
    DollarSign,
    Package,
    Layers,
    Image as ImageIcon,
    UploadCloud
} from 'lucide-react';

const ProductEditPage = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const isEditMode = !!id;

    const [categories, setCategories] = useState([]);
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState({
        name: '',
        category: '',
        price: '',
        stock: '',
        description: '',
        images: [''], // Start with one empty string for URL input
        isActive: true
    });

    const [uploading, setUploading] = useState(false);

    useEffect(() => {
        const fetchData = async () => {
            try {
                // Fetch Categories
                const catRes = await categoriesAPI.getAll();
                const cats = catRes.data.categories || [];
                setCategories(cats);

                // If Edit Mode, Fetch Product
                if (isEditMode) {
                    const prodRes = await productsAPI.getOne(id);
                    const prod = prodRes.data.product;
                    setFormData({
                        name: prod.name,
                        category: prod.category?._id || prod.category, // Handle populated or raw ID
                        price: prod.price,
                        stock: prod.stock,
                        description: prod.description,
                        images: prod.images && prod.images.length > 0 ? prod.images : [''],
                        isActive: prod.isActive
                    });
                } else if (cats.length > 0) {
                    // Default to first category if creating
                    setFormData(prev => ({ ...prev, category: cats[0]._id }));
                }
            } catch (error) {
                console.error('Error fetching data:', error);
            }
        };
        fetchData();
    }, [id, isEditMode]);

    const handleChange = (e) => {
        const { name, value, type, checked } = e.target;
        setFormData(prev => ({
            ...prev,
            [name]: type === 'checkbox' ? checked : value
        }));
    };

    const handleImageChange = (index, value) => {
        const newImages = [...formData.images];
        newImages[index] = value;
        setFormData(prev => ({ ...prev, images: newImages }));
    };

    const addImageField = () => {
        setFormData(prev => ({ ...prev, images: [...prev.images, ''] }));
    };

    const removeImageField = (index) => {
        const newImages = formData.images.filter((_, i) => i !== index);
        setFormData(prev => ({ ...prev, images: newImages }));
    };

    const handleUploadFileHandler = async (e) => {
        const file = e.target.files[0];
        if (!file) return;

        const formData = new FormData();
        formData.append('image', file);
        setUploading(true);

        try {
            const config = {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            };

            const response = await uploadAPI.uploadImage(formData);

            // Should properly concat host depending on env, but for now:
            const imagePath = `http://localhost:5000${response.data.image}`;

            setFormData(prev => ({
                ...prev,
                images: [...prev.images, imagePath]
            }));

            setUploading(false);
        } catch (error) {
            console.error(error);
            setUploading(false);
            alert('Image upload failed');
        }
    };

    const handleSubmit = async () => {
        try {
            setLoading(true);
            const payload = {
                ...formData,
                price: Number(formData.price),
                stock: Number(formData.stock),
                images: formData.images.filter(img => img.trim() !== '') // Filter empty strings
            };

            if (isEditMode) {
                await productsAPI.update(id, payload);
            } else {
                await productsAPI.create(payload);
            }
            navigate('/products');
        } catch (error) {
            console.error('Error saving product:', error);
            alert('Failed to save product. Please check console for details.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div style={styles.container}>
            <header style={styles.header}>
                <div style={styles.headerLeft}>
                    <h1 style={styles.title}>{isEditMode ? 'Edit' : 'Add'} <span className="orange-text">Product</span></h1>
                    {isEditMode && <p style={styles.subtitle}>ID: #{id}</p>}
                </div>
                <div style={styles.headerActions}>
                    <button style={styles.cancelBtn} onClick={() => navigate('/products')}><X size={18} /> Cancel</button>
                    <button style={styles.saveBtn} onClick={handleSubmit} disabled={loading}>
                        <Save size={18} /> {loading ? 'Saving...' : 'Save Changes'}
                    </button>
                </div>
            </header>

            <div style={styles.mainGrid}>
                {/* Left Column: General Info */}
                <div style={styles.leftCol}>
                    {/* Basic Info Card */}
                    <div className="larkon-card" style={styles.formCard}>
                        <div style={styles.cardHeader}>
                            <Info size={18} color="var(--primary)" />
                            <h4 style={styles.cardTitle}>Basic Information</h4>
                        </div>
                        <div style={styles.formGrid}>
                            <div style={styles.inputGroupFull}>
                                <label style={styles.label}>Product Name</label>
                                <input
                                    type="text"
                                    name="name"
                                    value={formData.name}
                                    onChange={handleChange}
                                    style={styles.input}
                                />
                            </div>
                            <div style={styles.inputGroup}>
                                <label style={styles.label}>Category</label>
                                <select
                                    name="category"
                                    value={formData.category}
                                    onChange={handleChange}
                                    style={styles.select}
                                >
                                    <option value="">Select Category</option>
                                    {categories.map(cat => (
                                        <option key={cat._id} value={cat._id}>{cat.name}</option>
                                    ))}
                                </select>
                            </div>
                        </div>
                    </div>

                    {/* Description Card */}
                    <div className="larkon-card" style={styles.formCard}>
                        <div style={styles.cardHeader}>
                            <Layers size={18} color="var(--primary)" />
                            <h4 style={styles.cardTitle}>Description</h4>
                        </div>
                        <textarea
                            name="description"
                            value={formData.description}
                            onChange={handleChange}
                            style={styles.textarea}
                        ></textarea>
                    </div>

                    <div className="larkon-card" style={styles.formCard}>
                        <div style={styles.cardHeader}>
                            <Upload size={18} color="var(--primary)" />
                            <h4 style={styles.cardTitle}>Product Images</h4>
                        </div>
                        <div style={styles.imageStack}>
                            {formData.images.map((img, idx) => (
                                <div key={idx} style={styles.imageRow}>
                                    <ImageIcon size={18} color="var(--text-muted)" />
                                    <input
                                        type="text"
                                        value={img}
                                        onChange={(e) => handleImageChange(idx, e.target.value)}
                                        placeholder="https://example.com/image.jpg"
                                        style={styles.input}
                                    />
                                    <button onClick={() => removeImageField(idx)} style={styles.removeBtn}><X size={16} /></button>
                                </div>
                            ))}
                            <div style={styles.uploadActions}>
                                <button onClick={addImageField} style={styles.addImageBtn}><Plus size={16} /> Add URL</button>

                                <div style={styles.fileUploadWrapper}>
                                    <input
                                        type="file"
                                        id="image-file"
                                        onChange={handleUploadFileHandler}
                                        style={{ display: 'none' }}
                                    />
                                    <label htmlFor="image-file" style={styles.uploadBtnLabel}>
                                        <UploadCloud size={16} />
                                        {uploading ? 'Uploading...' : 'Upload Image'}
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Right Column: Pricing & Inventory */}
                <div style={styles.rightCol}>
                    {/* Pricing Card */}
                    <div className="larkon-card" style={styles.formCard}>
                        <div style={styles.cardHeader}>
                            <DollarSign size={18} color="var(--primary)" />
                            <h4 style={styles.cardTitle}>Pricing & Stock</h4>
                        </div>
                        <div style={styles.formGrid}>
                            <div style={styles.inputGroupFull}>
                                <label style={styles.label}>Price</label>
                                <div style={styles.priceInputWrapper}>
                                    <span style={styles.currency}>$</span>
                                    <input
                                        type="number"
                                        name="price"
                                        value={formData.price}
                                        onChange={handleChange}
                                        style={styles.priceInput}
                                    />
                                </div>
                            </div>
                            <div style={styles.inputGroupFull}>
                                <label style={styles.label}>In Stock Quantity</label>
                                <input
                                    type="number"
                                    name="stock"
                                    value={formData.stock}
                                    onChange={handleChange}
                                    style={styles.input}
                                />
                            </div>
                        </div>
                    </div>

                    {/* Visibility Card */}
                    <div className="larkon-card" style={styles.formCard}>
                        <div style={styles.cardHeader}>
                            <Package size={18} color="var(--primary)" />
                            <h4 style={styles.cardTitle}>Visibility</h4>
                        </div>
                        <div style={styles.radioGroup}>
                            <label style={styles.radioLabel}>
                                <input
                                    type="radio"
                                    name="isActive"
                                    checked={formData.isActive === true}
                                    onChange={() => setFormData(prev => ({ ...prev, isActive: true }))}
                                />
                                <span style={styles.radioText}>Public</span>
                            </label>
                            <label style={styles.radioLabel}>
                                <input
                                    type="radio"
                                    name="isActive"
                                    checked={formData.isActive === false}
                                    onChange={() => setFormData(prev => ({ ...prev, isActive: false }))}
                                />
                                <span style={styles.radioText}>Hidden</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

const styles = {
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
    subtitle: {
        fontSize: '12px',
        color: 'var(--text-muted)',
        fontWeight: '600',
        marginTop: '4px',
    },
    headerActions: {
        display: 'flex',
        gap: '12px',
    },
    saveBtn: {
        background: 'var(--primary)',
        color: 'black',
        padding: '10px 20px',
        borderRadius: '8px',
        fontSize: '14px',
        fontWeight: '700',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        cursor: 'pointer',
    },
    cancelBtn: {
        background: 'var(--surface-hover)',
        border: '1px solid var(--divider)',
        color: 'var(--text-primary)',
        padding: '10px 20px',
        borderRadius: '8px',
        fontSize: '14px',
        fontWeight: '700',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        cursor: 'pointer',
    },
    mainGrid: {
        display: 'grid',
        gridTemplateColumns: '1fr 340px',
        gap: '24px',
        alignItems: 'start',
    },
    leftCol: {
        display: 'flex',
        flexDirection: 'column',
        gap: '24px',
    },
    rightCol: {
        display: 'flex',
        flexDirection: 'column',
        gap: '24px',
    },
    formCard: {
        padding: '24px',
    },
    cardHeader: {
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
        marginBottom: '24px',
        paddingBottom: '16px',
        borderBottom: '1px solid var(--divider)',
    },
    cardTitle: {
        fontSize: '15px',
        fontWeight: '700',
    },
    formGrid: {
        display: 'grid',
        gridTemplateColumns: 'repeat(2, 1fr)',
        gap: '20px',
    },
    inputGroup: {
        display: 'flex',
        flexDirection: 'column',
        gap: '8px',
    },
    inputGroupFull: {
        gridColumn: 'span 2',
        display: 'flex',
        flexDirection: 'column',
        gap: '8px',
    },
    label: {
        fontSize: '13px',
        fontWeight: '600',
        color: 'var(--text-secondary)',
    },
    input: {
        width: '100%',
        background: 'var(--background)',
        border: '1px solid var(--divider)',
        borderRadius: '8px',
        padding: '12px 16px',
        color: 'var(--text-primary)',
        fontSize: '14px',
        outline: 'none',
    },
    select: {
        width: '100%',
        background: 'var(--background)',
        border: '1px solid var(--divider)',
        borderRadius: '8px',
        padding: '12px 16px',
        color: 'var(--text-primary)',
        fontSize: '14px',
        outline: 'none',
    },
    textarea: {
        width: '100%',
        minHeight: '150px',
        background: 'var(--background)',
        border: '1px solid var(--divider)',
        borderRadius: '8px',
        padding: '16px',
        color: 'var(--text-primary)',
        fontSize: '14px',
        outline: 'none',
        resize: 'vertical',
    },
    priceInputWrapper: {
        position: 'relative',
        display: 'flex',
        alignItems: 'center',
    },
    currency: {
        position: 'absolute',
        left: '16px',
        color: 'var(--text-muted)',
        fontSize: '14px',
        fontWeight: '700',
    },
    priceInput: {
        width: '100%',
        background: 'var(--background)',
        border: '1px solid var(--divider)',
        borderRadius: '8px',
        padding: '12px 16px 12px 34px',
        color: 'var(--text-primary)',
        fontSize: '14px',
        outline: 'none',
    },
    radioGroup: {
        display: 'flex',
        flexDirection: 'column',
        gap: '12px',
    },
    radioLabel: {
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
        cursor: 'pointer',
    },
    radioText: {
        fontSize: '14px',
        color: 'var(--text-secondary)',
        fontWeight: '500',
    },
    imageStack: {
        display: 'flex',
        flexDirection: 'column',
        gap: '12px',
    },
    imageRow: {
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
    },
    removeBtn: {
        background: 'var(--surface-hover)',
        border: '1px solid var(--divider)',
        borderRadius: '8px',
        width: '40px',
        height: '40px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        cursor: 'pointer',
        color: 'var(--error)',
    },
    addImageBtn: {
        background: 'transparent',
        border: '1px dashed var(--divider)',
        borderRadius: '8px',
        padding: '12px',
        color: 'var(--text-muted)',
        fontSize: '13px',
        fontWeight: '600',
        cursor: 'pointer',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: '8px',
        flex: 1
    },
    uploadActions: {
        display: 'flex',
        gap: '12px',
        marginTop: '8px'
    },
    fileUploadWrapper: {
        flex: 1
    },
    uploadBtnLabel: {
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: '8px',
        background: 'rgba(255, 108, 47, 0.1)',
        color: 'var(--primary)',
        border: '1px dashed var(--primary)',
        borderRadius: '8px',
        padding: '12px',
        fontSize: '13px',
        fontWeight: '600',
        cursor: 'pointer',
        width: '100%'
    }
};

export default ProductEditPage;
