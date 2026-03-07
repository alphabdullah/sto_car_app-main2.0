import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../controller/login_controller.dart';

/// Login screen (MVC pattern - View layer)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(LoginController());
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

    final padding = isTablet
        ? 32.0
        : isLargeMobile
        ? 28.0
        : isMediumMobile
        ? 24.0
        : 20.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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

                // Icon and Welcome Back Text - Left aligned at top
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
                    Text(
                      AppLocalizations.of(context)!.welcomeBack,
                      style: TextStyle(
                        fontSize: titleFontSize * 1.2, // Bigger size
                        fontWeight: FontWeight.w700,
                        color: AppTheme.redPrimary,
                        fontFamily: AppTheme.fontFamily,
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

                // Email Address Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.emailAddress,
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
                  final hasEmailError = errorMsg?.contains('email') == true;
                  return TextField(
                    onChanged: controller.setEmail,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.emailHint,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: theme.colorScheme.outline,
                      ),
                      errorText: hasEmailError ? errorMsg : null,
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
                    textInputAction: TextInputAction.next,
                  );
                }),

                SizedBox(
                  height: isTablet
                      ? 24.0
                      : isLargeMobile
                      ? 20.0
                      : isMediumMobile
                      ? 18.0
                      : 16.0,
                ),

                // Password Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.password,
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

                // Password Field
                Obx(() {
                  final errorMsg = controller.errorMessage;
                  final hasPasswordError =
                      errorMsg?.contains('password') == true;
                  final isPasswordVisible = controller.isPasswordVisible;
                  return TextField(
                    onChanged: controller.setPassword,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.passwordHint,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: theme.colorScheme.outline,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: theme.colorScheme.outline,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      errorText: hasPasswordError ? errorMsg : null,
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
                    obscureText: !isPasswordVisible,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.login(context),
                  );
                }),

                SizedBox(
                  height: isTablet
                      ? 8.0
                      : isLargeMobile
                      ? 6.0
                      : isMediumMobile
                      ? 5.0
                      : 4.0,
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push(AppConstants.routeForgotPassword);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.forgotPassword,
                      style: TextStyle(
                        color: AppTheme.redPrimary,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ),
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

                // Login Button - More Attractive
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
                          : () => controller.login(context),
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
                                const Icon(Icons.login, size: 22),
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
                                  AppLocalizations.of(context)!.login,
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

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dontHaveAccount,
                      style: TextStyle(
                        color: theme.colorScheme.outline,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(AppConstants.routeSignup);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                        style: TextStyle(
                          color: AppTheme.redPrimary,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),

                // Error Message
                Obx(
                  () => controller.errorMessage != null
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: isTablet
                                ? 24.0
                                : isLargeMobile
                                ? 20.0
                                : isMediumMobile
                                ? 18.0
                                : 16.0,
                          ),
                          child: Container(
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
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
