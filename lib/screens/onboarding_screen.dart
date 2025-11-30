import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
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
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppTheme.primaryColor
                            : AppTheme.textLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
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
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/auth');
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                  SizedBox(height: 16),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                  SizedBox(height: 100), // Extra padding for bottom buttons
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
