import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { notificationsAPI } from '../services/api';

const NotificationContext = createContext();

export const NotificationProvider = ({ children }) => {
    const [notifications, setNotifications] = useState([]);
    const [unreadCount, setUnreadCount] = useState(0);

    const fetchNotifications = useCallback(async () => {
        const token = sessionStorage.getItem('admin_token'); // Fix: Use sessionStorage
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
        const interval = setInterval(fetchNotifications, 30000); // Keep 30s polling
        return () => clearInterval(interval);
    }, [fetchNotifications]);

    const markAsRead = async (id) => {
        // Optimistic Update
        setNotifications(prev => prev.map(n => n._id === id ? { ...n, read: true } : n));
        setUnreadCount(prev => Math.max(0, prev - 1));

        try {
            await notificationsAPI.markRead(id);
            // No need to re-fetch immediately if optimistic update worked
        } catch (error) {
            console.error(error);
            // Revert on error (optional, but calling fetch fixes state)
            fetchNotifications();
        }
    };

    const markAllAsRead = async () => {
        // Optimistic Update
        setNotifications(prev => prev.map(n => ({ ...n, read: true })));
        setUnreadCount(0);

        try {
            await notificationsAPI.markAllRead();
        } catch (error) {
            console.error(error);
            fetchNotifications();
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

    const deleteNotification = async (id) => {
        // Optimistic update
        const toDelete = notifications.find(n => n._id === id);
        setNotifications(prev => prev.filter(n => n._id !== id));
        if (toDelete && !toDelete.read) {
            setUnreadCount(prev => Math.max(0, prev - 1));
        }

        try {
            await notificationsAPI.deleteOne(id);
        } catch (error) {
            console.error(error);
            fetchNotifications();
        }
    };

    const deleteSelectedNotifications = async (ids) => {
        // Optimistic update
        const deletedCount = notifications.filter(n => ids.includes(n._id) && !n.read).length;
        setNotifications(prev => prev.filter(n => !ids.includes(n._id)));
        setUnreadCount(prev => Math.max(0, prev - deletedCount));

        try {
            await notificationsAPI.deleteMultiple(ids);
        } catch (error) {
            console.error(error);
            fetchNotifications();
        }
    };

    return (
        <NotificationContext.Provider value={{
            notifications,
            unreadCount,
            markAsRead,
            markAllAsRead,
            clearAll,
            deleteNotification,
            deleteSelectedNotifications,
            refresh: fetchNotifications
        }}>
            {children}
        </NotificationContext.Provider>
    );
};

export const useNotifications = () => useContext(NotificationContext);
