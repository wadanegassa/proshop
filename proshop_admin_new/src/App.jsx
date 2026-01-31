import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { ThemeProvider } from './context/ThemeContext';
import { NotificationProvider } from './context/NotificationContext';
import AdminLayout from './layout/AdminLayout';
import DashboardPage from './pages/DashboardPage';
import LoginPage from './pages/LoginPage';
import ProductListPage from './pages/ProductListPage';
import ProductGridPage from './pages/ProductGridPage';
import ProductDetailsPage from './pages/ProductDetailsPage';
import ProductEditPage from './pages/ProductEditPage';
import ProductCreatePage from './pages/ProductCreatePage';
import CategoryListPage from './pages/CategoryListPage';
import OrderListPage from './pages/OrderListPage';
import CustomersPage from './pages/CustomersPage';
import NotificationsPage from './pages/NotificationsPage';
import PrivateRoute from './components/PrivateRoute';
import { Layers } from 'lucide-react';

function App() {
    return (
        <ThemeProvider>
            <AuthProvider>
                <NotificationProvider>
                    <Router>
                        <Routes>
                            <Route path="/login" element={<LoginPage />} />
                            <Route path="/" element={<AdminLayout />}>
                                <Route index element={<PrivateRoute><DashboardPage /></PrivateRoute>} />
                                <Route path="products" element={<PrivateRoute><ProductListPage /></PrivateRoute>} />
                                <Route path="products/grid" element={<PrivateRoute><ProductGridPage /></PrivateRoute>} />
                                <Route path="products/details/:id" element={<PrivateRoute><ProductDetailsPage /></PrivateRoute>} />
                                <Route path="products/edit/:id" element={<PrivateRoute><ProductEditPage /></PrivateRoute>} />
                                <Route path="products/create" element={<PrivateRoute><ProductCreatePage /></PrivateRoute>} />
                                <Route path="categories" element={<PrivateRoute><CategoryListPage /></PrivateRoute>} />
                                <Route path="orders" element={<PrivateRoute><OrderListPage /></PrivateRoute>} />
                                <Route path="orders/details/:id" element={<PrivateRoute><Placeholder title="Order Details" /></PrivateRoute>} />
                                <Route path="inventory" element={<PrivateRoute><Placeholder title="Inventory Management" /></PrivateRoute>} />
                                <Route path="purchases" element={<PrivateRoute><Placeholder title="Purchase History" /></PrivateRoute>} />
                                <Route path="attributes" element={<PrivateRoute><Placeholder title="Product Attributes" /></PrivateRoute>} />
                                <Route path="invoices" element={<PrivateRoute><Placeholder title="Invoice Management" /></PrivateRoute>} />
                                <Route path="users" element={<PrivateRoute><Placeholder title="User Management" /></PrivateRoute>} />
                                <Route path="profile" element={<PrivateRoute><Placeholder title="User Profile" /></PrivateRoute>} />
                                <Route path="roles" element={<PrivateRoute><Placeholder title="Role Management" /></PrivateRoute>} />
                                <Route path="permissions" element={<PrivateRoute><Placeholder title="Permissions" /></PrivateRoute>} />
                                <Route path="customers" element={<PrivateRoute><CustomersPage /></PrivateRoute>} />
                                <Route path="coupons" element={<PrivateRoute><Placeholder title="Coupons & Offers" /></PrivateRoute>} />
                                <Route path="reviews" element={<PrivateRoute><Placeholder title="Customer Reviews" /></PrivateRoute>} />
                                <Route path="chat" element={<PrivateRoute><Placeholder title="Chat Application" /></PrivateRoute>} />
                                <Route path="email" element={<PrivateRoute><Placeholder title="Email Inbox" /></PrivateRoute>} />
                                <Route path="calendar" element={<PrivateRoute><Placeholder title="Calendar" /></PrivateRoute>} />
                                <Route path="todo" element={<PrivateRoute><Placeholder title="Todo List" /></PrivateRoute>} />
                                <Route path="help" element={<PrivateRoute><Placeholder title="Help Center" /></PrivateRoute>} />
                                <Route path="faqs" element={<PrivateRoute><Placeholder title="FAQs" /></PrivateRoute>} />
                                <Route path="analytics" element={<PrivateRoute><Placeholder title="Deep Analytics" /></PrivateRoute>} />
                                <Route path="notifications" element={<PrivateRoute><NotificationsPage /></PrivateRoute>} />
                                <Route path="settings" element={<PrivateRoute><Placeholder title="System Settings" /></PrivateRoute>} />
                            </Route>
                        </Routes>
                    </Router>
                </NotificationProvider>
            </AuthProvider>
        </ThemeProvider>
    );
}

const Placeholder = ({ title }) => (
    <div className="page-container fade-in" style={{ padding: '40px', display: 'flex', justifyContent: 'center' }}>
        <div className="glass-card premium-shadow" style={{
            maxWidth: '600px',
            textAlign: 'center',
            padding: '80px 48px',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '24px'
        }}>
            <div style={{
                width: '80px',
                height: '80px',
                background: 'var(--primary-glow)',
                borderRadius: '24px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            }}>
                <Layers size={40} color="var(--primary)" />
            </div>
            <h1 style={{ fontSize: '32px', fontWeight: '800', color: 'var(--text-primary)' }}>{title}</h1>
            <p style={{ color: 'var(--text-muted)', fontSize: '16px', lineHeight: '1.6' }}>
                We are building this module with the latest ProShop Premium components. It will be online shortly.
            </p>
            <button className="btn-primary" style={{
                marginTop: '12px',
                padding: '12px 32px',
                background: 'var(--primary)',
                color: 'white',
                borderRadius: '12px',
                fontWeight: '600',
                border: 'none',
                cursor: 'pointer'
            }} onClick={() => window.history.back()}>
                Go Back
            </button>
        </div>
    </div>
);

export default App;
