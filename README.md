# ProShop - Full Stack E-Commerce Solution

ProShop is a complete e-commerce ecosystem designed to provide a seamless shopping experience for customers and a powerful management tool for administrators. It features a scalable backend, a modern web-based admin panel, and a cross-platform mobile application.

## 🚀 Components

The project is organized into three main modules:

### 1. Backend API (`proshop_backend_new`)
The backbone of the application, handling all data processing, authentication, and business logic.
-   **Tech**: Node.js, Express, MongoDB
-   **Features**:
    -   RESTful API endpoints
    -   JWT Authentication (Admin & User)
    -   Image Uploads with Multer
    -   Order & Product Management

### 2. Admin Dashboard (`proshop_admin_new`)
A responsive web application for store administrators to manage the platform.
-   **Tech**: React, Vite, Recharts, Framer Motion
-   **Features**:
    -   Product creation and editing
    -   Order tracking and status updates
    -   Sales analytics and visualization
    -   Interactive maps and charts

### 3. Mobile App (`proshop_mobile`)
A customer-facing mobile application for browsing and purchasing products.
-   **Tech**: Flutter, Dart
-   **Features**:
    -   Product catalog and search
    -   User authentication and profile management
    -   Shopping cart and wishlist
    -   Secure checkout process

## 🛠️ Tech Stack Summary

| Component | Key Technologies |
| :--- | :--- |
| **Backend** | Node.js, Express.js, MongoDB, Mongoose, JWT, Bcrypt |
| **Admin** | React.js, Vite, Axios, Recharts, Framer Motion, Lucide React |
| **Mobile** | Flutter, Dart, Provider (State Management), Flutter Secure Storage |

## 📂 Project Structure

```bash
/home/pro/projects/proshop/
├── proshop_backend_new/  # Server-side code
├── proshop_admin_new/    # Admin Web Dashboard
└── proshop_mobile/       # Flutter Mobile Application
```

## 🏁 Getting Started

Follow these steps to set up the project locally.

### Prerequisites
-   Node.js (v16+)
-   Flutter SDK (v3.0+)
-   MongoDB (Local or Atlas URI)

### 1. Backend Setup
```bash
cd proshop_backend_new
npm install
# Create a .env file and add your MONGO_URI and JWT_SECRET
npm run dev
```

### 2. Admin Panel Setup
```bash
cd proshop_admin_new
npm install
npm run dev
```

### 3. Mobile App Setup
```bash
cd proshop_mobile
flutter pub get
flutter run
```

## 📄 License
This project is for educational and portfolio purposes.
