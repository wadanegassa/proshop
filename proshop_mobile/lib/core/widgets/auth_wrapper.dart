import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/settings/screens/developer_settings_screen.dart';
import '../services/network_service.dart';
import '../services/api_config_service.dart';
import '../constants/api_constants.dart';
import '../widgets/connection_error_dialog.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInit = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _checkAuth();
      _isInit = true;
    }
  }

  Future<void> _checkAuth() async {
    // 0. Initialize API URL from config
    final apiUrl = await ApiConfigService.getApiUrl();
    ApiConstants.baseUrl = apiUrl;

    // 1. Initial connectivity check
    final result = await NetworkService.testConnection();
    
    if (!result.isSuccess) {
      if (mounted) {
        await ConnectionErrorDialog.show(
          context,
          title: 'Connection Error',
          message: result.getDetailedMessage(),
          onRetry: _checkAuth,
          onOpenSettings: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DeveloperSettingsScreen()),
            ).then((_) => _checkAuth());
          },
        );
      }
      return;
    }

    // 2. Perform auto-login if connected
    await context.read<AuthProvider>().autoLogin();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return auth.isAuthenticated ? const MainScreen() : const LoginScreen();
      },
    );
  }
}
