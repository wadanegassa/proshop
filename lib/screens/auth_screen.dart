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
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // No validation or logic - just navigate
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final isSmallPhone = ResponsiveUtils.isSmallPhone(context);
            final isMediumPhone = ResponsiveUtils.isMediumPhone(context);
            
            // Dynamic header height based on screen height
            final headerHeight = screenHeight < 600 
                ? 160.0 
                : (isSmallPhone ? 180.0 : (isMediumPhone ? 220.0 : 260.0));
            
            final logoSize = screenHeight < 600 
                ? 50.0 
                : (isSmallPhone ? 55.0 : (isMediumPhone ? 65.0 : 75.0));
            
            final circleRadius = screenHeight < 600 
                ? 50.0 
                : (isSmallPhone ? 55.0 : (isMediumPhone ? 75.0 : 95.0));
            
            final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
            final verticalSpacing = screenHeight < 600 ? 16.0 : ResponsiveUtils.getVerticalSpacing(context);

            return SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        height: headerHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(isSmallPhone ? 24 : 28),
                            bottomRight: Radius.circular(isSmallPhone ? 24: 28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -50,
                              right: -50,
                              child: Container(
                                width: circleRadius * 2,
                                height: circleRadius * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -40,
                              left: -40,
                              child: Container(
                                width: circleRadius * 1.6,
                                height: circleRadius * 1.6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
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
                                  SizedBox(height: screenHeight < 600 ? 6 : (isSmallPhone ? 8 : 10)),
                                  Text(
                                    'ProShop',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenHeight < 600 
                                          ? 22 
                                          : (isSmallPhone ? 24 : (isMediumPhone ? 28 : 32)),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Form
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Padding(
                              padding: EdgeInsets.all(horizontalPadding),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: screenHeight < 600 ? 16 : (isSmallPhone ? 20 : verticalSpacing)),
                                    Text(
                                      _isLogin ? 'Welcome Back!' : 'Create Account',
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            fontSize: screenHeight < 600 
                                                ? 18 
                                                : (isSmallPhone ? 20 : (isMediumPhone ? 22 : 24)),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: screenHeight < 600 ? 4 : (isSmallPhone ? 5 : 6)),
                                    Text(
                                      _isLogin
                                          ? 'Login to continue shopping'
                                          : 'Sign up to get started',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontSize: ResponsiveUtils.scaleFontSize(
                                              screenHeight < 600 ? 12 : 13, 
                                              context
                                            ),
                                          ),
                                    ),
                                    SizedBox(height: screenHeight < 600 ? 16 : (isSmallPhone ? 18 : 24)),
                                    if (!_isLogin) ...[ 
                                      TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          hintText: 'Full Name',
                                          prefixIcon: Icon(Icons.person_outline),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: screenHeight < 600 ? 12 : 16,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your name';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: screenHeight < 600 ? 10 : (isSmallPhone ? 12 : 14)),
                                    ],
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: 'Email Address',
                                        prefixIcon: Icon(Icons.email_outlined),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: screenHeight < 600 ? 12 : 16,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty || !value.contains('@')) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: screenHeight < 600 ? 10 : (isSmallPhone ? 12 : 14)),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        prefixIcon: Icon(Icons.lock_outline),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: screenHeight < 600 ? 12 : 16,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    if (_isLogin) ...[
                                      SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                            minimumSize: Size(0, screenHeight < 600 ? 32 : 36),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: screenHeight < 600 ? 4 : 6,
                                            ),
                                          ),
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.bodyMedium?.color,
                                              fontSize: ResponsiveUtils.scaleFontSize(12, context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: screenHeight < 600 ? 16 : (isSmallPhone ? 18 : 24)),
                                    PrimaryButton(
                                      text: _isLogin ? 'Login' : 'Sign Up',
                                      onPressed: _submit,
                                    ),
                                    SizedBox(height: screenHeight < 600 ? 12 : (isSmallPhone ? 14 : 16)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _isLogin
                                              ? "Don't have an account? "
                                              : "Already have an account? ",
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyMedium?.color,
                                            fontSize: ResponsiveUtils.scaleFontSize(
                                              screenHeight < 600 ? 12 : 13, 
                                              context
                                            ),
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
                                              fontSize: ResponsiveUtils.scaleFontSize(
                                                screenHeight < 600 ? 12 : 13, 
                                                context
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight < 600 ? 16 : (isSmallPhone ? 18 : 20)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ).animate().fadeIn();
  }
}
