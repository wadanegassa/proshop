# ProShop Master Development Guide

This guide contains everything you need to run and manage the ProShop system on a daily basis.

## 🚀 Quick Start (Tunnel Method)

Follow these steps in order to ensure everything connects correctly:

### 1. Start the Backend
Navigate to `proshop_backend_new` and run:
```bash
npm run dev
```
*Shows logs for database connection and available network IPs.*

### 2. Start the Tunnel (For Remote/Mobile Testing)
In the same `proshop_backend_new` folder, run:
```bash
npm run tunnel
```
*Current Stable URL: `https://proshop-api-v1.loca.lt`*

### 3. Start the Admin Dashboard
Navigate to `proshop_admin_new` and run:
```bash
npm run dev
```

### 4. Run the Mobile App
Simply run the app (no extra flags needed now!):
```bash
flutter run
```

> [!NOTE]
> I have set your Local IP (`192.168.137.127`) as the default. If your IP changes, you can still use the old long command or update it in the app's Settings.

---
### 5. Alternative Tunnel (If LocalTunnel Fails)
If `npm run tunnel` stops working, use this alternative:
```bash
npm run tunnel:alt
```
*Look for the output line like: `https://xxxx.lhr.life tunneled with tls termination` and use that URL in your flutter run command.*

---
*Note: Once installed, the app will remember this link. You only need the tunnel and backend running to use it!*

### 6. Payment Setup
Ensure your `.env` file in `proshop_backend_new` has the following keys:
- `STRIPE_SECRET_KEY` & `STRIPE_PUBLISHABLE_KEY`
- `PAYPAL_CLIENT_ID`
- `CHAPA_SECRET_KEY` (e.g., `CHASECK_TEST-xxx`)
- `CHAPA_PUBLIC_KEY` (e.g., `CHAPUBK_TEST-xxx`)

---
### ⚠️ Important: Chapa & Birr (ETB)
The app displays prices in **USD**, but Chapa converts it to **ETB** at a fixed rate of **180 ETB per 1 USD**.
- Order $100 -> Chapa will request 18,000 ETB.
- **Description Limit**: Chapa descriptions must be < 50 characters and cannot contain special symbols like `#`.

### ⚠️ Important: Chapa Webhooks
Chapa needs to send a "Verification" message back to your server. 
- If you use **Local IP**, Chapa cannot send this message (it's not public).
- If you use `npm run tunnel:alt`, Chapa **can** send it.
- To make it work with Local IP, you might need to manually click the "Verify" button or refresh the order status in the app.

> [!TIP]
> For the best Chapa experience, set `BACKEND_URL` in your `.env` to your tunnel URL (e.g., `https://proshop-pro-v1.loca.lt`).

## 🔐 Admin Credentials

Use these credentials to log in to the Admin Dashboard or the Mobile App as an administrator:

- **Email**: `admin@proshop.com`
- **Password**: `proshop1234`

---

## 💡 Key Concepts

### Remote Connectivity (Localtunnel)
- We use **Localtunnel** to create a secure link between your local computer and the internet.
- The `bypass-tunnel-reminder: true` header is automatically included in all app requests to ensure a seamless experience without splash screens.

### Environment Configuration
- The mobile app uses `--dart-define` to inject the API URL at build time. 
- The backend is bound to `0.0.0.0` so it can accept connections from your phone on the same WiFi even without the tunnel.

### Payment Persistence
- The app stores your login token and the API URL securely. 
- **Chapa Verification**: If the app fails to verify automatically, you can trigger it manually via:
  `GET https://proshop-api-v1.loca.lt/api/v1/chapa/verify/YOUR_TX_REF`

---

## 🛠 Troubleshooting

- **Connection Error?** Check if `npm run tunnel` is still active and showing the correct URL.
- **App stuck on Loading?** Ensure your backend is running (`npm run dev`) and connected to MongoDB.
- **Login Failed?** Double check the Admin credentials above.
