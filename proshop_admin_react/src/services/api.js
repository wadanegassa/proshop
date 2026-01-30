import axios from 'axios';

const API_URL = 'http://localhost:5000/api/v1';

const api = axios.create({
    baseURL: API_URL,
});

// Request interceptor to add auth token
api.interceptors.request.use((config) => {
    const token = localStorage.getItem('admin_token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
}, (error) => {
    return Promise.reject(error);
});

// Response interceptor for error handling
api.interceptors.response.use((response) => {
    return response.data;
}, (error) => {
    if (error.response?.status === 401) {
        localStorage.removeItem('admin_token');
        window.location.href = '/login';
    }
    return Promise.reject(error);
});

export const analyticsAPI = {
    getDashboardData: () => api.get('/analytics'),
};

export const productsAPI = {
    getAll: () => api.get('/products'),
    getOne: (id) => api.get(`/products/${id}`),
    create: (data) => api.post('/products', data),
    update: (id, data) => api.patch(`/products/${id}`, data),
    delete: (id) => api.delete(`/products/${id}`),
};

export const ordersAPI = {
    getAll: () => api.get('/orders'),
    getOne: (id) => api.get(`/orders/${id}`),
    updateStatus: (id, status) => api.put(`/orders/${id}/status`, { status }),
    updateToDelivered: (id) => api.put(`/orders/${id}/deliver`),
};

export const categoriesAPI = {
    getAll: () => api.get('/categories'),
    create: (data) => api.post('/categories', data),
    update: (id, data) => api.patch(`/categories/${id}`, data),
    delete: (id) => api.delete(`/categories/${id}`),
};

export const usersAPI = {
    getAll: () => api.get('/users'),
    block: (id) => api.patch(`/users/${id}/block`),
    unblock: (id) => api.patch(`/users/${id}/unblock`),
};

export const uploadAPI = {
    uploadImage: (formData) => api.post('/upload', formData, {
        headers: {
            'Content-Type': 'multipart/form-data',
        },
    }),
};

export default api;
