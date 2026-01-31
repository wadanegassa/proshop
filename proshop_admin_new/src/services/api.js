import axios from 'axios';

const API_URL = 'http://localhost:5000/api/v1';

const api = axios.create({
    baseURL: API_URL,
});

api.interceptors.request.use((config) => {
    console.log('API Request:', config.url);
    const token = localStorage.getItem('admin_token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

export const authAPI = {
    login: (email, password) => api.post('/auth/admin/login', { email, password }),
    getMe: () => api.get('/auth/me'),
};

export const usersAPI = {
    getAll: () => api.get('/auth'), // Note: The route is /api/v1/auth for userRoutes, as mounted in app.js. I should check app.js to be sure.
    delete: (id) => api.delete(`/auth/${id}`),
};

export const productsAPI = {
    getAll: (params) => api.get('/products', { params }),
    getOne: (id) => api.get(`/products/${id}`),
    create: (data) => api.post('/products', data),
    update: (id, data) => api.patch(`/products/${id}`, data),
    delete: (id) => api.delete(`/products/${id}`),
};

export const categoriesAPI = {
    getAll: () => api.get('/categories'),
    create: (data) => api.post('/categories', data),
    update: (id, data) => api.patch(`/categories/${id}`, data),
    delete: (id) => api.delete(`/categories/${id}`),
};

export const ordersAPI = {
    getAll: () => api.get('/orders'),
    getOne: (id) => api.get(`/orders/${id}`),
    updateStatus: (id, status) => api.patch(`/orders/${id}/status`, { status }),
    delete: (id) => api.delete(`/orders/${id}`),
};

export const notificationsAPI = {
    getAll: () => api.get('/notifications'),
    markRead: (id) => api.patch(`/notifications/${id}/read`),
    markAllRead: () => api.patch('/notifications/read-all'),
    clearAll: () => api.delete('/notifications/clear'),
};

export const analyticsAPI = {
    getStats: (range = '1M') => api.get('/analytics', { params: { range } }),
};

export const settingsAPI = {
    getSettings: () => api.get('/settings'),
    updateSettings: (data) => api.put('/settings', data),
};

export const uploadAPI = {
    uploadImage: (formData) => api.post('/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
    }),
};

export const getImageUrl = (path) => {
    if (!path || typeof path !== 'string') return 'https://images.unsplash.com/photo-1581447100595-3a74ad993bd1?q=80&w=800&auto=format&fit=crop';
    if (path.startsWith('http')) return path;

    // Ensure path starts with /uploads/ if it's a local path
    let cleanPath = path.startsWith('/') ? path : `/${path}`;
    if (!cleanPath.startsWith('/uploads/')) {
        cleanPath = `/uploads${cleanPath}`;
    }

    return `${API_URL.replace('/api/v1', '')}${cleanPath}`;
};

export default api;
