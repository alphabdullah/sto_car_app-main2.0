import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/signup_controller.dart';

/// Signup screen (MVC pattern - View layer)
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
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

    Widget buildDocumentUploadCard({
      required String label,
      required Uint8List? imageData,
      required VoidCallback onTap,
    }) {
      final cardHeight = isTablet
          ? 200.0
          : isLargeMobile
          ? 180.0
          : isMediumMobile
          ? 170.0
          : 160.0;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppTheme.bgSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border.withOpacity(0.8)),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageData != null
                      ? Image.memory(
                          imageData,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.bgElevated,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 32,
                                  color: AppTheme.textMuted,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to upload',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppTheme.textPrimary,
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

              // Icon and Create Account Text - Left aligned at top
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
                    'Create Account',
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

              // Name Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: isTablet
                        ? 18.0
                        : isLargeMobile
                        ? 16.0
                        : isMediumMobile
                        ? 15.0
                        : 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
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

              // Name field - no Obx needed, no observables used
              TextField(
                onChanged: controller.setName,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: AppTheme.fontFamily,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppTheme.textMuted,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.redPrimary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppTheme.bgSecondary,
                  hintStyle: TextStyle(
                    color: AppTheme.textMuted,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
                textInputAction: TextInputAction.next,
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

              // Email Label
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
                    color: AppTheme.textPrimary,
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

              // Email field - Obx only for error message
              Obx(() {
                final errorMsg = controller.errorMessage;
                final hasEmailError = errorMsg?.contains('email') == true;
                return TextField(
                  onChanged: controller.setEmail,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  decoration: InputDecoration(
                    hintText: 'example@email.com',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppTheme.textMuted,
                    ),
                    errorText: hasEmailError ? errorMsg : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.redPrimary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppTheme.bgSecondary,
                    hintStyle: TextStyle(
                      color: AppTheme.textMuted,
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

              // Phone Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: isTablet
                        ? 18.0
                        : isLargeMobile
                        ? 16.0
                        : isMediumMobile
                        ? 15.0
                        : 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
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

              // Phone field - Obx only for error message
              Obx(() {
                final errorMsg = controller.errorMessage;
                final hasPhoneError = errorMsg?.contains('phone') == true;
                return TextField(
                  onChanged: controller.setPhone,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number',
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppTheme.textMuted,
                    ),
                    errorText: hasPhoneError ? errorMsg : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.redPrimary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppTheme.bgSecondary,
                    hintStyle: TextStyle(
                      color: AppTheme.textMuted,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
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
                  'Password',
                  style: TextStyle(
                    fontSize: isTablet
                        ? 18.0
                        : isLargeMobile
                        ? 16.0
                        : isMediumMobile
                        ? 15.0
                        : 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
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

              // Password field - Obx only for error message and visibility
              Obx(() {
                final errorMsg = controller.errorMessage;
                final hasPasswordError = errorMsg?.contains('password') == true;
                final isPasswordVisible = controller.isPasswordVisible;
                return TextField(
                  onChanged: controller.setPassword,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppTheme.textMuted,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.textMuted,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    errorText: hasPasswordError ? errorMsg : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.redPrimary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppTheme.bgSecondary,
                    hintStyle: TextStyle(
                      color: AppTheme.textMuted,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  obscureText: !isPasswordVisible,
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

              // Confirm Password Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: isTablet
                        ? 18.0
                        : isLargeMobile
                        ? 16.0
                        : isMediumMobile
                        ? 15.0
                        : 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
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

              // Confirm Password field - Obx only for error message and visibility
              Obx(() {
                final errorMsg = controller.errorMessage;
                final hasMatchError = errorMsg?.contains('match') == true;
                final isConfirmPasswordVisible =
                    controller.isConfirmPasswordVisible;
                return TextField(
                  onChanged: controller.setConfirmPassword,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppTheme.textMuted,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.textMuted,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                    errorText: hasMatchError ? errorMsg : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.redPrimary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppTheme.bgSecondary,
                    hintStyle: TextStyle(
                      color: AppTheme.textMuted,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  obscureText: !isConfirmPasswordVisible,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => controller.signup(context),
                );
              }),

              SizedBox(
                height: isTablet
                    ? 22.0
                    : isLargeMobile
                    ? 18.0
                    : isMediumMobile
                    ? 16.0
                    : 14.0,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upload Emirates ID',
                  style: TextStyle(
                    fontSize: isTablet
                        ? 18.0
                        : isLargeMobile
                        ? 16.0
                        : isMediumMobile
                        ? 15.0
                        : 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Please upload both the front and back of your Emirates Card for verification.',
                style: TextStyle(
                  fontSize: isTablet
                      ? 16.0
                      : isLargeMobile
                      ? 15.0
                      : isMediumMobile
                      ? 14.0
                      : 13.0,
                  color: AppTheme.textMuted,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              SizedBox(
                height: isTablet
                    ? 16.0
                    : isLargeMobile
                    ? 14.0
                    : isMediumMobile
                    ? 12.0
                    : 10.0,
              ),

              Obx(
                () {
                  final uploadSpacing =
                      isTablet ? 24.0 : isLargeMobile ? 16.0 : 12.0;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: buildDocumentUploadCard(
                          label: 'Front Side',
                          imageData: controller.registrationImageFront,
                          onTap: () => controller.pickRegistrationImageFront(),
                        ),
                      ),
                      SizedBox(width: uploadSpacing),
                      Expanded(
                        child: buildDocumentUploadCard(
                          label: 'Back Side',
                          imageData: controller.registrationImageBack,
                          onTap: () => controller.pickRegistrationImageBack(),
                        ),
                      ),
                    ],
                  );
                },
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

              // Signup Button - More Attractive
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
                        : () => controller.signup(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppTheme.textPrimary,
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
                                AppTheme.textPrimary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_add, size: 22),
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
                                AppStrings.signup,
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

              // Already have an account? Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: AppTheme.textMuted,
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
