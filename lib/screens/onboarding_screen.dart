import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../utils/responsive_utils.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover Latest Trends',
      'description': 'Explore the most popular items from the best brands around the world.',
      'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Easy Shopping',
      'description': 'Experience the easiest way to shop for your favorite products.',
      'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Fast Delivery',
      'description': 'Get your products delivered to your doorstep in no time.',
      'image': 'https://images.unsplash.com/photo-1586880244406-556ebe35f282?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallPhone = ResponsiveUtils.isSmallPhone(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    title: _onboardingData[index]['title']!,
                    description: _onboardingData[index]['description']!,
                    imageUrl: _onboardingData[index]['image']!,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding, 
                0, 
                horizontalPadding, 
                screenHeight < 600 ? 12 : (isSmallPhone ? 16 : 24)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(right: 8),
                        height: screenHeight < 600 ? 5 : (isSmallPhone ? 6 : 8),
                        width: _currentPage == index 
                            ? (screenHeight < 600 ? 18 : (isSmallPhone ? 20 : 24)) 
                            : (screenHeight < 600 ? 5 : (isSmallPhone ? 6 : 8)),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primaryColor
                              : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight < 600 ? 16 : (isSmallPhone ? 18 : 24)),
                  PrimaryButton(
                    text: _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        Navigator.of(context).pushReplacementNamed('/auth');
                      } else {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  if (_currentPage != _onboardingData.length - 1)
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight < 600 ? 4 : 8),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/auth');
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size(0, screenHeight < 600 ? 36 : 40),
                          padding: EdgeInsets.symmetric(vertical: screenHeight < 600 ? 6 : 8),
                        ),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: ResponsiveUtils.scaleFontSize(14, context),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;
        final isSmallPhone = ResponsiveUtils.isSmallPhone(context);
        final isTablet = ResponsiveUtils.isTablet(context);
        final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
        
        // Dynamic spacing based on available height
        final topSpacing = screenHeight < 600 ? 12.0 : (isSmallPhone ? 16.0 : 24.0);
        final titleFontSize = screenHeight < 600 
            ? ResponsiveUtils.scaleFontSize(20, context)
            : ResponsiveUtils.scaleFontSize(isSmallPhone ? 22 : 26, context);
        final descriptionFontSize = screenHeight < 600 
            ? ResponsiveUtils.scaleFontSize(12, context)
            : ResponsiveUtils.scaleFontSize(13, context);
        
        // Dynamic flex ratios based on screen height
        final imageFlex = screenHeight < 600 ? 6 : (isSmallPhone ? 5 : 6);
        final contentFlex = screenHeight < 600 ? 3 : (isSmallPhone ? 4: 3);
        
        final imageMargin = screenHeight < 600 ? 8.0 : (isSmallPhone ? 10.0 : 14.0);
        final borderRadius = screenHeight < 600 ? 16.0 : (isSmallPhone ? 18.0 : 22.0);
        
        return Column(
          children: [
            Expanded(
              flex: imageFlex,
              child: Center(
                child: Container(
                  width: isTablet ? screenWidth * 0.8 : double.infinity,
                  margin: EdgeInsets.all(imageMargin),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: AppTheme.shadowMd,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: contentFlex,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: topSpacing),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                          SizedBox(height: screenHeight < 600 ? 6 : (isSmallPhone ? 8 : 12)),
                          Text(
                            description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: descriptionFontSize,
                                  height: 1.4,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                          // Reduced bottom spacing since controls are no longer overlapping
                          SizedBox(height: screenHeight < 600 ? 10 : (isSmallPhone ? 12 : 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
