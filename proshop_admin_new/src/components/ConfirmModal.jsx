import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { AlertTriangle, X, Trash2 } from 'lucide-react';

const ConfirmModal = ({ isOpen, onClose, onConfirm, title, message, confirmText = 'Delete', type = 'danger' }) => {
    if (!isOpen) return null;

    return (
        <AnimatePresence>
            <motion.div
                className="modal-overlay"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                onClick={onClose}
            >
                <motion.div
                    initial={{ opacity: 0, scale: 0.8, y: 50 }}
                    animate={{ opacity: 1, scale: 1, y: 0 }}
                    exit={{ opacity: 0, scale: 0.8, y: 50 }}
                    transition={{ type: "spring", duration: 0.5, bounce: 0.3 }}
                    className="modal-card glass-card"
                    onClick={(e) => e.stopPropagation()}
                >
                    <button className="modal-close" onClick={onClose}>
                        <X size={20} />
                    </button>

                    <div className="modal-icon-container">
                        <motion.div
                            className={`modal-icon ${type}`}
                            animate={{
                                scale: [1, 1.1, 1],
                            }}
                            transition={{
                                duration: 2,
                                repeat: Infinity,
                                ease: "easeInOut"
                            }}
                        >
                            {type === 'danger' ? <Trash2 size={36} /> : <AlertTriangle size={36} />}
                        </motion.div>
                    </div>

                    <div className="modal-content">
                        <h3>{title || 'Are you sure?'}</h3>
                        <p>{message || 'This action cannot be undone.'}</p>
                    </div>

                    <div className="modal-actions">
                        <motion.button
                            className="modal-btn cancel"
                            onClick={onClose}
                            whileHover={{ scale: 1.02 }}
                            whileTap={{ scale: 0.98 }}
                        >
                            Cancel
                        </motion.button>
                        <motion.button
                            className={`modal-btn confirm ${type}`}
                            onClick={() => {
                                onConfirm();
                                onClose();
                            }}
                            whileHover={{ scale: 1.02 }}
                            whileTap={{ scale: 0.98 }}
                        >
                            <Trash2 size={18} />
                            {confirmText}
                        </motion.button>
                    </div>
                </motion.div>

                <style>{`
                    .modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100vw;
                        height: 100vh;
                        background: rgba(0, 0, 0, 0.75);
                        backdrop-filter: blur(10px);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 10000;
                        padding: 20px;
                    }
                    
                    .modal-card {
                        width: 100%;
                        max-width: 440px;
                        background: linear-gradient(135deg, rgba(30, 30, 40, 0.98), rgba(20, 20, 30, 0.98));
                        border: 1px solid rgba(239, 68, 68, 0.3);
                        border-radius: 24px;
                        padding: 40px;
                        position: relative;
                        text-align: center;
                        box-shadow: 
                            0 25px 50px rgba(0, 0, 0, 0.5),
                            0 0 60px rgba(239, 68, 68, 0.15),
                            inset 0 1px 0 rgba(255, 255, 255, 0.05);
                    }
                    
                    .modal-close {
                        position: absolute;
                        top: 20px;
                        right: 20px;
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid rgba(255, 255, 255, 0.1);
                        border-radius: 10px;
                        width: 36px;
                        height: 36px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #999;
                        cursor: pointer;
                        transition: all 0.2s;
                    }
                    
                    .modal-close:hover {
                        background: rgba(255, 255, 255, 0.1);
                        color: white;
                        transform: rotate(90deg);
                    }
                    
                    .modal-icon-container {
                        display: flex;
                        justify-content: center;
                        margin-bottom: 28px;
                    }
                    
                    .modal-icon {
                        width: 88px;
                        height: 88px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        position: relative;
                    }
                    
                    .modal-icon::before {
                        content: '';
                        position: absolute;
                        inset: -4px;
                        border-radius: 50%;
                        padding: 4px;
                        background: linear-gradient(135deg, rgba(239, 68, 68, 0.4), rgba(220, 38, 38, 0.2));
                        -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
                        -webkit-mask-composite: xor;
                        mask-composite: exclude;
                        opacity: 0.6;
                    }
                    
                    .modal-icon.danger {
                        background: linear-gradient(135deg, rgba(239, 68, 68, 0.2), rgba(220, 38, 38, 0.1));
                        color: #ef4444;
                        box-shadow: 0 0 30px rgba(239, 68, 68, 0.3);
                    }
                    
                    .modal-icon.warning {
                        background: linear-gradient(135deg, rgba(245, 158, 11, 0.2), rgba(217, 119, 6, 0.1));
                        color: #f59e0b;
                        box-shadow: 0 0 30px rgba(245, 158, 11, 0.3);
                    }
                    
                    .modal-content h3 {
                        font-size: 24px;
                        font-weight: 700;
                        color: white;
                        margin-bottom: 12px;
                        letter-spacing: -0.5px;
                    }
                    
                    .modal-content p {
                        font-size: 15px;
                        color: rgba(255, 255, 255, 0.6);
                        line-height: 1.6;
                        margin-bottom: 32px;
                    }
                    
                    .modal-actions {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 12px;
                    }
                    
                    .modal-btn {
                        height: 48px;
                        border-radius: 12px;
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
                    
                    .modal-btn.cancel {
                        background: rgba(255, 255, 255, 0.05);
                        color: rgba(255, 255, 255, 0.7);
                        border: 1px solid rgba(255, 255, 255, 0.1);
                    }
                    
                    .modal-btn.cancel:hover {
                        background: rgba(255, 255, 255, 0.1);
                        color: white;
                        border-color: rgba(255, 255, 255, 0.2);
                    }
                    
                    .modal-btn.confirm.danger {
                        background: linear-gradient(135deg, #ef4444, #dc2626);
                        color: white;
                        box-shadow: 0 4px 16px rgba(239, 68, 68, 0.4);
                    }
                    
                    .modal-btn.confirm.danger:hover {
                        box-shadow: 0 6px 24px rgba(239, 68, 68, 0.5);
                        transform: translateY(-2px);
                    }
                    
                    .modal-btn.confirm.warning {
                        background: linear-gradient(135deg, #f59e0b, #d97706);
                        color: white;
                        box-shadow: 0 4px 16px rgba(245, 158, 11, 0.4);
                    }
                    
                    .modal-btn.confirm.warning:hover {
                        box-shadow: 0 6px 24px rgba(245, 158, 11, 0.5);
                        transform: translateY(-2px);
                    }
                `}</style>
            </motion.div>
        </AnimatePresence>
    );
};

export default ConfirmModal;
