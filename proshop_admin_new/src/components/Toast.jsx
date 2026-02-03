import React, { useEffect, useState } from 'react';
import { CheckCircle, X, AlertCircle, Info } from 'lucide-react';

const Toast = ({ message, type = 'success', onClose, duration = 3000 }) => {
    const [isVisible, setIsVisible] = useState(true);

    useEffect(() => {
        const timer = setTimeout(() => {
            setIsVisible(false);
            setTimeout(onClose, 300); // Wait for fade out animation
        }, duration);

        return () => clearTimeout(timer);
    }, [duration, onClose]);

    const getIcon = () => {
        switch (type) {
            case 'success': return <CheckCircle size={18} />;
            case 'error': return <AlertCircle size={18} />;
            case 'info': return <Info size={18} />;
            default: return <CheckCircle size={18} />;
        }
    };

    const getBgColor = () => {
        switch (type) {
            case 'success': return 'rgba(34, 197, 94, 0.9)';
            case 'error': return 'rgba(239, 68, 68, 0.9)';
            case 'info': return 'rgba(59, 130, 246, 0.9)';
            default: return 'var(--primary)';
        }
    };

    return (
        <div className={`toast-message ${isVisible ? 'fade-in' : 'fade-out'}`} style={{
            position: 'fixed',
            bottom: '24px',
            right: '24px',
            background: getBgColor(),
            color: 'white',
            padding: '12px 20px',
            borderRadius: '12px',
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            boxShadow: '0 8px 32px rgba(0,0,0,0.3)',
            backdropFilter: 'blur(8px)',
            zIndex: 9999,
            minWidth: '280px',
            border: '1px solid rgba(255,255,255,0.1)'
        }}>
            <div className="toast-icon">{getIcon()}</div>
            <span style={{ fontSize: '14px', fontWeight: '600', flex: 1 }}>{message}</span>
            <button onClick={() => { setIsVisible(false); setTimeout(onClose, 300); }} style={{
                background: 'transparent',
                border: 'none',
                color: 'white',
                cursor: 'pointer',
                opacity: 0.7,
                display: 'flex',
                padding: '4px'
            }}>
                <X size={16} />
            </button>

            <style>{`
                .toast-message.fade-in { animation: toastIn 0.3s ease-out forwards; }
                .toast-message.fade-out { animation: toastOut 0.3s ease-in forwards; }
                @keyframes toastIn {
                    from { opacity: 0; transform: translateY(20px) scale(0.9); }
                    to { opacity: 1; transform: translateY(0) scale(1); }
                }
                @keyframes toastOut {
                    from { opacity: 1; transform: translateY(0) scale(1); }
                    to { opacity: 0; transform: translateY(20px) scale(0.9); }
                }
            `}</style>
        </div>
    );
};

export default Toast;
