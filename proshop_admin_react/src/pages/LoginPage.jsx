import { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { ShoppingBag, Mail, Lock, Loader2 } from 'lucide-react';

const LoginPage = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const { login } = useAuth();
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        setLoading(true);

        const result = await login(email, password);
        setLoading(false);

        if (result.success) {
            navigate('/');
        } else {
            setError(result.message);
        }
    };

    return (
        <div style={styles.container}>
            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                style={styles.card}
            >
                <div style={styles.logoContainer}>
                    <div style={styles.iconBox}>
                        <ShoppingBag size={28} color="var(--background)" />
                    </div>
                    <h1 style={styles.title}>ProShop <span className="gold-text">Admin</span></h1>
                    <p style={styles.subtitle}>Secure Access to Management Portal</p>
                </div>

                <form onSubmit={handleSubmit} style={styles.form}>
                    <div style={styles.inputGroup}>
                        <label style={styles.label}>Email Address</label>
                        <div style={styles.inputWrapper}>
                            <Mail style={styles.inputIcon} size={18} />
                            <input
                                type="email"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                placeholder="admin@proshop.com"
                                style={styles.input}
                                required
                            />
                        </div>
                    </div>

                    <div style={styles.inputGroup}>
                        <label style={styles.label}>Password</label>
                        <div style={styles.inputWrapper}>
                            <Lock style={styles.inputIcon} size={18} />
                            <input
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                placeholder="••••••••"
                                style={styles.input}
                                required
                            />
                        </div>
                    </div>

                    {error && <p style={styles.error}>{error}</p>}

                    <button
                        type="submit"
                        disabled={loading}
                        style={loading ? { ...styles.button, opacity: 0.7 } : styles.button}
                    >
                        {loading ? <Loader2 className="spin" size={20} /> : 'Sign In'}
                    </button>
                </form>
            </motion.div>

            <style>{`
        .spin { animation: spin 1s linear infinite; }
        @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
      `}</style>
        </div>
    );
};

const styles = {
    container: {
        height: '100vh',
        width: '100vw',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: '#050505',
        backgroundImage: 'radial-gradient(circle at 50% 50%, #111 0%, #050505 100%)',
    },
    card: {
        width: '400px',
        padding: '40px',
        background: 'rgba(20, 20, 20, 0.8)',
        backdropFilter: 'blur(10px)',
        border: '1px solid var(--divider)',
        borderRadius: '20px',
        boxShadow: '0 20px 50px rgba(0,0,0,0.5)',
    },
    logoContainer: {
        textAlign: 'center',
        marginBottom: '40px',
    },
    iconBox: {
        width: '56px',
        height: '56px',
        background: 'var(--primary)',
        borderRadius: '16px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        margin: '0 auto 16px',
        boxShadow: '0 8px 20px var(--primary-glow)',
    },
    title: {
        fontSize: '24px',
        fontWeight: '800',
        marginBottom: '8px',
    },
    subtitle: {
        color: 'var(--text-secondary)',
        fontSize: '14px',
    },
    form: {
        display: 'flex',
        flexDirection: 'column',
        gap: '24px',
    },
    inputGroup: {
        display: 'flex',
        flexDirection: 'column',
        gap: '8px',
    },
    label: {
        fontSize: '13px',
        fontWeight: '600',
        color: 'var(--text-secondary)',
    },
    inputWrapper: {
        position: 'relative',
        display: 'flex',
        alignItems: 'center',
    },
    inputIcon: {
        position: 'absolute',
        left: '14px',
        color: 'var(--text-muted)',
    },
    input: {
        width: '100%',
        padding: '14px 14px 14px 44px',
        background: 'var(--background)',
        border: '1px solid var(--divider)',
        borderRadius: '12px',
        color: 'var(--text-primary)',
        outline: 'none',
        transition: 'var(--transition)',
    },
    error: {
        color: 'var(--error)',
        fontSize: '13px',
        textAlign: 'center',
    },
    button: {
        width: '100%',
        padding: '14px',
        background: 'var(--primary)',
        color: 'black',
        fontWeight: '700',
        fontSize: '15px',
        borderRadius: '12px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: '8px',
    }
};

export default LoginPage;
