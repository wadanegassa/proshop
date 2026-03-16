import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/order_provider.dart';
import '../../../core/constants/app_colors.dart';

class WebViewChapaScreen extends StatefulWidget {
  final String url;
  final String txRef;
  final String orderId;

  const WebViewChapaScreen({
    super.key,
    required this.url,
    required this.txRef,
    required this.orderId,
  });

  @override
  State<WebViewChapaScreen> createState() => _WebViewChapaScreenState();
}

class _WebViewChapaScreenState extends State<WebViewChapaScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            _checkStatus(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('checkout/success')) {
              _verifyAndClose();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _checkStatus(String url) {
    if (url.contains('checkout/success') || url.contains('verify')) {
      _verifyAndClose();
    }
  }

  Future<void> _verifyAndClose() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    final orderProvider = context.read<OrderProvider>();
    final isSuccess = await orderProvider.verifyChapaPayment(widget.txRef);
    
    if (mounted) {
      Navigator.of(context).pop(isSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapa Checkout'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
