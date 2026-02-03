import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/order_model.dart';
import '../core/constants/api_constants.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  List<OrderModel> get orders => [..._orders];
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse(ApiConstants.myOrders),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> ordersData = responseData['data']['orders'];
        _orders = ordersData.map((item) => OrderModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createOrder(OrderModel order) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.post(
        Uri.parse(ApiConstants.orders),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(order.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final createdOrder = responseData['data'];
        final id = createdOrder['_id'] ?? createdOrder['id'];
        debugPrint('Order Created Successfully. ID: $id');
        await fetchOrders();
        return id;
      }
      debugPrint('Order Creation Failed. Status: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('Error creating order: $e');
      return null;
    }
  }

  Future<String?> payOrder(String orderId, Map<String, dynamic> paymentResult) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.patch(
        Uri.parse('${ApiConstants.orders}/$orderId/pay'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(paymentResult),
      );

      debugPrint('Pay Order Response: ${response.statusCode}');
      if (response.statusCode == 200) {
        await fetchOrders();
        return null; // Null means success
      }
      
      final responseData = json.decode(response.body);
      return responseData['message'] ?? 'Payment verification failed';
    } catch (e) {
      debugPrint('Error paying order: $e');
      return e.toString();
    }
  }

  Future<String?> getPaypalClientId() async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse(ApiConstants.paypalConfig),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['data'];
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching PayPal config: $e');
      return null;
    }
  }

  Future<String?> getStripePublishableKey() async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse(ApiConstants.stripeConfig),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['data'];
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching Stripe config: $e');
      return null;
    }
  }

  Future<String?> createStripePaymentIntent(double amount) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.post(
        Uri.parse(ApiConstants.stripePaymentIntent),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'amount': amount}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['clientSecret'];
      }
      debugPrint('Stripe Payment Intent Failed: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Error creating Stripe Payment Intent: $e');
      return null;
    }
  }

  Future<bool> deleteOrder(String orderId) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.delete(
        Uri.parse('${ApiConstants.orders}/$orderId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        await fetchOrders();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting order: $e');
      return false;
    }
  }
}
