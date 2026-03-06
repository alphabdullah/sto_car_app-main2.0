import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/guards/verification_guard_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/parts_state.dart';
import '../../../state/auth_state.dart';
import '../../../models/part_model.dart';
import '../../../models/company_model.dart';
import '../controller/parts_controller.dart';
import '../../../core/utils/responsive.dart';

/// Screen displaying parts of a specific company
class CompanyPartsScreen extends StatelessWidget {
  final String companyId;

  const CompanyPartsScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partsState = Get.put(PartsState());
    final authState = Get.put(AuthState());
    final controller = Get.put(PartsController());

    // Select company and get parts
    partsState.selectCompany(companyId);
    final company = partsState.selectedCompany;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          company?.name ?? 'Parts',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Obx(() {
        if (partsState.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.redPrimary,
              ),
            ),
          );
        }

        final parts = partsState.partsBySelectedCompany;

        if (parts.isEmpty) {
          return _EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'No Parts Available',
            message: 'This company doesn\'t have any parts listed yet',
            companyName: company?.name,
          );
        }

        return Responsive.constrained(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header
              if (company != null) _CompanyHeader(company: company),

              // Parts Section
              Expanded(
                child: Responsive(
                  mobile: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: parts.length,
                    itemBuilder: (context, index) {
                      final part = parts[index];
                      return _PartCard(
                        part: part,
                        companyLogo: company?.logoUrl,
                        onTap: () =>
                            controller.showPartDetails(context, part.id),
                        onPurchase: authState.isAuthenticated
                            ? () => controller.purchasePart(context, part.id)
                            : () => context.push(AppConstants.routeLogin),
                      );
                    },
                  ),
                  tablet: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 420,
                        ),
                    itemCount: parts.length,
                    itemBuilder: (context, index) {
                      final part = parts[index];
                      return _PartCard(
                        part: part,
                        companyLogo: company?.logoUrl,
                        onTap: () =>
                            controller.showPartDetails(context, part.id),
                        onPurchase: authState.isAuthenticated
                            ? () => controller.purchasePart(context, part.id)
                            : () => context.push(AppConstants.routeLogin),
                      );
                    },
                  ),
                  desktop: GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          mainAxisExtent: 440,
                        ),
                    itemCount: parts.length,
                    itemBuilder: (context, index) {
                      final part = parts[index];
                      return _PartCard(
                        part: part,
                        companyLogo: company?.logoUrl,
                        onTap: () =>
                            controller.showPartDetails(context, part.id),
                        onPurchase: authState.isAuthenticated
                            ? () => controller.purchasePart(context, part.id)
                            : () => context.push(AppConstants.routeLogin),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// Company Header Widget
class _CompanyHeader extends StatelessWidget {
  final CompanyModel company;

  const _CompanyHeader({required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.business,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (company.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    company.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Improved Part Card Widget
class _PartCard extends StatelessWidget {
  final PartModel part;
  final String? companyLogo;
  final VoidCallback onTap;
  final VoidCallback? onPurchase;

  const _PartCard({
    required this.part,
    this.companyLogo,
    required this.onTap,
    this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInStock = part.isInStock;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isInStock ? Colors.green.shade200 : Colors.grey.shade300,
          width: isInStock ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Logo Row
                Row(
                  children: [
                    // Company Logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: companyLogo != null && companyLogo!.isNotEmpty
                            ? Image.network(
                                companyLogo!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/comlogo.jpg',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.business,
                                        size: 30,
                                        color: theme.colorScheme.outline,
                                      );
                                    },
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/comlogo.jpg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.business,
                                    size: 30,
                                    color: theme.colorScheme.outline,
                                  );
                                },
                              ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 12),
                // Header Row with Status Badge
                Row(
                  children: [
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(part.category),
                            size: 14,
                            color: AppTheme.info,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            part.category,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.info,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Stock Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isInStock
                            ? Colors.green.withValues(alpha: 0.15)
                            : Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isInStock
                              ? Colors.green.withValues(alpha: 0.3)
                              : Colors.red.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isInStock ? Icons.check_circle : Icons.cancel,
                            size: 14,
                            color: isInStock ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isInStock ? 'In Stock' : 'Out of Stock',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isInStock ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Part Name
                Text(
                  part.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),

                const SizedBox(height: 8),

                // Part Description
                Text(
                  part.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Price and Stock Row
                Row(
                  children: [
                    // Price
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: AppTheme.fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${part.price} ${part.currency}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isInStock) ...[
                      const SizedBox(width: 12),
                      // Stock Quantity
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontFamily: AppTheme.fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${part.stockQuantity} units',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Purchase Button
                if (isInStock && onPurchase != null) ...[
                  const SizedBox(height: 16),
                  VerificationGuardWidget(
                    actionDescription: 'Verify your account to purchase parts',
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade700, Colors.red.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: onPurchase,
                        icon: const Icon(Icons.shopping_cart, size: 20),
                        label: const Text(
                          'Purchase',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: theme.colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'brakes':
        return Icons.disc_full;
      case 'filters':
        return Icons.filter_alt;
      case 'engine':
        return Icons.settings;
      case 'tires':
        return Icons.circle;
      case 'lights':
        return Icons.lightbulb;
      default:
        return Icons.build;
    }
  }
}

/// Empty State Widget
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? companyName;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.companyName,
  });

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
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
