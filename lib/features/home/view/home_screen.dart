import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auth_state.dart';
import '../../../state/theme_state.dart';
import '../../../state/auction_state.dart';
import '../../../state/parts_state.dart';
import '../../../state/notification_state.dart';
import '../../auctions/widgets/auction_card.dart';
import '../../../core/utils/responsive.dart';

/// Unified home screen for both guest and logged-in users
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final authState = Get.find<AuthState>();
      final auctionState = Get.find<AuctionState>();
      final partsState = Get.find<PartsState>();

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: Obx(
          () => authState.isAuthenticated
              ? _buildDrawer(context, authState)
              : const SizedBox.shrink(),
        ),
        body: SafeArea(
          child: Responsive.constrained(
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isSmallScreen = screenWidth < 360;
                      final verticalSpacing = isSmallScreen ? 12.0 : 20.0;
                      final horizontalPadding = isSmallScreen ? 16.0 : 20.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: verticalSpacing),

                          // Custom Header Row
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: _CustomHeader(authState: authState),
                          ),

                          SizedBox(height: verticalSpacing),

                          // Search Bar
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: _SearchBar(),
                          ),

                          SizedBox(height: isSmallScreen ? 24.0 : 32.0),

                          // Section Title
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Text(
                              'Explore Categories',
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: isSmallScreen ? 20.0 : null,
                                  ),
                            ),
                          ),

                          SizedBox(height: verticalSpacing),

                          // Content Cards Section - Wrap in try-catch for safety
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: _ContentCardsSection(
                              auctionState: auctionState,
                              partsState: partsState,
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 32.0 : 40.0),

                          // Live Auctions Preview
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: horizontalPadding,
                          //   ),
                          //   child: _LiveAuctionsPreview(
                          //     auctionState: auctionState,
                          //   ),
                          // ),
                        ],
                      );
                    },
                  ),

                  // Bottom Login/Signup Buttons (for non-authenticated users)
                  Obx(
                    () => !authState.isAuthenticated
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth = MediaQuery.of(
                                context,
                              ).size.width;
                              final isSmallScreen = screenWidth < 360;
                              return Column(
                                children: [
                                  SizedBox(height: isSmallScreen ? 16.0 : 24.0),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 16.0 : 20.0,
                                    ),
                                    child: _AuthButtonsRow(),
                                  ),
                                  SizedBox(height: isSmallScreen ? 64.0 : 80.0),
                                ],
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => authState.isAuthenticated
              ? const RoleBottomNav(currentIndex: 0)
              : const SizedBox.shrink(),
        ),
      );
    } catch (e) {
      // Fallback UI if there's an error
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('STO - Car Marketplace')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading home screen: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Try to reload
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildDrawer(BuildContext context, AuthState authState) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          // Enhanced Header
          _DrawerHeader(authState: authState),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerMenuItem(
                  icon: Icons.home_rounded,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppConstants.routeHomeFeature);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.gavel,
                  title: AppStrings.auctions,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppConstants.routeAuctions);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.build_rounded,
                  title: AppStrings.parts,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppConstants.routeParts);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.calendar_today_rounded,
                  title: AppStrings.booking,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppConstants.routeBookings);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.account_balance_wallet_rounded,
                  title: AppStrings.wallet,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppConstants.routeWallet);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.person_rounded,
                  title: AppStrings.profile,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppConstants.routeProfile);
                  },
                ),
                const SizedBox(height: 8),
                Divider(
                  color: theme.dividerColor,
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 8),
                _DrawerThemeSection(),
                const SizedBox(height: 8),
                Divider(
                  color: theme.dividerColor,
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 8),
                _DrawerMenuItem(
                  icon: Icons.logout_rounded,
                  title: AppStrings.logout,
                  isDestructive: true,
                  onTap: () async {
                    await authState.logout();
                    if (context.mounted) {
                      Navigator.pop(context);
                      context.go(AppConstants.routeHomeFeature);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Enhanced Drawer Header
class _DrawerHeader extends StatelessWidget {
  final AuthState authState;

  const _DrawerHeader({required this.authState});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.redPrimary, AppTheme.redPressed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo - Centered and prominent
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/rwlogo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.redPrimary,
                                AppTheme.redPressed,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.directions_car,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // User Name - Centered
              Obx(() {
                final user = authState.currentUser;
                return Center(
                  child: Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),

              // User Email - Centered
              Obx(() {
                final user = authState.currentUser;
                return Center(
                  child: Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Verification Badge - Centered
              Obx(() {
                final isVerified = authState.isVerified;
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVerified ? Icons.verified : Icons.pending_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isVerified ? 'Verified Account' : 'Not Verified',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Theme option in drawer: Light, Dark, System
class _DrawerThemeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Theme',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
                fontFamily: AppTheme.fontFamily,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Obx(() {
            final themeState = Get.find<ThemeState>();
            final current = themeState.themeMode;
            return Column(
              children: [
                _ThemeOptionTile(
                  icon: Icons.light_mode_rounded,
                  title: 'Light',
                  isSelected: current == ThemeMode.light,
                  onTap: () => themeState.setLight(),
                ),
                _ThemeOptionTile(
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark',
                  isSelected: current == ThemeMode.dark,
                  onTap: () => themeState.setDark(),
                ),
                _ThemeOptionTile(
                  icon: Icons.settings_brightness_rounded,
                  title: 'System',
                  isSelected: current == ThemeMode.system,
                  onTap: () => themeState.setSystem(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: isSelected ? primaryColor : textColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle_rounded, color: primaryColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

/// Enhanced Drawer Menu Item
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = isDestructive
        ? AppTheme.redPrimary
        : theme.colorScheme.onSurface;
    final textColor = isDestructive
        ? AppTheme.redPrimary
        : theme.colorScheme.onSurface;
    final bgColor = isDestructive
        ? AppTheme.redPrimary.withValues(alpha: 0.1)
        : theme.colorScheme.surface;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDestructive
                          ? [
                              AppTheme.redPrimary.withValues(alpha: 0.25),
                              AppTheme.redPressed.withValues(alpha: 0.25),
                            ]
                          : [
                              AppTheme.redPrimary.withValues(alpha: 0.15),
                              AppTheme.redPressed.withValues(alpha: 0.15),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontFamily,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Header Row - Welcome Back, Logo, Notification
class _CustomHeader extends StatelessWidget {
  final AuthState authState;

  const _CustomHeader({required this.authState});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final isTablet = screenWidth > 768;

    // Responsive sizes - bigger for better visibility
    final iconSize = isSmallScreen
        ? 28.0
        : (isMediumScreen ? 32.0 : (isTablet ? 36.0 : 30.0));
    final fontSize = isSmallScreen
        ? 18.0
        : (isMediumScreen ? 22.0 : (isTablet ? 26.0 : 24.0));
    final iconSpacing = isSmallScreen ? 6.0 : (isTablet ? 12.0 : 8.0);
    final menuIconSize = isSmallScreen ? 22.0 : (isTablet ? 28.0 : 26.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Welcome Back text and Menu button (if authenticated)
            Expanded(
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (authState.isAuthenticated)
                      IconButton(
                        icon: Icon(
                          Icons.menu_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: menuIconSize,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    if (authState.isAuthenticated)
                      SizedBox(width: isSmallScreen ? 4.0 : 8.0),
                    Flexible(
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontFamily: AppTheme.fontFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right side: Language and Notification icons
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Language icon with dropdown
                _LanguageSelector(iconSize: iconSize),
                SizedBox(width: iconSpacing),
                // Notification icon
                Obx(() {
                  final notificationState = Get.put(NotificationState());
                  final unreadCount = notificationState.unreadCount;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 40 : (isTablet ? 56 : 48),
                          minHeight: isSmallScreen ? 40 : (isTablet ? 56 : 48),
                        ),
                        icon: Image.asset(
                          'assets/images/notification.png',
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.notifications_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: iconSize,
                            );
                          },
                        ),
                        onPressed: authState.isAuthenticated
                            ? () {
                                context.push(AppConstants.routeNotifications);
                              }
                            : null,
                      ),
                      if (authState.isAuthenticated && unreadCount > 0)
                        Positioned(
                          right: isSmallScreen ? 4 : (isTablet ? 8 : 6),
                          top: isSmallScreen ? 4 : (isTablet ? 8 : 6),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.redPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 9 ? '9+' : '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTheme.fontFamily,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Language Selector with Attractive Dropdown
class _LanguageSelector extends StatefulWidget {
  final double iconSize;

  const _LanguageSelector({this.iconSize = 28.0});

  @override
  State<_LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<_LanguageSelector> {
  String _selectedLanguage = 'English';
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'ar', 'name': 'Arabic', 'native': 'العربية'},
    {'code': 'fr', 'name': 'French', 'native': 'Français'},
    {'code': 'es', 'name': 'Spanish', 'native': 'Español'},
  ];

  double get iconSize => widget.iconSize;

  void _showLanguageDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height + 8,
        overlay.size.width - position.dx - button.size.width,
        overlay.size.height - position.dy - button.size.height - 8,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surfaceContainerHighest,
      elevation: 8,
      items: _languages.map((language) {
        final isSelected = _selectedLanguage == language['name'];
        return PopupMenuItem<String>(
          value: language['code'],
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      language['code']!.toUpperCase(),
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language['name']!,
                        style: TextStyle(
                          color: isSelected
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      if (language['native'] != language['name'])
                        Text(
                          language['native']!,
                          style: TextStyle(
                            color: theme.colorScheme.outline,
                            fontSize: 12,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedLanguage = _languages.firstWhere(
            (lang) => lang['code'] == value,
          )['name']!;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $_selectedLanguage'),
            backgroundColor: theme.colorScheme.surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 768;

    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: isSmallScreen ? 40 : (isTablet ? 56 : 48),
        minHeight: isSmallScreen ? 40 : (isTablet ? 56 : 48),
      ),
      icon: Image.asset(
        'assets/images/language.png',
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.language_rounded,
            color: theme.colorScheme.onSurface,
            size: iconSize,
          );
        },
      ),
      onPressed: () => _showLanguageDropdown(context),
    );
  }
}

/// Search Bar Widget
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for Vehicles, Parts, Services...',
          hintStyle: TextStyle(
            color: theme.colorScheme.outline,
            fontSize: 15,
            fontFamily: AppTheme.fontFamily,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
            size: 22,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 15,
          fontFamily: AppTheme.fontFamily,
        ),
        onSubmitted: (value) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Searching for: $value')));
        },
      ),
    );
  }
}

/// Content Cards Section - 4 specific cards in responsive 2x2 grid
class _ContentCardsSection extends StatelessWidget {
  final AuctionState auctionState;
  final PartsState partsState;

  const _ContentCardsSection({
    required this.auctionState,
    required this.partsState,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 2);
    final cardSpacing = isDesktop ? 30.0 : (isTablet ? 24.0 : 16.0);
    final verticalSpacing = isDesktop ? 30.0 : (isTablet ? 24.0 : 20.0);

    return Obx(() {
      try {
        final auctions = auctionState.auctions;
        final companies = partsState.companies;

        final liveAuctionsCount = auctions
            .toList()
            .where((a) => a.isLive)
            .length;
        final companiesCount = companies.length;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: cardSpacing,
          mainAxisSpacing: verticalSpacing,
          childAspectRatio: isDesktop ? 1.0 : (isTablet ? 0.9 : 0.8),
          children: [
            _CarAuctionsCard(auctionsCount: liveAuctionsCount),
            _STOPerformanceCard(),
            _PerformancePartsCard(partsCount: companiesCount),
            _GetVerifiedCard(),
          ],
        );
      } catch (e) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: cardSpacing,
          mainAxisSpacing: verticalSpacing,
          childAspectRatio: isDesktop ? 1.0 : (isTablet ? 0.9 : 0.8),
          children: [
            _CarAuctionsCard(auctionsCount: 0),
            _STOPerformanceCard(),
            _PerformancePartsCard(partsCount: 0),
            _GetVerifiedCard(),
          ],
        );
      }
    });
  }
}

/// Car Auctions Card
class _CarAuctionsCard extends StatelessWidget {
  final int auctionsCount;

  const _CarAuctionsCard({required this.auctionsCount});

  @override
  Widget build(BuildContext context) {
    return _FeatureCard(
      title: 'Car Auctions',
      subtitle: '$auctionsCount live auctions',
      iconImage: 'assets/images/auction.png',
      iconColor: AppTheme.redPrimary,
      showIconBackground: false,
      badgeText: '$auctionsCount',
      onTap: () => context.push(AppConstants.routeAuctions),
      buttonColor: AppTheme.redPrimary,
    );
  }
}

/// STO Performance Card (for booking)
class _STOPerformanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    return _FeatureCard(
      title: 'STO Performance',
      subtitle: 'Book a service',
      iconImage: 'assets/images/calendar.png',
      iconColor: Colors.blue.shade700,
      showIconBackground: false,
      onTap: () {
        if (authState.isAuthenticated) {
          context.push(AppConstants.routeBookings);
        } else {
          context.push(AppConstants.routeLogin);
        }
      },
      buttonColor: AppTheme.redPrimary,
    );
  }
}

/// Performance Parts Card
class _PerformancePartsCard extends StatelessWidget {
  final int partsCount;

  const _PerformancePartsCard({required this.partsCount});

  @override
  Widget build(BuildContext context) {
    return _FeatureCard(
      title: 'Performance Parts',
      subtitle: '$partsCount companies',
      iconImage: 'assets/images/repair.png',
      iconColor: Colors.purple.shade700,
      showIconBackground: false,
      badgeText: '$partsCount',
      onTap: () => context.push(AppConstants.routeParts),
      buttonColor: AppTheme.redPrimary,
    );
  }
}

/// Get Verified Card
class _GetVerifiedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    return Obx(() {
      final isVerified = authState.isVerified;
      return _FeatureCard(
        title: 'Get Verified',
        subtitle: isVerified ? 'Account verified' : 'Verify your account',
        iconImage: 'assets/images/verify.png',
        iconColor: isVerified ? Colors.green.shade700 : Colors.orange.shade700,
        showIconBackground: false,
        onTap: () {
          if (authState.isAuthenticated) {
            context.push(AppConstants.routeWallet);
          } else {
            context.push(AppConstants.routeLogin);
          }
        },
        buttonColor: AppTheme.redPrimary,
      );
    });
  }
}

/// Feature Card Widget - Icon on top, button to navigate
class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? iconImage;
  final Color iconColor;
  final String? badgeText;
  final VoidCallback onTap;
  final Color buttonColor;
  final bool showIconBackground;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    this.icon,
    this.iconImage,
    required this.iconColor,
    this.badgeText,
    required this.onTap,
    required this.buttonColor,
    this.showIconBackground = false,
  }) : assert(
         icon != null || iconImage != null,
         'Either icon or iconImage must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isTablet = screenWidth > 768;
    final isLargeMobile = screenWidth > 600 && screenWidth <= 768;
    final isMediumMobile = screenWidth > 360 && screenWidth <= 600;

    // Responsive icon size - larger without background container
    final iconSize = isTablet
        ? 80.0
        : isLargeMobile
        ? 72.0
        : isMediumMobile
        ? 64.0
        : 56.0;

    // Responsive font sizes
    final titleFontSize = isTablet
        ? 18.0
        : isLargeMobile
        ? 16.0
        : isMediumMobile
        ? 14.0
        : 13.0;

    final subtitleFontSize = isTablet
        ? 14.0
        : isLargeMobile
        ? 13.0
        : isMediumMobile
        ? 12.0
        : 11.0;

    // Responsive padding
    final cardPadding = isTablet
        ? 14.0
        : isLargeMobile
        ? 12.0
        : isMediumMobile
        ? 10.0
        : 8.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            constraints: const BoxConstraints(minHeight: 220),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main content - Column layout with icon on top
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top section: Icon and Title
                      Flexible(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon or Image on top - larger without background container
                            iconImage != null
                                ? SizedBox(
                                    width: iconSize,
                                    height: iconSize,
                                    child: Image.asset(
                                      iconImage!,
                                      width: iconSize,
                                      height: iconSize,
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                      cacheWidth:
                                          (iconSize *
                                                  MediaQuery.of(
                                                    context,
                                                  ).devicePixelRatio)
                                              .round(),
                                      cacheHeight:
                                          (iconSize *
                                                  MediaQuery.of(
                                                    context,
                                                  ).devicePixelRatio)
                                              .round(),
                                      errorBuilder: (context, error, stackTrace) {
                                        // Fallback to icon if image fails to load
                                        debugPrint(
                                          'Error loading image: $iconImage',
                                        );
                                        debugPrint('Error: $error');
                                        return Icon(
                                          icon ?? Icons.image_not_supported,
                                          size: iconSize,
                                          color: theme.colorScheme.onSurface,
                                        );
                                      },
                                    ),
                                  )
                                : Icon(
                                    icon,
                                    size: iconSize,
                                    color: theme.colorScheme.onSurface,
                                  ),

                            SizedBox(
                              height: isTablet
                                  ? 10.0
                                  : isLargeMobile
                                  ? 8.0
                                  : isMediumMobile
                                  ? 6.0
                                  : 4.0,
                            ),

                            // Title
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: titleFontSize + 1,
                                color: theme.colorScheme.onSurface,
                                letterSpacing: -0.3,
                                height: 1.2,
                                fontFamily: AppTheme.fontFamily,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(
                              height: isTablet
                                  ? 4.0
                                  : isLargeMobile
                                  ? 3.0
                                  : isMediumMobile
                                  ? 2.0
                                  : 2.0,
                            ),

                            // Subtitle
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                                height: 1.3,
                                fontFamily: AppTheme.fontFamily,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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

                      // Bottom section: Button - Elegant navigation button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: isTablet
                                    ? 12.0
                                    : isLargeMobile
                                    ? 11.0
                                    : isMediumMobile
                                    ? 10.0
                                    : 9.0,
                                horizontal: isTablet
                                    ? 16.0
                                    : isLargeMobile
                                    ? 14.0
                                    : isMediumMobile
                                    ? 12.0
                                    : 10.0,
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 18.0,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge in top right
                if (badgeText != null)
                  Positioned(
                    top: cardPadding * 0.6,
                    right: cardPadding * 0.6,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet
                            ? 10.0
                            : isLargeMobile
                            ? 9.0
                            : isMediumMobile
                            ? 8.0
                            : 7.0,
                        vertical: isTablet
                            ? 6.0
                            : isLargeMobile
                            ? 5.0
                            : isMediumMobile
                            ? 4.0
                            : 3.0,
                      ),
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
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet
                              ? 12.0
                              : isLargeMobile
                              ? 11.0
                              : isMediumMobile
                              ? 10.0
                              : 9.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Authentication Buttons Row
class _AuthButtonsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.redPrimary,
                  AppTheme.redPressed,
                  AppTheme.redPrimary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.redPrimary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppTheme.redPrimary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push(AppConstants.routeLogin),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        AppStrings.login,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.fontFamily,
                          color: Colors.white,
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
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.redPrimary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.redPrimary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push(AppConstants.routeSignup),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_add_rounded,
                        size: 22,
                        color: AppTheme.redPrimary,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.redPrimary,
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
    );
  }
}

/// Live Auctions Preview Section
class _LiveAuctionsPreview extends StatelessWidget {
  final AuctionState auctionState;

  const _LiveAuctionsPreview({required this.auctionState});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final liveAuctions = auctionState.liveAuctions;

      if (liveAuctions.isEmpty && !auctionState.isLoading) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Auctions',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppConstants.routeAuctions),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppTheme.redPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppTheme.redPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (auctionState.isLoading && liveAuctions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: AppTheme.redPrimary),
              ),
            )
          else
            Responsive(
              mobile: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: liveAuctions.length > 3 ? 3 : liveAuctions.length,
                itemBuilder: (context, index) {
                  final auction = liveAuctions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AuctionCard(
                      auction: auction,
                      onTap: () => context.push(
                        '${AppConstants.routeAuctions}/${auction.id}',
                        extra: auction,
                      ),
                      showBidButton: false,
                    ),
                  );
                },
              ),
              tablet: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: liveAuctions.length > 4 ? 4 : liveAuctions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 180,
                ),
                itemBuilder: (context, index) {
                  final auction = liveAuctions[index];
                  return AuctionCard(
                    auction: auction,
                    onTap: () => context.push(
                      '${AppConstants.routeAuctions}/${auction.id}',
                      extra: auction,
                    ),
                    showBidButton: false,
                  );
                },
              ),
              desktop: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: liveAuctions.length > 6 ? 6 : liveAuctions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 190,
                ),
                itemBuilder: (context, index) {
                  final auction = liveAuctions[index];
                  return AuctionCard(
                    auction: auction,
                    onTap: () => context.push(
                      '${AppConstants.routeAuctions}/${auction.id}',
                      extra: auction,
                    ),
                    showBidButton: false,
                  );
                },
              ),
            ),
        ],
      );
    });
  }
}
