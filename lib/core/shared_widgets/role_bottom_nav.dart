import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../state/auth_state.dart';
import '../../models/user_model.dart';
import '../constants/app_constants.dart';
import '../constants/app_strings.dart';
import '../theme/app_theme.dart';

/// Role-aware glassmorphic bottom navigation bar
class RoleBottomNav extends StatelessWidget {
  final int currentIndex;

  const RoleBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    final userRole = authState.currentUser?.role;

    if (userRole == UserRole.admin) {
      return _buildAdminNav(context);
    } else {
      return _buildUserNav(context);
    }
  }

  Widget _buildUserNav(BuildContext context) {
    final items = [
      _NavItem(
        icon: Icons.home,
        label: AppStrings.home,
        route: AppConstants.routeHomeFeature,
      ),
      _NavItem(
        icon: Icons.calendar_today,
        label: AppStrings.booking,
        route: AppConstants.routeBookings,
      ),
      _NavItem(
        icon: Icons.gavel,
        label: AppStrings.auctions,
        route: AppConstants.routeAuctions,
      ),
      _NavItem(
        icon: Icons.build,
        label: AppStrings.parts,
        route: AppConstants.routeParts,
      ),
      _NavItem(
        icon: Icons.person,
        label: AppStrings.profile,
        route: AppConstants.routeProfile,
      ),
    ];

    return _GlassmorphicNavBar(
      currentIndex: currentIndex,
      items: items,
    );
  }

  Widget _buildAdminNav(BuildContext context) {
    final items = [
      _NavItem(
        icon: Icons.dashboard,
        label: AppStrings.dashboard,
        route: AppConstants.routeAdminDashboard,
      ),
      _NavItem(
        imagePath: 'assets/images/auction.jpg',
        label: AppStrings.auctions,
        route: AppConstants.routeAdminAuctions,
      ),
      _NavItem(
        icon: Icons.build,
        label: AppStrings.parts,
        route: AppConstants.routeAdminParts,
      ),
      _NavItem(
        icon: Icons.calendar_today,
        label: AppStrings.manageBookings,
        route: AppConstants.routeAdminBookings,
      ),
    ];

    return _GlassmorphicNavBar(
      currentIndex: currentIndex,
      items: items,
    );
  }
}

/// Navigation item data model
class _NavItem {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final String route;

  _NavItem({
    this.icon,
    this.imagePath,
    required this.label,
    required this.route,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');
}

/// Glassmorphic bottom navigation bar
class _GlassmorphicNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;

  const _GlassmorphicNavBar({
    required this.currentIndex,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.dividerColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _NavItemWidget(
                item: items[index],
                isSelected: index == currentIndex,
                onTap: () {
                  context.go(items[index].route);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual navigation item widget
class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Center(
              child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isSelected ? 12 : 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.redPrimary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: item.imagePath != null
                  ? Image.asset(
                      item.imagePath!,
                      width: isSelected ? 24 : 22,
                      height: isSelected ? 24 : 22,
                      fit: BoxFit.contain,
                      color: iconColor,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.gavel,
                          color: iconColor,
                          size: isSelected ? 24 : 22,
                        );
                      },
                    )
                  : Icon(
                      item.icon,
                      color: iconColor,
                      size: isSelected ? 24 : 22,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

