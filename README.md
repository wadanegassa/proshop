# ProShop - Full Stack E-Commerce Solution

ProShop is a robust and scalable e-commerce platform designed to provide a seamless shopping experience for customers and a powerful management interface for administrators. It features a high-performance backend, a modern analytical admin dashboard, and a cross-platform mobile application.

## 🚀 Project Overview

The ecosystem consists of three main components:

1.  **Backend API (`proshop_backend_new`)**: The core logic handling data, authentication, and payments.
2.  **Admin Dashboard (`proshop_admin_new`)**: A web-based command center for store management.
3.  **Mobile App (`proshop_mobile`)**: A native mobile experience for customers.

---

## 🛠️ Technology Stack

## Mobile App Setup & Connection

When testing the mobile app on a physical device, follow these steps to ensure it can connect to your local backend server:

### 1. Ensure Same Network
Your phone and development machine must be connected to the same WiFi network.

### 2. Configure Backend URL
The app now supports dynamic API URL configuration. 
- **Default Connection**: The app is configured to use `http://192.168.137.127:5000/api/v1` by default.
- **Manual Override**: If your IP changes, you can update it in the app without rebuilding:
  1. Open the app.
  2. Go to **Profile** → **Settings** → **Developer Settings**.
  3. Toggle **"Use Custom API URL"**.
  4. Enter your computer's local IP (e.g., `http://192.168.1.5:5000/api/v1`).
  5. Tap **"Test Connection"** to verify, then **"Save Configuration"**.

### 3. Troubleshooting
- Run `hostname -I` (Linux/Mac) or `ipconfig` (Windows) to find your computer's IP.
- Ensure the backend is running (`npm run dev`).
- Disable your computer's firewall temporarily if the connection is refused.
- Use the **"Test Connection"** tool in Developer Settings for detailed error diagnostics.

### 1. Backend API
Built with **Node.js** and **Express**, focusing on performance and security.
*   **Core**: Node.js, Express.js
*   **Database**: MongoDB (with Mongoose ODM)
*   **Authentication**: JSON Web Tokens (JWT), BCrypt
*   **Security**: Helmet (Headers), CORS
*   **Optimization**: Compression (Gzip), Morgan (Logging)
*   **File Handling**: Multer (Image Uploads)

### 2. Admin Dashboard
A modern Single Page Application (SPA) built with **React** and **Vite**.
*   **Framework**: React.js (Vite)
*   **Styling & UI**: Framer Motion (Animations), Lucide React (Icons)
*   **State & Networking**: Axios
*   **Analytics & Visualization**: Recharts, React Simple Maps, D3 Scale
*   **Features**:
    *   PDF Report Generation (`jspdf`, `jspdf-autotable`)
    *   Interactive Maps (`react-leaflet`)
    *   Real-time Notifications (`react-hot-toast`)

### 3. Mobile Application
A cross-platform mobile app built with **Flutter**.
*   **Framework**: Flutter (Dart)
*   **State Management**: Provider
*   **Networking**: HTTP
*   **Payments**:
    *   Stripe (`flutter_stripe`)
    *   PayPal (`flutter_paypal_payment`)
    *   Chapa (Ethiopian Birr - ETB)
*   **Storage**: Flutter Secure Storage, Shared Preferences
*   **Performance**: Cached Network Image, Flutter Cache Manager

---

## ✨ Key Features

### Backend
*   **RESTful API**: Comprehensive endpoints for products, users, orders, and uploads.
*   **Secure Auth**: Middleware for protecting admin and user routes.
*   **Image Processing**: Efficient handling of product images.
*   **Performance**: Sub-200ms query responses with optimized indexing.

### Admin Panel
*   **Dashboard**: Visual analytics for sales, users, and orders.
*   **Product Management**: Create, edit, and delete products easily.
*   **Order Tracking**: Monitor order status and details.
*   **Reporting**: Generate and export PDF reports for business insights.
*   **Geolocation**: Visualize user distribution on interactive maps.

### Mobile App
*   **User Friendly**: Intuitive UI for browsing and searching products.
*   **Secure Checkout**: Integrated Stripe and PayPal payment gateways.
*   **Personalization**: Wishlist and user profile management.
*   **Fast Loading**: Optimized image caching and minimized network usage.

---

## 📂 Project Structure

```bash
/home/pro/projects/proshop/
├── proshop_backend_new/  # Node.js/Express Server
├── proshop_admin_new/    # React Admin Dashboard
└── proshop_mobile/       # Flutter User App
```

---

## 🏁 Getting Started

Follow these instructions to set up the project locally.

### Prerequisites
*   **Node.js** (v16 or higher)
*   **Flutter SDK** (v3.0 or higher)
*   **MongoDB** (Local instance or Atlas URI)

### 1. Backend Setup
Navigate to the backend directory and install dependencies:
```bash
cd proshop_backend_new
npm install
```

**Configuration**:
Create a `.env` file in `proshop_backend_new/` with the following:
```env
NODE_ENV=development
PORT=5000
MONGO_URI=your_mongodb_uri
JWT_SECRET=your_jwt_secret
```

**Run Server**:
```bash
npm run dev  # Runs with Nodemon
```

### 2. Admin Panel Setup
Navigate to the admin directory:
```bash
cd proshop_admin_new
npm install
```

**Run Dashboard**:
```bash
npm run dev
```
Access the admin panel at `http://localhost:5173`.

### 3. Mobile App Setup
Navigate to the mobile directory:
```bash
cd proshop_mobile
flutter pub get
```

**Run App**:
```bash
# Ensure an emulator is running or a device is connected
flutter run
```

---
