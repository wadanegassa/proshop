# ProShop - Full Stack E-Commerce Documentation

ProShop is a robust, scalable, and feature-rich e-commerce ecosystem consisting of a high-performance backend, a modern analytical admin dashboard, and a cross-platform mobile application.

---

## System Architecture

ProShop is architected as a decoupled system where each component serves a specific purpose:

1.  **Backend API (proshop_backend_new)**: Built with Node.js and Express. It serves as the single source of truth for data, handles authentication via JWT, manages payments through Stripe/PayPal, and scales efficiently using MongoDB.
2.  **Admin Dashboard (proshop_admin_new)**: A React-based web application (Vite-powered) that provides store managers with real-time analytics, product management tools, and order tracking.
3.  **Mobile App (proshop_mobile)**: A Flutter-based native application for customers, offering a smooth shopping experience, secure checkout, and personalized features.

---

## Technology Stack

### 1. Backend API
*   Runtime: Node.js
*   Framework: Express.js
*   Database: MongoDB (Mongoose)
*   Auth: JSON Web Tokens (JWT) & BCrypt
*   Security: Helmet, CORS, Rate Limiting
*   Utilities: Multer (Uploads), Compression, Morgan (Logging)

### 2. Admin Dashboard
*   Framework: React.js (Vite)
*   Styling: Vanilla CSS, Framer Motion (Animations)
*   Icons: Lucide React
*   Charts: Recharts, D3 Scale
*   Maps: React Leaflet
*   PDF Exports: jsPDF, AutoTable

### 3. Mobile application
*   Framework: Flutter (Dart)
*   State Management: Provider
*   Storage: Flutter Secure Storage, SharedPreferences
*   Payments: Flutter Stripe, Flutter PayPal Payment
*   Caching: Cached Network Image

---

## Project Structure

```bash
/home/pro/projects/proshop/
  proshop_backend_new/   # Node.js Server
    server/            # Core logic
      controllers/   # Request handlers
      models/        # Mongoose schemas
      routes/        # API endpoints
      middleware/    # Auth & Error handling
  proshop_admin_new/     # React Web App
    src/
      components/    # Reusable UI elements
      pages/         # Dashboard, Products, Orders, etc.
      context/       # Auth & Theme state
  proshop_mobile/        # Flutter App
    lib/
      features/      # Screens & business logic
      providers/     # State management (Cart, Auth)
      models/        # Data structures
```

---

## API Endpoints (Backend)

The backend provides a RESTful API for all resources.

### Products
- GET /api/products - Get all products (with pagination/search)
- GET /api/products/:id - Get single product details
- POST /api/products - Create a new product (Admin)
- PATCH /api/products/:id - Update a product (Admin)
- DELETE /api/products/:id - Delete a product (Admin)
- POST /api/products/:id/reviews - Add a customer review

### Users & Auth
- POST /api/users/login - Authenticate user & get token
- POST /api/users/register - Create a new account
- GET /api/users/profile - Get current user profile
- GET /api/users - Get all users (Admin)

### Orders
- POST /api/orders - Create a new order
- GET /api/orders/:id - Get order by ID
- PATCH /api/orders/:id/pay - Update order to paid
- GET /api/orders/myorders - Get logged-in user's orders

---

## Admin Dashboard Features

The Admin Panel is designed for data-driven management:

- Analytical Dashboard: Visual representation of sales, revenue trends, and user growth using Recharts.
- Product Inventory: Full CRUD operations for products, categories, and inventory tracking.
- Order Management: Process orders, update shipping status, and view detailed invoices.
- Geospatial Insights: Interactive map showing customer distribution across the globe.
- PDF Reporting: Generate professional sales and performance reports with one click.

---

## Mobile App Features

The customer-facing app focuses on speed and usability:

- Smooth Browsing: Highly optimized product listing with infinite scroll and fast image loading.
- Global Search: Find products quickly with filtered search.
- Secure Checkout: Seamless integration with Stripe and PayPal for global payments.
- Real-time Cart: Persistent shopping cart synced across devices.
- User Profile: Track orders, manage addresses, and view personal history.

---

## Installation & Setup

### Prerequisites
- Node.js (v18+)
- Flutter SDK
- MongoDB Connection String

### Setup Steps
1. Clone the repo and navigate to the root.
2. Backend: cd proshop_backend_new && npm install. Create .env files. npm run dev.
3. Admin: cd proshop_admin_new && npm install && npm run dev.
4. Mobile: cd proshop_mobile && flutter pub get && flutter run.

---

Documentation generated on: 2026-02-11
