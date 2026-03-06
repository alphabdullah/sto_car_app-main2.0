import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/parts_state.dart';
import '../../../models/sold_part_model.dart';
import '../controller/admin_parts_controller.dart';
import '../../../core/utils/responsive.dart';

/// Admin parts management screen
class AdminPartsScreen extends StatelessWidget {
  const AdminPartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partsState = Get.put(PartsState());
    final controller = Get.put(AdminPartsController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (partsState.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.redPrimary,
                ),
              ),
            );
          }

          final soldParts = partsState.soldParts;

          return Responsive.constrained(
            Column(
              children: [
                // Custom Header
                Container(
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sold Parts',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                  fontFamily: AppTheme.fontFamily,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${soldParts.length} ${soldParts.length == 1 ? 'sale' : 'sales'} recorded',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.redPrimary,
                                AppTheme.redPressed,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.redPrimary.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  controller.showAddPartDialog(context),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                constraints: const BoxConstraints(
                                  minWidth: 48,
                                  minHeight: 48,
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sold Parts List
                Expanded(
                  child: soldParts.isEmpty
                      ? _EmptyState(
                          onAddPart: () =>
                              controller.showAddPartDialog(context),
                        )
                      : Responsive(
                          mobile: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: soldParts.length,
                            itemBuilder: (context, index) {
                              final soldPart = soldParts[index];
                              return _SoldPartCard(soldPart: soldPart);
                            },
                          ),
                          tablet: GridView.builder(
                            padding: const EdgeInsets.all(20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  mainAxisExtent: 280,
                                ),
                            itemCount: soldParts.length,
                            itemBuilder: (context, index) {
                              final soldPart = soldParts[index];
                              return _SoldPartCard(soldPart: soldPart);
                            },
                          ),
                          desktop: GridView.builder(
                            padding: const EdgeInsets.all(24),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  mainAxisExtent: 300,
                                ),
                            itemCount: soldParts.length,
                            itemBuilder: (context, index) {
                              final soldPart = soldParts[index];
                              return _SoldPartCard(soldPart: soldPart);
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const RoleBottomNav(currentIndex: 2),
    );
  }
}

/// Sold Part Card Widget
class _SoldPartCard extends StatelessWidget {
  final SoldPartModel soldPart;

  const _SoldPartCard({required this.soldPart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = _getCategoryColor(soldPart.category);
    final dateStr = _formatDate(soldPart.soldAt);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.dividerColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: categoryColor.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Company and Category
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withValues(alpha: 0.1),
                      categoryColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Icon
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor.withValues(alpha: 0.3),
                            categoryColor.withValues(alpha: 0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _getCategoryIcon(soldPart.category),
                        color: categoryColor,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 10 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            soldPart.partName,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              fontFamily: AppTheme.fontFamily,
                              letterSpacing: -0.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: isSmallScreen ? 6 : 8),
                          Row(
                            children: [
                              Icon(
                                Icons.business_rounded,
                                size: isSmallScreen ? 14 : 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(width: isSmallScreen ? 4 : 6),
                              Flexible(
                                child: Text(
                                  soldPart.companyName,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 15,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontFamily: AppTheme.fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quantity and Total Amount Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.success.withValues(alpha: 0.2),
                                  AppTheme.success.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.success.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.success.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.success.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.shopping_cart_rounded,
                                    color: AppTheme.success,
                                    size: isSmallScreen ? 16 : 18,
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 8 : 10),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 10 : 11,
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontFamily: AppTheme.fontFamily,
                                        ),
                                      ),
                                      SizedBox(height: isSmallScreen ? 2 : 4),
                                      Text(
                                        '${soldPart.quantity} ${soldPart.quantity == 1 ? 'unit' : 'units'}',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.success,
                                          fontFamily: AppTheme.fontFamily,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 10 : 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.redPrimary.withValues(alpha: 0.2),
                                  AppTheme.redPrimary.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.redPrimary.withValues(
                                  alpha: 0.4,
                                ),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.redPrimary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.redPrimary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.attach_money_rounded,
                                    color: AppTheme.redPrimary,
                                    size: isSmallScreen ? 16 : 18,
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 8 : 10),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 10 : 11,
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontFamily: AppTheme.fontFamily,
                                        ),
                                      ),
                                      SizedBox(height: isSmallScreen ? 2 : 4),
                                      Text(
                                        '${soldPart.totalAmount.toStringAsFixed(0)} ${soldPart.currency}',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.redPrimary,
                                          fontFamily: AppTheme.fontFamily,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    // Sale Date and Buyer Info
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: isSmallScreen ? 16 : 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sold on',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 11 : 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 2 : 4),
                                Text(
                                  dateStr,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (soldPart.buyerName != null) ...[
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            Icon(
                              Icons.person_rounded,
                              size: isSmallScreen ? 16 : 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Buyer',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 11 : 12,
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontFamily: AppTheme.fontFamily,
                                    ),
                                  ),
                                  SizedBox(height: isSmallScreen ? 2 : 4),
                                  Text(
                                    soldPart.buyerName!,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                      fontFamily: AppTheme.fontFamily,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'brakes':
        return AppTheme.error;
      case 'filters':
        return AppTheme.info;
      case 'engine':
        return AppTheme.warning;
      case 'tires':
        return AppTheme.success;
      case 'lights':
        return AppTheme.info;
      default:
        return AppTheme.redPrimary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'brakes':
        return Icons.disc_full_rounded;
      case 'filters':
        return Icons.filter_alt_rounded;
      case 'engine':
        return Icons.settings_rounded;
      case 'tires':
        return Icons.circle_rounded;
      case 'lights':
        return Icons.lightbulb_rounded;
      default:
        return Icons.build_rounded;
    }
  }
}

/// Empty State Widget
class _EmptyState extends StatelessWidget {
  final VoidCallback onAddPart;

  const _EmptyState({required this.onAddPart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.surface, theme.colorScheme.surfaceContainerHighest],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.build_circle_outlined,
                size: 64,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Sales Recorded',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No parts have been sold yet',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: AppTheme.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
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
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAddPart,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Add Part',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
