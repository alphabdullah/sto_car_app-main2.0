import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/forgot_password_controller.dart';

/// Forgot password screen (MVC pattern - View layer)
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(ForgotPasswordController());
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isTablet = screenWidth > 768;
    final isLargeMobile = screenWidth > 600 && screenWidth <= 768;
    final isMediumMobile = screenWidth > 360 && screenWidth <= 600;

    // Responsive sizing
    final iconSize = isTablet
        ? 80.0
        : isLargeMobile
        ? 70.0
        : isMediumMobile
        ? 60.0
        : 50.0;

    final titleFontSize = isTablet
        ? 32.0
        : isLargeMobile
        ? 28.0
        : isMediumMobile
        ? 24.0
        : 22.0;

    final spacing = isTablet
        ? 48.0
        : isLargeMobile
        ? 32.0
        : isMediumMobile
        ? 24.0
        : 16.0;

    final horizontalPadding = isTablet
        ? screenWidth * 0.2
        : isLargeMobile
        ? screenWidth * 0.15
        : isMediumMobile
        ? screenWidth * 0.1
        : 24.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: spacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back Button at top left
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),

              SizedBox(
                height: isTablet
                    ? 16.0
                    : isLargeMobile
                    ? 12.0
                    : isMediumMobile
                    ? 10.0
                    : 8.0,
              ),

              // Icon and Forgot Password Text - Left aligned at top
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/rwlogo.png',
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                    cacheWidth: iconSize.toInt(),
                    cacheHeight: iconSize.toInt(),
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.directions_car,
                        size: iconSize,
                        color: AppTheme.redPrimary,
                      );
                    },
                  ),
                  SizedBox(
                    width: isTablet
                        ? 16.0
                        : isLargeMobile
                        ? 14.0
                        : isMediumMobile
                        ? 12.0
                        : 10.0,
                  ),
                  Expanded(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: titleFontSize * 1.2, // Bigger size
                        fontWeight: FontWeight.w700,
                        color: AppTheme.redPrimary,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: isTablet
                    ? 50.0
                    : isLargeMobile
                    ? 40.0
                    : isMediumMobile
                    ? 35.0
                    : 30.0,
              ),

              // Description Text
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: TextStyle(
                  fontSize: isTablet
                      ? 16.0
                      : isLargeMobile
                      ? 15.0
                      : isMediumMobile
                      ? 14.0
                      : 13.0,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: AppTheme.fontFamily,
                ),
                textAlign: TextAlign.left,
              ),

              SizedBox(
                height: isTablet
                    ? 32.0
                    : isLargeMobile
                    ? 28.0
                    : isMediumMobile
                    ? 24.0
                    : 20.0,
              ),

              // Email Address Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: isTablet
                        ? 18.0
                        : isLargeMobile
                        ? 16.0
                        : isMediumMobile
                        ? 15.0
                        : 14.0,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),

              SizedBox(
                height: isTablet
                    ? 12.0
                    : isLargeMobile
                    ? 10.0
                    : isMediumMobile
                    ? 8.0
                    : 6.0,
              ),

              // Email Address Field
              Obx(() {
                final errorMsg = controller.errorMessage;
                return TextField(
                  onChanged: controller.setEmail,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  decoration: InputDecoration(
                    hintText: 'example@email.com',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: theme.colorScheme.outline,
                    ),
                    errorText: errorMsg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.redPrimary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.outline,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => controller.resetPassword(context),
                );
              }),

              SizedBox(
                height: isTablet
                    ? 32.0
                    : isLargeMobile
                    ? 28.0
                    : isMediumMobile
                    ? 24.0
                    : 20.0,
              ),

              // Reset Password Button - More Attractive
              Obx(
                () => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.redPrimary, AppTheme.redPressed],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.redPrimary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.resetPassword(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet
                            ? 18.0
                            : isLargeMobile
                            ? 16.0
                            : isMediumMobile
                            ? 15.0
                            : 14.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.email_outlined, size: 22),
                              SizedBox(
                                width: isTablet
                                    ? 12.0
                                    : isLargeMobile
                                    ? 10.0
                                    : isMediumMobile
                                    ? 8.0
                                    : 6.0,
                              ),
                              Text(
                                'Send Reset Link',
                                style: TextStyle(
                                  fontSize: isTablet
                                      ? 18.0
                                      : isLargeMobile
                                      ? 17.0
                                      : isMediumMobile
                                      ? 16.0
                                      : 15.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              SizedBox(
                height: isTablet
                    ? 24.0
                    : isLargeMobile
                    ? 20.0
                    : isMediumMobile
                    ? 18.0
                    : 16.0,
              ),

              // Back to Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remember your password? ",
                    style: TextStyle(
                      color: theme.colorScheme.outline,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      AppStrings.login,
                      style: TextStyle(
                        color: AppTheme.redPrimary,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: isTablet
                    ? 24.0
                    : isLargeMobile
                    ? 20.0
                    : isMediumMobile
                    ? 18.0
                    : 16.0,
              ),

              // Error Message Display
              Obx(
                () => controller.errorMessage != null
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppTheme.error,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage!,
                                style: const TextStyle(
                                  color: AppTheme.error,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
