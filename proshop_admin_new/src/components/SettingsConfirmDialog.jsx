import React from 'react';
import { AlertTriangle, X, CheckCircle } from 'lucide-react';

const SettingsConfirmDialog = ({ isOpen, onClose, onConfirm, settings }) => {
    if (!isOpen) return null;

    return (
        <>
            <div className="modal-overlay" onClick={onClose}>
                <div className="settings-modal" onClick={(e) => e.stopPropagation()}>
                    <button className="close-btn" onClick={onClose}>
                        <X size={20} />
                    </button>

                    <div className="modal-icon">
                        <AlertTriangle size={48} />
                    </div>

                    <h2>Confirm Settings Update</h2>
                    <p className="modal-subtitle">Review your changes before applying them</p>

                    <div className="settings-preview">
                        <div className="preview-item">
                            <span className="label">Tax Rate</span>
                            <span className="value">{(settings.taxRate * 100).toFixed(2)}%</span>
                        </div>
                        <div className="preview-item">
                            <span className="label">Shipping Fee</span>
                            <span className="value">${Number(settings.shippingFee).toFixed(2)}</span>
                        </div>
                        <div className="preview-item">
                            <span className="label">Global Discount</span>
                            <span className="value">{settings.globalDiscount}%</span>
                        </div>
                    </div>

                    <div className="warning-box">
                        <CheckCircle size={16} />
                        <span>These changes will affect all future orders</span>
                    </div>

                    <div className="modal-actions">
                        <button className="btn-cancel" onClick={onClose}>
                            Cancel
                        </button>
                        <button className="btn-confirm" onClick={onConfirm}>
                            <CheckCircle size={18} />
                            Apply Changes
                        </button>
                    </div>
                </div>
            </div>

            <style>{`
                .modal-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: rgba(0, 0, 0, 0.7);
                    backdrop-filter: blur(8px);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 10000;
                    animation: fadeIn 0.2s ease;
                }

                @keyframes fadeIn {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }

                .settings-modal {
                    background: linear-gradient(135deg, rgba(30, 30, 40, 0.95), rgba(20, 20, 30, 0.98));
                    border: 1px solid rgba(255, 107, 0, 0.3);
                    border-radius: 20px;
                    padding: 32px;
                    width: 90%;
                    max-width: 480px;
                    position: relative;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5),
                                0 0 40px rgba(255, 107, 0, 0.1);
                    animation: slideUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                }

                @keyframes slideUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px) scale(0.95);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0) scale(1);
                    }
                }

                .close-btn {
                    position: absolute;
                    top: 16px;
                    right: 16px;
                    background: rgba(255, 255, 255, 0.1);
                    border: none;
                    border-radius: 8px;
                    width: 32px;
                    height: 32px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    color: #888;
                    transition: all 0.2s;
                }

                .close-btn:hover {
                    background: rgba(255, 255, 255, 0.15);
                    color: white;
                }

                .modal-icon {
                    width: 80px;
                    height: 80px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, rgba(255, 107, 0, 0.2), rgba(255, 150, 50, 0.1));
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 24px;
                    color: #ff6b00;
                    animation: pulse 2s infinite;
                }

                @keyframes pulse {
                    0%, 100% { transform: scale(1); opacity: 1; }
                    50% { transform: scale(1.05); opacity: 0.8; }
                }

                .settings-modal h2 {
                    color: white;
                    font-size: 24px;
                    font-weight: 700;
                    margin: 0 0 8px;
                    text-align: center;
                }

                .modal-subtitle {
                    color: #999;
                    font-size: 14px;
                    text-align: center;
                    margin-bottom: 24px;
                }

                .settings-preview {
                    background: rgba(0, 0, 0, 0.3);
                    border: 1px solid rgba(255, 255, 255, 0.08);
                    border-radius: 12px;
                    padding: 20px;
                    margin-bottom: 20px;
                }

                .preview-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 12px 0;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
                }

                .preview-item:last-child {
                    border-bottom: none;
                }

                .preview-item .label {
                    color: #999;
                    font-size: 14px;
                }

                .preview-item .value {
                    color: #ff6b00;
                    font-size: 16px;
                    font-weight: 600;
                }

                .warning-box {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    background: rgba(76, 175, 80, 0.1);
                    border: 1px solid rgba(76, 175, 80, 0.3);
                    border-radius: 10px;
                    padding: 12px 16px;
                    margin-bottom: 24px;
                    color: #4caf50;
                    font-size: 13px;
                }

                .modal-actions {
                    display: flex;
                    gap: 12px;
                }

                .btn-cancel, .btn-confirm {
                    flex: 1;
                    padding: 12px 20px;
                    border-radius: 10px;
                    font-size: 15px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s;
                    border: none;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                }

                .btn-cancel {
                    background: rgba(255, 255, 255, 0.05);
                    color: #999;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                }

                .btn-cancel:hover {
                    background: rgba(255, 255, 255, 0.1);
                    color: white;
                }

                .btn-confirm {
                    background: linear-gradient(135deg, #ff6b00, #ff8800);
                    color: white;
                    box-shadow: 0 4px 15px rgba(255, 107, 0, 0.3);
                }

                .btn-confirm:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(255, 107, 0, 0.4);
                }
            `}</style>
        </>
    );
};

export default SettingsConfirmDialog;
