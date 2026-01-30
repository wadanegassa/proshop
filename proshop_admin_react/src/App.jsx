import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import AdminLayout from './layout/AdminLayout';
import DashboardPage from './pages/DashboardPage';
import LoginPage from './pages/LoginPage';
import ProductListPage from './pages/ProductListPage';
import OrderListPage from './pages/OrderListPage';
import ProductDetailsPage from './pages/ProductDetailsPage';
import ProductEditPage from './pages/ProductEditPage';
import OrderDetailsPage from './pages/OrderDetailsPage';
import CategoryListPage from './pages/CategoryListPage';
import UserListPage from './pages/UserListPage';

import PrivateRoute from './components/PrivateRoute';
import GlobalErrorBoundary from './components/GlobalErrorBoundary';

function App() {
  return (
    <GlobalErrorBoundary>
      <AuthProvider>
        <Router>
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/" element={<AdminLayout />}>
              <Route index element={<PrivateRoute><DashboardPage /></PrivateRoute>} />
              <Route path="products" element={<PrivateRoute><ProductListPage /></PrivateRoute>} />
              <Route path="products/add" element={<PrivateRoute><ProductEditPage /></PrivateRoute>} />
              <Route path="products/edit/:id" element={<PrivateRoute><ProductEditPage /></PrivateRoute>} />
              <Route path="products/detail/:id" element={<PrivateRoute><ProductDetailsPage /></PrivateRoute>} />
              <Route path="orders" element={<PrivateRoute><OrderListPage /></PrivateRoute>} />
              <Route path="orders/details/:id" element={<OrderDetailsPage />} />
              <Route path="categories" element={<CategoryListPage />} />
              <Route path="inventory" element={<Placeholder title="Inventory Tracking" />} />
              <Route path="users" element={<UserListPage />} />
              <Route path="analytics" element={<Placeholder title="Platform Analytics" />} />
              <Route path="settings" element={<Placeholder title="System Settings" />} />
            </Route>
          </Routes>
        </Router>
      </AuthProvider>
    </GlobalErrorBoundary>
  );
}

const Placeholder = ({ title }) => (
  <div style={{ padding: '20px' }}>
    <h1 style={{ fontSize: '24px', fontWeight: '800', marginBottom: '12px' }}>{title}</h1>
    <p style={{ color: 'var(--text-secondary)' }}>This module is currently being migrated to the Larkon design system.</p>
  </div>
);

export default App;
