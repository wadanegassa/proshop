 import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../utils/responsive_utils.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // No validation or logic - just navigate
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveUtils.isSmallPhone(context);
    final headerHeight = isSmallScreen ? 220.0 : (ResponsiveUtils.isMediumPhone(context) ? 260.0 : 300.0);
    final logoSize = ResponsiveUtils.scaleFontSize(80, context);
    final circleRadius = isSmallScreen ? 70.0 : 100.0;
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    final verticalSpacing = ResponsiveUtils.getVerticalSpacing(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              height: headerHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(ResponsiveUtils.isSmallPhone(context) ? 32 : 40),
                  bottomRight: Radius.circular(ResponsiveUtils.isSmallPhone(context) ? 32 : 40),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: CircleAvatar(
                      radius: circleRadius,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: -50,
                    child: CircleAvatar(
                      radius: circleRadius,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: logoSize,
                          color: Colors.white,
                        ),
                        SizedBox(height: isSmallScreen ? 8 : 16),
                        Text(
                          'ProShop',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontSize: ResponsiveUtils.scaleFontSize(32, context),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: verticalSpacing),
                    Text(
                      _isLogin ? 'Welcome Back!' : 'Create Account',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: ResponsiveUtils.scaleFontSize(24, context),
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 8),
                    Text(
                      _isLogin
                          ? 'Login to continue shopping'
                          : 'Sign up to get started',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: ResponsiveUtils.scaleFontSize(14, context),
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 24 : 32),
                    if (!_isLogin) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                    ],
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    if (_isLogin) ...[
                      SizedBox(height: isSmallScreen ? 4 : 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: ResponsiveUtils.scaleFontSize(14, context),
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: isSmallScreen ? 24 : 32),
                    PrimaryButton(
                      text: _isLogin ? 'Login' : 'Sign Up',
                      onPressed: _submit,
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? "Don't have an account? "
                              : "Already have an account? ",
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: ResponsiveUtils.scaleFontSize(14, context),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin ? 'Sign Up' : 'Login',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveUtils.scaleFontSize(14, context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
  }
}
