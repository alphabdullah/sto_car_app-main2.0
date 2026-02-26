import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auth_state.dart';
import '../../../core/utils/responsive.dart';

/// User profile screen
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.put(AuthState());

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.bgPrimary,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: SafeArea(
        child: Responsive.constrained(
          RefreshIndicator(
            onRefresh: () async {
              await authState.refreshUser();
            },
            color: AppTheme.redPrimary,
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh even when content is short
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section with Gradient
                  Obx(() {
                    final user = authState.currentUser;
                    final isVerified = user?.isVerified ?? false;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.redPrimary.withValues(alpha: 0.2),
                            AppTheme.redPressed.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                        child: Column(
                          children: [
                            // Profile Avatar
                            Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.redPrimary,
                                        AppTheme.redPressed,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.redPrimary.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.bgSecondary,
                                    ),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 60,
                                      color: AppTheme.redPrimary,
                                    ),
                                  ),
                                ),
                                // Verification Badge
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isVerified
                                          ? AppTheme.success
                                          : AppTheme.warning,
                                      border: Border.all(
                                        color: AppTheme.bgSecondary,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isVerified
                                          ? Icons.verified_rounded
                                          : Icons.warning_rounded,
                                      size: 20,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // User Name
                            Text(
                              user?.name ?? 'User',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                                fontFamily: AppTheme.fontFamily,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Email
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Verification Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isVerified
                                      ? [
                                          AppTheme.success,
                                          AppTheme.success.withValues(
                                            alpha: 0.8,
                                          ),
                                        ]
                                      : [
                                          AppTheme.warning,
                                          AppTheme.warning.withValues(
                                            alpha: 0.8,
                                          ),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isVerified
                                                ? AppTheme.success
                                                : AppTheme.warning)
                                            .withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isVerified
                                        ? Icons.verified_rounded
                                        : Icons.warning_rounded,
                                    size: 20,
                                    color: AppTheme.textPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isVerified
                                        ? 'Verified Account'
                                        : 'Unverified Account',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                      fontFamily: AppTheme.fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Account Information Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            fontFamily: AppTheme.fontFamily,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Obx(() {
                          final user = authState.currentUser;
                          return Column(
                            children: [
                              _InfoCard(
                                icon: Icons.email_outlined,
                                iconColor: AppTheme.info,
                                label: 'Email',
                                value: user?.email ?? 'N/A',
                              ),
                              const SizedBox(height: 12),
                              _InfoCard(
                                icon: Icons.badge_outlined,
                                iconColor: AppTheme.warning,
                                label: 'Role',
                                value:
                                    user?.role
                                        .toString()
                                        .split('.')
                                        .last
                                        .capitalizeFirst ??
                                    'User',
                              ),
                              const SizedBox(height: 12),
                              _InfoCard(
                                icon: Icons.calendar_today_outlined,
                                iconColor: AppTheme.redPrimary,
                                label: 'Member Since',
                                value: user?.createdAt != null
                                    ? user!.createdAt!.toString().split(' ')[0]
                                    : 'N/A',
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  Obx(() {
                    final user = authState.currentUser;
                    final front = user?.registrationImageFront;
                    final back = user?.registrationImageBack;
                    if (front == null && back == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emirates ID',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              fontFamily: AppTheme.fontFamily,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildIdImageCard(
                                  context,
                                  label: 'Front Side',
                                  imageUrl: front,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildIdImageCard(
                                  context,
                                  label: 'Back Side',
                                  imageUrl: back,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.redPrimary, AppTheme.redPressed],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.redPrimary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showLogoutDialog(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: AppTheme.textPrimary,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  AppStrings.logout,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                    fontFamily: AppTheme.fontFamily,
                                    letterSpacing: 0.5,
                                  ),
                                ),
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
        ),
      ),
      bottomNavigationBar: const RoleBottomNav(currentIndex: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.bgSecondary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.redPrimary.withValues(alpha: 0.2),
                        AppTheme.redPressed.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.redPrimary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 32,
                    color: AppTheme.redPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.bgElevated,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.border,
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              child: Text(
                                AppStrings.cancel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.redPrimary, AppTheme.redPressed],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.redPrimary.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final authState = AuthState();
                              await authState.logout();
                              if (context.mounted) {
                                Navigator.pop(context);
                                context.go(AppConstants.routeHomeFeature);
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              child: Text(
                                AppStrings.logout,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdImageCard(
    BuildContext context, {
    required String label,
    String? imageUrl,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppTheme.bgElevated,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(AppTheme.redPrimary),
                              value:
                                  progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIdImagePlaceholder();
                      },
                    )
                  : _buildIdImagePlaceholder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdImagePlaceholder() {
    return Container(
      color: AppTheme.bgElevated,
      child: Center(
        child: Icon(
          Icons.document_scanner_outlined,
          size: 36,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }
}

/// Info Card Widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withValues(alpha: 0.2),
                  iconColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTheme.fontFamily,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
