import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_constants.dart';
import '../../theme/app_theme.dart';
import '../../../state/auth_state.dart';
import '../../../models/user_model.dart';

/// Splash screen with app logo and car-themed loading indicator
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    final authState = AuthState();

    // User state should already be restored from storage in main.dart and AuthState.onInit()
    // No need to call autoLogin again here - it's already done in main.dart
    // Just navigate based on current auth state

    // Navigate to appropriate home based on auth state
    final userRole = authState.currentUser?.role;
    String route;
    if (authState.isAuthenticated) {
      switch (userRole) {
        case UserRole.admin:
          route = AppConstants.routeAdminDashboard;
          break;
        case UserRole.user:
        default:
          route = AppConstants.routeHomeFeature;
      }
    } else {
      route = AppConstants.routeHomeFeature;
    }

    print('Splash: Navigating to $route, isAuthenticated: ${authState.isAuthenticated}, user: ${authState.currentUser?.name ?? "null"}');
    context.go(route);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate responsive sizes with min/max constraints
    final logoSize = (screenWidth * 0.25).clamp(120.0, 200.0);
    final progressSize = (screenWidth * 0.15).clamp(60.0, 100.0);
    final spacing = (screenHeight * 0.08).clamp(40.0, 80.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/videos/sto.gif',
                // fit: BoxFit.cover,
              ),
            ),
            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       // App Logo with Animation
            //       FadeTransition(
            //         opacity: _fadeAnimation,
            //         child: ScaleTransition(
            //           scale: _scaleAnimation,
            //           child: _AppLogo(size: logoSize),
            //         ),
            //       ),
            //       SizedBox(height: spacing),
            //       // Car-themed Progress Indicator
            //       FadeTransition(
            //         opacity: _fadeAnimation,
            //         child: _CarProgressIndicator(size: progressSize),
            //       ),
            //     ],
            //   ),
            // ),
          
          ],
        ),
      ),
    );
  }
}

/// App Logo Widget
// class _AppLogo extends StatelessWidget {
//   final double size;

//   const _AppLogo({required this.size});

//   @override
//   Widget build(BuildContext context) {
//     // Calculate responsive shadow and icon sizes
//     final shadowBlur = size * 0.17;
//     final shadowSpread = size * 0.05;
//     final iconSize = size * 0.4;

//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: AppTheme.redPrimary.withValues(alpha: 0.4),
//             blurRadius: shadowBlur,
//             spreadRadius: shadowSpread,
//           ),
//           BoxShadow(
//             color: AppTheme.redPrimary.withValues(alpha: 0.2),
//             blurRadius: shadowBlur * 1.6,
//             spreadRadius: shadowSpread * 1.9,
//           ),
//         ],
//       ),
//       child: ClipOval(
//         child: Image.asset(
//           'assets/images/rwlogo.png',
//           width: size,
//           height: size,
//           fit: BoxFit.cover,
//           cacheWidth: size.toInt(),
//           cacheHeight: size.toInt(),
//           errorBuilder: (context, error, stackTrace) {
//             // Fallback to icon if image fails to load
//             return Container(
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [AppTheme.redPrimary, AppTheme.redPressed],
//                 ),
//               ),
//               child: Icon(
//                 Icons.directions_car,
//                 size: iconSize,
//                 color: AppTheme.textPrimary,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

/// Car-themed Circular Progress Indicator
class _CarProgressIndicator extends StatefulWidget {
  final double size;

  const _CarProgressIndicator({required this.size});

  @override
  State<_CarProgressIndicator> createState() => _CarProgressIndicatorState();
}

class _CarProgressIndicatorState extends State<_CarProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive sizes
    final innerSize = widget.size * 0.71; // ~50/70 ratio
    final strokeWidth = widget.size * 0.057; // ~4/70 ratio
    final centerIconSize = widget.size * 0.29; // ~20/70 ratio

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating ring with car icons
          RotationTransition(
            turns: _rotationController,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _CarProgressPainter(size: widget.size),
            ),
          ),
          // Inner animated progress indicator
          SizedBox(
            width: innerSize,
            height: innerSize,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.redPrimary,
              ),
              backgroundColor: AppTheme.bgSecondary,
              strokeCap: StrokeCap.round,
            ),
          ),
          // Center car icon
          Icon(
            Icons.directions_car,
            size: centerIconSize,
            color: AppTheme.redPrimary,
          ),
        ],
      ),
    );
  }
}

/// Custom Painter for car-themed progress indicator
class _CarProgressPainter extends CustomPainter {
  final double size;

  const _CarProgressPainter({required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = canvasSize.width / 2 - (size * 0.071); // Responsive margin

    // Draw small car shapes around the circle
    final positions = 8; // Number of car indicators

    // Calculate responsive car dimensions
    final carWidth = size * 0.143; // ~10/70 ratio
    final carHeight = size * 0.071; // ~5/70 ratio
    final carRadius = size * 0.036; // ~2.5/70 ratio
    final windowWidth = size * 0.036; // ~2.5/70 ratio
    final windowHeight = size * 0.029; // ~2/70 ratio
    final wheelRadius = size * 0.014; // ~1/70 ratio

    for (int i = 0; i < positions; i++) {
      final angle = (i * 2 * math.pi) / positions;
      final x = center.dx + radius * 0.8 * math.cos(angle);
      final y = center.dy + radius * 0.8 * math.sin(angle);

      // Draw a simple car shape (rectangle with rounded top)
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + math.pi / 2); // Rotate to face outward

      // Car body with red color
      final carPaint = Paint()
        ..color = AppTheme.redPrimary.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;

      // Main car body
      final carRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: carWidth,
          height: carHeight,
        ),
        Radius.circular(carRadius),
      );
      canvas.drawRRect(carRect, carPaint);

      // Car outline
      final outlinePaint = Paint()
        ..color = AppTheme.redPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.007; // Responsive stroke width
      canvas.drawRRect(carRect, outlinePaint);

      // Car windows
      final windowPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;

      final windowOffset = carWidth * 0.2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(-windowOffset, 0),
            width: windowWidth,
            height: windowHeight,
          ),
          Radius.circular(windowHeight * 0.25),
        ),
        windowPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(windowOffset, 0),
            width: windowWidth,
            height: windowHeight,
          ),
          Radius.circular(windowHeight * 0.25),
        ),
        windowPaint,
      );

      // Car wheels
      final wheelPaint = Paint()
        ..color = Colors.grey.shade700
        ..style = PaintingStyle.fill;

      final wheelOffsetX = carWidth * 0.3;
      final wheelOffsetY = carHeight * 0.5;
      canvas.drawCircle(
        Offset(-wheelOffsetX, wheelOffsetY),
        wheelRadius,
        wheelPaint,
      );
      canvas.drawCircle(
        Offset(wheelOffsetX, wheelOffsetY),
        wheelRadius,
        wheelPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
