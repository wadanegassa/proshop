import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { notificationsAPI } from '../services/api';

const NotificationContext = createContext();

export const NotificationProvider = ({ children }) => {
    const [notifications, setNotifications] = useState([]);
    const [unreadCount, setUnreadCount] = useState(0);

    const fetchNotifications = useCallback(async () => {
        const token = localStorage.getItem('admin_token');
        if (!token) return;

        try {
            const response = await notificationsAPI.getAll();
            const fetched = response.data.data.notifications;
            setNotifications(fetched);
            setUnreadCount(fetched.filter(n => !n.read).length);
        } catch (error) {
            console.error('Failed to fetch notifications:', error);
        }
    }, []);

    useEffect(() => {
        fetchNotifications();
        const interval = setInterval(fetchNotifications, 30000);
        return () => clearInterval(interval);
    }, [fetchNotifications]);

    const markAsRead = async (id) => {
        try {
            await notificationsAPI.markRead(id);
            fetchNotifications();
        } catch (error) {
            console.error(error);
        }
    };

    const markAllAsRead = async () => {
        try {
            await notificationsAPI.markAllRead();
            fetchNotifications();
        } catch (error) {
            console.error(error);
        }
    };

    const clearAll = async () => {
        try {
            await notificationsAPI.clearAll();
            setNotifications([]);
            setUnreadCount(0);
        } catch (error) {
            console.error(error);
        }
    };

    return (
        <NotificationContext.Provider value={{ notifications, unreadCount, markAsRead, markAllAsRead, clearAll, refresh: fetchNotifications }}>
            {children}
        </NotificationContext.Provider>
    );
};

export const useNotifications = () => useContext(NotificationContext);
