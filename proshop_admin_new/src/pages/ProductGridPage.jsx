import React, { useState, useEffect } from 'react';
import { productsAPI, categoriesAPI, getImageUrl } from '../services/api';
import { Search, Filter, Plus, Star, ChevronRight, Download } from 'lucide-react';
import { Link } from 'react-router-dom';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

const ProductGridPage = () => {
    const [products, setProducts] = useState([]);
    const [filteredProducts, setFilteredProducts] = useState([]);
    const [categories, setCategories] = useState([]);
    const [loading, setLoading] = useState(true);

    // Filter states
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedCategories, setSelectedCategories] = useState([]);
    const [priceBracket, setPriceBracket] = useState('all');
    const [minPrice, setMinPrice] = useState('');
    const [maxPrice, setMaxPrice] = useState('');

    const generatePDF = () => {
        const doc = new jsPDF();
        doc.setFontSize(18);
        doc.setTextColor(255, 107, 0);
        doc.text('Product Catalog Report (Grid)', 14, 20);

        doc.setFontSize(10);
        doc.setTextColor(100);
        doc.text(`Generated on: ${new Date().toLocaleString()}`, 14, 28);
        doc.text(`Total Products: ${filteredProducts.length}`, 14, 33);

        const tableColumn = ["Product Name", "Price", "Rating", "Stock"];
        const tableRows = filteredProducts.map(p => [
            p.name,
            `$${p.price}`,
            `${p.rating || 0} Stars`,
            p.countInStock > 0 ? `${p.countInStock} In Stock` : 'Out of Stock'
        ]);

        autoTable(doc, {
            startY: 40,
            head: [tableColumn],
            body: tableRows,
            theme: 'striped',
            headStyles: { fillColor: [255, 107, 0], textColor: [255, 255, 255] },
            styles: { fontSize: 9 }
        });

        doc.save(`products-grid-${new Date().getTime()}.pdf`);
    };

    useEffect(() => {
        const fetchData = async () => {
            try {
                const [productRes, catRes] = await Promise.all([
                    productsAPI.getAll(),
                    categoriesAPI.getAll()
                ]);
                const prods = productRes.data.data.products;
                setProducts(prods);
                setFilteredProducts(prods);
                setCategories(catRes.data.data.categories);
            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };
        fetchData();
    }, []);

    useEffect(() => {
        let result = products;

        // Search filter
        if (searchQuery) {
            result = result.filter(p => p.name.toLowerCase().includes(searchQuery.toLowerCase()));
        }

        // Category filter
        if (selectedCategories.length > 0) {
            result = result.filter(p => selectedCategories.includes(p.category?._id || p.category));
        }

        // Price bracket filter
        if (priceBracket !== 'all') {
            if (priceBracket === 'below-200') result = result.filter(p => p.price < 200);
            else if (priceBracket === '200-500') result = result.filter(p => p.price >= 200 && p.price <= 500);
            else if (priceBracket === '500-800') result = result.filter(p => p.price >= 500 && p.price <= 800);
            else if (priceBracket === '800-1000') result = result.filter(p => p.price >= 800 && p.price <= 1000);
            else if (priceBracket === 'above-1000') result = result.filter(p => p.price > 1000);
        }

        // Custom price range
        const min = parseFloat(minPrice);
        const max = parseFloat(maxPrice);
        if (!isNaN(min)) result = result.filter(p => p.price >= min);
        if (!isNaN(max)) result = result.filter(p => p.price <= max);

        setFilteredProducts(result);
    }, [searchQuery, selectedCategories, priceBracket, minPrice, maxPrice, products]);

    const handleCategoryToggle = (id) => {
        setSelectedCategories(prev =>
            prev.includes(id) ? prev.filter(c => c !== id) : [...prev, id]
        );
    };

    if (loading) return <div className="loading-state">Loading products...</div>;

    return (
        <div className="product-grid-page fade-in">
            <div className="grid-header">
                <div className="header-left">
                    <h1 className="cool-title">PRODUCT GRID <span className="title-accent">⊞</span></h1>
                    <div className="breadcrumb">
                        <span>Categories</span> <ChevronRight size={14} /> <span>All Product</span>
                    </div>
                </div>
                <div className="header-actions">
                    <button className="larkon-btn btn-primary" onClick={generatePDF}>
                        <Download size={18} /> Export PDF
                    </button>
                    <Link to="/products/create" className="btn-primary btn-cool">
                        <Plus size={18} strokeWidth={3} /> <span>New Product</span>
                    </Link>
                </div>
            </div>

            <div className="grid-layout">
                {/* Sidebar Filters */}
                <aside className="filters-sidebar glass-card">
                    <div className="filter-group">
                        <div className="filter-title">Categories</div>
                        <div className="filter-list">
                            <label className="filter-item">
                                <input
                                    type="checkbox"
                                    checked={selectedCategories.length === 0}
                                    onChange={() => setSelectedCategories([])}
                                />
                                <span>All Categories</span>
                            </label>
                            {categories.map((cat) => (
                                <label key={cat._id} className="filter-item">
                                    <input
                                        type="checkbox"
                                        checked={selectedCategories.includes(cat._id)}
                                        onChange={() => handleCategoryToggle(cat._id)}
                                    />
                                    <span>{cat.name}</span>
                                </label>
                            ))}
                        </div>
                    </div>

                    <div className="filter-group">
                        <div className="filter-title">Product Price</div>
                        <div className="filter-list">
                            {[
                                { id: 'all', label: 'All Price' },
                                { id: 'below-200', label: 'Below $200' },
                                { id: '200-500', label: '$200 - $500' },
                                { id: '500-800', label: '$500 - $800' },
                                { id: '800-1000', label: '$800 - $1000' },
                                { id: 'above-1000', label: 'Above $1000' }
                            ].map((bracket) => (
                                <label key={bracket.id} className="filter-item">
                                    <input
                                        type="radio"
                                        name="price"
                                        checked={priceBracket === bracket.id}
                                        onChange={() => setPriceBracket(bracket.id)}
                                    />
                                    <span>{bracket.label}</span>
                                </label>
                            ))}
                        </div>
                        <div className="price-range">
                            <span>Custom Price Range:</span>
                            <div className="range-inputs">
                                <input
                                    className="range-input-field"
                                    type="number"
                                    placeholder="Min"
                                    value={minPrice}
                                    onChange={(e) => setMinPrice(e.target.value)}
                                />
                                <span>to</span>
                                <input
                                    className="range-input-field"
                                    type="number"
                                    placeholder="Max"
                                    value={maxPrice}
                                    onChange={(e) => setMaxPrice(e.target.value)}
                                />
                            </div>
                        </div>
                    </div>

                </aside>

                {/* Main Content */}
                <main className="grid-content">
                    <div className="search-bar-row">
                        <div className="search-box glass-card">
                            <Search size={18} />
                            <input
                                type="text"
                                placeholder="Search products..."
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                            />
                        </div>
                        <div className="results-count">Showing {filteredProducts.length} items results</div>
                    </div>

                    <div className="products-grid">
                        {filteredProducts.map((product) => (
                            <Link key={product._id} to={`/products/details/${product._id}`} className="product-card glass-card">
                                <div className="card-image">
                                    <img src={getImageUrl(product.images[0])} alt={product.name} />
                                </div>
                                <div className="card-body">
                                    <h3 className="p-title">{product.name}</h3>
                                    <div className="p-rating">
                                        {[...Array(5)].map((_, i) => (
                                            <Star key={i} size={14} fill={i < Math.floor(product.rating || 0) ? "#ffb400" : "none"} color="#ffb400" />
                                        ))}
                                        <span>{product.rating || 0}</span>
                                    </div>
                                    <div className="p-price">
                                        {product.discount > 0 ? (
                                            <>
                                                <span className="current-price">${(product.price * (1 - product.discount / 100)).toFixed(2)}</span>
                                                <span className="old-price" style={{ textDecoration: 'lineThrough', color: '#888', fontSize: '12px' }}>${product.price}</span>
                                            </>
                                        ) : (
                                            <span className="current-price">${product.price.toFixed(2)}</span>
                                        )}
                                    </div>
                                    <div className="p-stock">
                                        <span className={`stock-badge ${product.countInStock > 0 ? 'in-stock' : 'out-of-stock'}`}>
                                            {product.countInStock > 0 ? `${product.countInStock} In Stock` : 'Out of Stock'}
                                        </span>
                                    </div>
                                </div>
                            </Link>
                        ))}
                    </div>
                </main>
            </div>

            <style>{`
                .product-grid-page { padding: 0; }
                .grid-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
                .grid-header h1.cool-title { font-size: 16px; font-weight: 800; color: var(--text-primary); margin-bottom: 4px; letter-spacing: 1px; display: flex; align-items: center; gap: 8px; text-transform: uppercase; }
                .title-accent { color: var(--primary); filter: drop-shadow(0 0 8px var(--primary-glow)); font-size: 18px; line-height: 1; }
                .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-muted); }
                .header-actions { display: flex; gap: 12px; align-items: center; }

                .grid-layout { display: grid; grid-template-columns: 280px 1fr; gap: 24px; }
                
                .filters-sidebar { padding: 24px; height: fit-content; position: sticky; top: 94px; }
                .filter-group { margin-bottom: 30px; }
                .filter-title { font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid var(--divider); }
                .filter-list { display: flex; flex-direction: column; gap: 12px; }
                .filter-item { display: flex; align-items: center; gap: 10px; cursor: pointer; color: var(--text-secondary); font-size: 13px; }
                .filter-item input { accent-color: var(--primary); }
                
                .price-range { margin-top: 20px; }
                .price-range span { font-size: 12px; color: var(--text-muted); display: block; margin-bottom: 12px; }
                .range-slider { position: relative; height: 4px; margin-bottom: 24px; }
                .slider-track { position: absolute; width: 100%; height: 100%; background: var(--surface-light); border-radius: 2px; }
                .slider-thumb { position: absolute; width: 14px; height: 14px; background: var(--primary); border-radius: 50%; top: -5px; border: 2px solid white; cursor: pointer; }
                .range-inputs { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
                .range-input-field { width: 100%; height: 36px; background: var(--surface-light); border-radius: 6px; font-size: 13px; color: var(--text-primary); border: 1px solid var(--divider); padding: 0 10px; outline: none; transition: var(--transition); }
                .range-input-field:focus { border-color: var(--primary); }
                .range-input-field::-webkit-inner-spin-button, .range-input-field::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; }
                
                .grid-content { display: flex; flex-direction: column; gap: 24px; }
                .search-bar-row { display: flex; align-items: center; justify-content: space-between; }
                .search-box { display: flex; align-items: center; gap: 12px; padding: 0 16px; height: 44px; width: 350px; background: var(--surface); }
                .search-box input { background: transparent; border: none; outline: none; color: var(--text-primary); width: 100%; font-size: 14px; }
                .results-count { font-size: 13px; color: var(--text-muted); }
                
                .products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(230px, 1fr)); gap: 24px; }
                .product-card { overflow: hidden; transition: var(--transition); text-decoration: none; display: flex; flex-direction: column; }
                .product-card:hover { transform: translateY(-5px); }
                .card-image { position: relative; aspect-ratio: 4/5; background: var(--surface-light); display: flex; align-items: center; justify-content: center; padding: 20px; }
                .card-image img { max-width: 100%; max-height: 100%; object-fit: contain; }
                
                .card-body { padding: 16px; flex: 1; display: flex; flex-direction: column; }
                .p-title { font-size: 14px; font-weight: 600; color: var(--text-primary); margin-bottom: 8px; line-height: 1.4; height: 40px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
                .p-rating { display: flex; align-items: center; gap: 6px; margin-bottom: 12px; font-size: 11px; color: var(--text-muted); }
                .p-price { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
                .current-price { font-size: 16px; font-weight: 700; color: var(--text-primary); }
                
                .p-stock { margin-top: auto; }
                .stock-badge { font-size: 10px; font-weight: 700; padding: 4px 8px; border-radius: 4px; text-transform: uppercase; }
                .stock-badge.in-stock { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
                .stock-badge.out-of-stock { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

                .btn-cool { position: relative; overflow: hidden; }
                .btn-cool span { position: relative; z-index: 1; }
                .btn-cool::after { content: ''; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%; background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent); transform: rotate(45deg); transition: 0.5s; left: -100%; }
                .btn-cool:hover::after { left: 100%; }

                .loading-state { height: 60vh; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 18px; }
            `}</style>
        </div>
    );
};

export default ProductGridPage;
