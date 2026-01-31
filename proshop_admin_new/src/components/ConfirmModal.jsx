import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { AlertCircle, X } from 'lucide-react';

const ConfirmModal = ({ isOpen, onClose, onConfirm, title, message, confirmText = 'Delete', type = 'danger' }) => {
    if (!isOpen) return null;

    return (
        <AnimatePresence>
            <div className="modal-overlay">
                <motion.div
                    initial={{ opacity: 0, scale: 0.9, y: 20 }}
                    animate={{ opacity: 1, scale: 1, y: 0 }}
                    exit={{ opacity: 0, scale: 0.9, y: 20 }}
                    className="modal-card glass-card"
                >
                    <button className="modal-close" onClick={onClose}>
                        <X size={20} />
                    </button>

                    <div className="modal-icon-container">
                        <div className={`modal-icon ${type}`}>
                            <AlertCircle size={32} />
                        </div>
                    </div>

                    <div className="modal-content">
                        <h3>{title || 'Are you sure?'}</h3>
                        <p>{message || 'This action cannot be undone.'}</p>
                    </div>

                    <div className="modal-actions">
                        <button className="modal-btn cancel" onClick={onClose}>Cancel</button>
                        <button className={`modal-btn confirm ${type}`} onClick={() => {
                            onConfirm();
                            onClose();
                        }}>
                            {confirmText}
                        </button>
                    </div>
                </motion.div>

                <style>{`
                    .modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100vw;
                        height: 100vh;
                        background: rgba(0, 0, 0, 0.4);
                        backdrop-filter: blur(8px);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 9999;
                        padding: 20px;
                    }
                    .modal-card {
                        width: 100%;
                        max-width: 400px;
                        background: var(--surface);
                        border: 1px solid var(--divider);
                        border-radius: 20px;
                        padding: 32px;
                        position: relative;
                        text-align: center;
                        box-shadow: 0 20px 40px rgba(0,0,0,0.3);
                    }
                    .modal-close {
                        position: absolute;
                        top: 16px;
                        right: 16px;
                        background: transparent;
                        border: none;
                        color: var(--text-muted);
                        cursor: pointer;
                        transition: var(--transition);
                    }
                    .modal-close:hover {
                        color: var(--text-primary);
                        transform: rotate(90deg);
                    }
                    .modal-icon-container {
                        display: flex;
                        justify-content: center;
                        margin-bottom: 24px;
                    }
                    .modal-icon {
                        width: 64px;
                        height: 64px;
                        border-radius: 16px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }
                    .modal-icon.danger {
                        background: rgba(239, 68, 68, 0.1);
                        color: var(--error);
                    }
                    .modal-icon.warning {
                        background: rgba(245, 158, 11, 0.1);
                        color: #f59e0b;
                    }
                    .modal-content h3 {
                        font-size: 20px;
                        font-weight: 800;
                        color: var(--text-primary);
                        margin-bottom: 12px;
                    }
                    .modal-content p {
                        font-size: 14px;
                        color: var(--text-secondary);
                        line-height: 1.6;
                        margin-bottom: 30px;
                    }
                    .modal-actions {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 12px;
                    }
                    .modal-btn {
                        height: 44px;
                        border-radius: 10px;
                        font-size: 14px;
                        font-weight: 700;
                        cursor: pointer;
                        transition: var(--transition);
                        border: 1px solid transparent;
                    }
                    .modal-btn.cancel {
                        background: var(--surface-light);
                        color: var(--text-primary);
                        border-color: var(--divider);
                    }
                    .modal-btn.cancel:hover {
                        background: var(--divider);
                    }
                    .modal-btn.confirm.danger {
                        background: var(--error);
                        color: white;
                    }
                    .modal-btn.confirm.danger:hover {
                        background: #dc2626;
                        box-shadow: 0 8px 16px rgba(239, 68, 68, 0.4);
                    }
                `}</style>
            </div>
        </AnimatePresence>
    );
};

export default ConfirmModal;
