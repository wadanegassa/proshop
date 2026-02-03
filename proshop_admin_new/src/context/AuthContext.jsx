import React, { createContext, useContext, useState, useEffect } from 'react';
import { authAPI } from '../services/api';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const [token, setToken] = useState(sessionStorage.getItem('admin_token'));

    useEffect(() => {
        const fetchUser = async () => {
            if (token) {
                try {
                    const response = await authAPI.getMe();
                    if (response.data.data.user.role === 'admin') {
                        setUser(response.data.data.user);
                    } else {
                        logout();
                    }
                } catch (error) {
                    logout();
                }
            }
            setLoading(false);
        };
        fetchUser();
    }, [token]);

    const login = async (email, password) => {
        try {
            const response = await authAPI.login(email, password);
            const { token: newToken, data } = response.data;
            sessionStorage.setItem('admin_token', newToken);
            setToken(newToken);
            setUser(data.user);
            return { success: true };
        } catch (error) {
            return {
                success: false,
                message: error.response?.data?.message || 'Login failed'
            };
        }
    };

    const logout = () => {
        sessionStorage.removeItem('admin_token');
        setToken(null);
        setUser(null);
    };

    return (
        <AuthContext.Provider value={{ user, loading, login, logout, isAuthenticated: !!user }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);
