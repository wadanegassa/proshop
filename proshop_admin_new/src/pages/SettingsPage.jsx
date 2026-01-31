import React, { useState, useEffect } from 'react';
import { toast } from 'react-hot-toast';
import { settingsAPI } from '../services/api';
import { Save, Store, Mail, Phone, Percent, DollarSign, PenTool } from 'lucide-react';
import SettingsConfirmDialog from '../components/SettingsConfirmDialog';

const SettingsPage = () => {
    const [loading, setLoading] = useState(true);
    const [showConfirmDialog, setShowConfirmDialog] = useState(false);
    const [formData, setFormData] = useState({
        taxRate: 0,
        shippingFee: 0,
        globalDiscount: 0,
        supportEmail: '',
        supportPhone: ''
    });

    useEffect(() => {
        fetchSettings();
    }, []);

    const fetchSettings = async () => {
        try {
            const { data } = await settingsAPI.getSettings();
            if (data.success) {
                setFormData(data.data);
            } else {
                toast.error('Failed to load settings');
            }
        } catch (err) {
            toast.error('Error fetching settings');
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        setShowConfirmDialog(true);
    };

    const handleConfirmUpdate = async () => {
        setShowConfirmDialog(false);

        try {
            const { data } = await settingsAPI.updateSettings(formData);
            if (data.success) {
                toast.success('Settings updated successfully!');
                setFormData(data.data);
            } else {
                toast.error(data.message || 'Update failed');
            }
        } catch (err) {
            toast.error('Error updating settings');
            console.error(err);
        }
    };

    if (loading) return <div className="p-8 text-white flex justify-center">Loading settings...</div>;

    return (
        <div className="fade-in">
            <div className="page-header" style={{ marginBottom: '24px' }}>
                <h1 style={{ fontSize: '24px', fontWeight: 'bold', color: 'var(--text-primary)' }}>Global Settings</h1>
                <p style={{ color: 'var(--text-muted)', fontSize: '14px' }}>Manage tax rates, shipping fees, and global configurations.</p>
            </div>

            <div className="glass-card" style={{ maxWidth: '800px', padding: '32px' }}>
                <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '24px' }}>

                    {/* Financials Section */}
                    <div className="section">
                        <h3 className="section-title"><DollarSign size={18} /> Financials</h3>
                        <div className="grid-2">
                            <div className="form-group">
                                <label>Tax Rate (Decimal)</label>
                                <div className="input-with-icon">
                                    <Percent size={16} />
                                    <input
                                        type="number"
                                        step="0.01"
                                        name="taxRate"
                                        value={formData.taxRate}
                                        onChange={handleChange}
                                        placeholder="0.15"
                                    />
                                </div>
                                <span className="hint">Example: 0.15 for 15%</span>
                            </div>

                            <div className="form-group">
                                <label>Shipping Fee ($)</label>
                                <div className="input-with-icon">
                                    <DollarSign size={16} />
                                    <input
                                        type="number"
                                        step="0.01"
                                        name="shippingFee"
                                        value={formData.shippingFee}
                                        onChange={handleChange}
                                        placeholder="10.00"
                                    />
                                </div>
                            </div>

                            <div className="form-group">
                                <label>Global Discount (%)</label>
                                <div className="input-with-icon">
                                    <PenTool size={16} />
                                    <input
                                        type="number"
                                        step="0.01"
                                        name="globalDiscount"
                                        value={formData.globalDiscount}
                                        onChange={handleChange}
                                        placeholder="0"
                                    />
                                </div>
                                <span className="hint">Applied to all cart totals</span>
                            </div>
                        </div>
                    </div>

                    <div className="divider"></div>

                    {/* Support Section */}
                    <div className="section">
                        <h3 className="section-title"><Store size={18} /> Support Contact</h3>
                        <div className="grid-2">
                            <div className="form-group">
                                <label>Support Email</label>
                                <div className="input-with-icon">
                                    <Mail size={16} />
                                    <input
                                        type="email"
                                        name="supportEmail"
                                        value={formData.supportEmail}
                                        onChange={handleChange}
                                        placeholder="support@proshop.com"
                                    />
                                </div>
                            </div>

                            <div className="form-group">
                                <label>Support Phone</label>
                                <div className="input-with-icon">
                                    <Phone size={16} />
                                    <input
                                        type="text"
                                        name="supportPhone"
                                        value={formData.supportPhone}
                                        onChange={handleChange}
                                        placeholder="+1 234 567 890"
                                    />
                                </div>
                            </div>
                        </div>
                    </div>

                    <button
                        type="submit"
                        className="btn-primary"
                        style={{ alignSelf: 'flex-start', display: 'flex', alignItems: 'center', gap: '8px', padding: '12px 24px' }}
                    >
                        <Save size={18} /> Save Changes
                    </button>
                </form>
            </div>

            <style>{`
        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 20px;
        }
        .grid-2 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .form-group label {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-secondary);
        }
        .input-with-icon {
            display: flex;
            align-items: center;
            gap: 12px;
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid var(--divider);
            padding: 10px 14px;
            border-radius: 8px;
            color: var(--text-muted);
            transition: var(--transition);
        }
        .input-with-icon:focus-within {
            border-color: var(--primary);
            background: rgba(0, 0, 0, 0.3);
            color: var(--primary);
        }
        .input-with-icon input {
            background: transparent;
            border: none;
            outline: none;
            color: var(--text-primary);
            width: 100%;
            font-size: 14px;
        }
        .hint {
            font-size: 11px;
            color: var(--text-muted);
        }
        .divider {
            height: 1px;
            background: var(--divider);
            margin: 10px 0;
        }
        .btn-primary {
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }
        .btn-primary:hover {
            box-shadow: 0 4px 12px var(--primary-glow);
        }
            `}</style>

            <SettingsConfirmDialog
                isOpen={showConfirmDialog}
                onClose={() => setShowConfirmDialog(false)}
                onConfirm={handleConfirmUpdate}
                settings={formData}
            />
        </div>
    );
};

export default SettingsPage;
