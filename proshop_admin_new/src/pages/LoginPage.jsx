import { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { ShoppingBag, Mail, Lock, Loader2 } from 'lucide-react';

const LoginPage = () => {
    const [email, setEmail] = useState('admin@proshop.com');
    const [password, setPassword] = useState('proshop1234');
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
        <div className="login-container">
            <div className="login-card glass-card premium-shadow fade-in">
                <div className="login-header">
                    <div className="login-logo">
                        <ShoppingBag size={32} />
                    </div>
                    <h1>ProShop <span className="gold-text">Admin</span></h1>
                    <p>Enter your credentials to access the dashboard</p>
                </div>

                <form onSubmit={handleSubmit} className="login-form">
                    <div className="form-group">
                        <label>Email Address</label>
                        <div className="input-wrap">
                            <Mail size={18} />
                            <input
                                type="email"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                placeholder="admin@proshop.com"
                                required
                            />
                        </div>
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <div className="input-wrap">
                            <Lock size={18} />
                            <input
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                placeholder="••••••••"
                                required
                            />
                        </div>
                    </div>

                    {error && <div className="error-msg">{error}</div>}

                    <button type="submit" className="login-btn" disabled={loading}>
                        {loading ? <Loader2 size={20} className="spin" /> : 'Sign In'}
                    </button>
                </form>
            </div>

            <style>{`
                .login-container {
                    height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: var(--background);
                    position: relative;
                    overflow: hidden;
                }
                .login-container::before {
                    content: '';
                    position: absolute;
                    width: 500px;
                    height: 500px;
                    background: radial-gradient(circle, rgba(255, 107, 0, 0.1) 0%, transparent 70%);
                    top: -200px;
                    right: -200px;
                }
                .login-container::after {
                    content: '';
                    position: absolute;
                    width: 400px;
                    height: 400px;
                    background: radial-gradient(circle, rgba(255, 107, 0, 0.05) 0%, transparent 70%);
                    bottom: -150px;
                    left: -150px;
                }
                .login-card {
                    width: 420px;
                    padding: 48px;
                    position: relative;
                    z-index: 10;
                    background: var(--surface);
                    border: 1px solid var(--divider);
                    backdrop-filter: blur(20px);
                    border-radius: 20px;
                }
                .login-header {
                    text-align: center;
                    margin-bottom: 40px;
                }
                .login-logo {
                    width: 54px;
                    height: 54px;
                    background: var(--primary);
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 20px;
                    box-shadow: 0 10px 20px rgba(255, 107, 0, 0.3);
                }
                .login-header h1 { font-size: 24px; font-weight: 800; margin-bottom: 8px; color: var(--text-primary); }
                .gold-text { color: var(--primary); }
                .login-header p { color: var(--text-muted); font-size: 13px; }
                .login-form { display: flex; flex-direction: column; gap: 20px; }
                .form-group { display: flex; flex-direction: column; gap: 10px; }
                .form-group label { font-size: 12px; font-weight: 600; color: var(--text-secondary); }
                .input-wrap {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    background: rgba(0, 0, 0, 0.2);
                    border: 1px solid rgba(255, 255, 255, 0.08);
                    padding: 14px 16px;
                    border-radius: 10px;
                    transition: all 0.3s ease;
                }
                .input-wrap:focus-within { border-color: var(--primary); background: rgba(0, 0, 0, 0.3); }
                .input-wrap input { background: transparent; border: none; outline: none; color: var(--text-primary); width: 100%; font-size: 14px; }
                .login-btn {
                    background: var(--primary);
                    color: white;
                    padding: 14px;
                    border-radius: 10px;
                    font-weight: 700;
                    font-size: 15px;
                    margin-top: 10px;
                    border: none;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }
                .login-btn:hover { background: #e66000; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255, 107, 0, 0.4); }
                .error-msg {
                    color: #ff4d4d;
                    font-size: 12px;
                    text-align: center;
                    background: rgba(255, 77, 77, 0.1);
                    padding: 10px;
                    border-radius: 8px;
                }
                .spin { animation: spin 1s linear infinite; }
                @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
            `}</style>
        </div>
    );
};

export default LoginPage;
