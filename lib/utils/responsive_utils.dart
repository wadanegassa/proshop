import 'package:flutter/material.dart';

/// Utility class for responsive design across different screen sizes
class ResponsiveUtils {
  // Breakpoint constants
  static const double smallPhoneMaxWidth = 375.0;
  static const double mediumPhoneMaxWidth = 414.0;
  static const double largePhoneMaxWidth = 480.0;
  static const double tabletMaxWidth = 768.0;
  static const double desktopMinWidth = 1100.0;

  /// Check if current screen is a small phone (< 375px)
  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < smallPhoneMaxWidth;
  }

  /// Check if current screen is a medium phone (375-414px)
  static bool isMediumPhone(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= smallPhoneMaxWidth && width < mediumPhoneMaxWidth;
  }

  /// Check if current screen is a large phone (414-480px)
  static bool isLargePhone(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mediumPhoneMaxWidth && width < largePhoneMaxWidth;
  }

  /// Check if current screen is a tablet (480-768px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= largePhoneMaxWidth && width < tabletMaxWidth;
  }

  /// Check if current screen is desktop-sized (>= 1100px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMinWidth;
  }

  /// Check if current screen is mobile (< 768px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletMaxWidth;
  }

  /// Get optimal grid column count based on screen size
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return 1; // Very small phones: 1 column
    } else if (width < mediumPhoneMaxWidth) {
      return 2; // Small to medium phones: 2 columns
    } else if (width < largePhoneMaxWidth) {
      return 2; // Medium to large phones: 2 columns
    } else if (width < tabletMaxWidth) {
      return 2; // Large phones: 2-3 columns
    } else if (width < desktopMinWidth) {
      return 3; // Tablets: 3 columns
    } else {
      return 4; // Desktop: 4 columns
    }
  }

  /// Get responsive horizontal padding
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return 12.0; // Smaller padding for very small screens
    } else if (width < mediumPhoneMaxWidth) {
      return 16.0;
    } else if (width < largePhoneMaxWidth) {
      return 20.0;
    } else if (width < tabletMaxWidth) {
      return 24.0;
    } else {
      return 32.0; // Larger padding for tablets and desktop
    }
  }

  /// Get responsive vertical spacing
  static double getVerticalSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return 16.0;
    } else if (width < mediumPhoneMaxWidth) {
      return 20.0;
    } else if (width < tabletMaxWidth) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  /// Scale font size based on screen size
  static double scaleFontSize(double baseSize, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return baseSize * 0.85; // 15% smaller on very small screens
    } else if (width < mediumPhoneMaxWidth) {
      return baseSize * 0.9; // 10% smaller on small screens
    } else if (width < largePhoneMaxWidth) {
      return baseSize; // Base size on medium screens
    } else if (width < tabletMaxWidth) {
      return baseSize * 1.05; // 5% larger on large phones
    } else if (width < desktopMinWidth) {
      return baseSize * 1.1; // 10% larger on tablets
    } else {
      return baseSize * 1.15; // 15% larger on desktop
    }
  }

  /// Get hero banner height based on screen size
  static double getHeroBannerHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return 160.0; // Smaller banner for very small screens
    } else if (width < mediumPhoneMaxWidth) {
      return 180.0;
    } else if (width < largePhoneMaxWidth) {
      return 200.0;
    } else if (width < tabletMaxWidth) {
      return 220.0;
    } else if (width < desktopMinWidth) {
      return 250.0;
    } else {
      return 300.0; // Full height on desktop
    }
  }

  /// Get product card width for horizontal scrolling lists
  static double getProductCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return 140.0; // Narrower cards on very small screens
    } else if (width < mediumPhoneMaxWidth) {
      return 160.0;
    } else if (width < largePhoneMaxWidth) {
      return 180.0;
    } else if (width < tabletMaxWidth) {
      return 200.0;
    } else {
      return 220.0;
    }
  }

  /// Get responsive border radius
  static double getResponsiveRadius(double baseRadius, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return baseRadius * 0.8; // Slightly smaller radius on small screens
    } else {
      return baseRadius;
    }
  }

  /// Get responsive spacing value
  static double getResponsiveSpacing(double baseSpacing, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return baseSpacing * 0.75; // 25% smaller spacing
    } else if (width < mediumPhoneMaxWidth) {
      return baseSpacing * 0.85; // 15% smaller spacing
    } else {
      return baseSpacing;
    }
  }

  /// Get cart item image size
  static double getCartItemImageSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return 60.0; // Smaller on very small screens
    } else if (width < mediumPhoneMaxWidth) {
      return 70.0;
    } else {
      return 80.0; // Standard size
    }
  }

  /// Get profile avatar radius
  static double getProfileAvatarRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return 32.0; // Smaller avatar on very small screens
    } else if (width < mediumPhoneMaxWidth) {
      return 36.0;
    } else {
      return 40.0; // Standard size
    }
  }

  /// Get product detail image height
  static double getProductDetailImageHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    if (width < smallPhoneMaxWidth) {
      return height * 0.35; // 35% of screen height
    } else if (width < mediumPhoneMaxWidth) {
      return height * 0.4; // 40% of screen height
    } else if (width < largePhoneMaxWidth) {
      return height * 0.45; // 45% of screen height
    } else if (width < tabletMaxWidth) {
      return height * 0.5; // 50% of screen height
    } else {
      return 500.0; // Fixed height on larger screens
    }
  }

  /// Get icon size based on screen size
  static double getIconSize(double baseSize, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return baseSize * 0.9;
    } else {
      return baseSize;
    }
  }

  /// Get button padding based on screen size
  static EdgeInsets getButtonPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < smallPhoneMaxWidth) {
      return EdgeInsets.symmetric(vertical: 12, horizontal: 20);
    } else if (width < mediumPhoneMaxWidth) {
      return EdgeInsets.symmetric(vertical: 14, horizontal: 22);
    } else {
      return EdgeInsets.symmetric(vertical: 16, horizontal: 24);
    }
  }
}
