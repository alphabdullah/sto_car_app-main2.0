import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/parts_state.dart';
import '../../../state/auth_state.dart';
import '../../../models/part_model.dart';
import '../../../models/company_model.dart';
import '../controller/parts_controller.dart';
import '../../../core/utils/responsive.dart';

/// Redesigned Marketplace UI for Parts
class PartsScreen extends StatelessWidget {
  const PartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partsState = Get.put(PartsState());
    final authState = Get.put(AuthState());
    final controller = Get.put(PartsController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Responsive.constrained(
          RefreshIndicator(
            onRefresh: () => partsState.refreshMarketplace(),
            color: AppTheme.redPrimary,
            child: CustomScrollView(
              slivers: [
                // 1. Premium Hero Header
                Obx(
                  () => SliverToBoxAdapter(
                    child: _HeroHeader(
                      totalCompanies: partsState.companies.length,
                      totalParts: partsState.parts.length,
                      isAuthenticated: authState.isAuthenticated,
                      onLogin: () => context.push(AppConstants.routeLogin),
                      onSearch: (val) => partsState.setSearchQuery(val),
                    ),
                  ),
                ),

                // 2. Brand Filter Horizontal List
                Obx(
                  () => SliverToBoxAdapter(
                    child: _BrandSelector(
                      companies: partsState.companies,
                      selectedCompanyId: partsState.selectedCompany?.id,
                      onSelected: (id) => partsState.selectCompany(id),
                    ),
                  ),
                ),

                // 4. Main Marketplace Title
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  sliver: SliverToBoxAdapter(
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Featured Marketplace',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                partsState.selectedCompany != null
                                    ? 'Viewing products from ${partsState.selectedCompany!.name}'
                                    : 'Showing ${partsState.parts.length} specialized components',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          if (partsState.parts.isNotEmpty)
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      _showFilterSheet(context, partsState),
                                  icon: const Icon(
                                    Icons.tune_rounded,
                                    color: AppTheme.redPrimary,
                                  ),
                                  tooltip: 'Advanced Filters',
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppTheme.success.withOpacity(0.2),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.bolt,
                                        color: AppTheme.success,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Live',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                Obx(() {
                  if (partsState.isLoading) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.redPrimary,
                        ),
                      ),
                    );
                  }

                  if (partsState.parts.isEmpty) {
                    return SliverFillRemaining(
                      child: _EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'No Parts Found',
                        message: 'Try adjusting your filters or search query',
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isDesktop(context)
                            ? 4
                            : (Responsive.isTablet(context) ? 3 : 2),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final part = partsState.parts[index];
                        return _PartGridCard(
                          part: part,
                          onTap: () =>
                              controller.showPartDetails(context, part.id),
                        );
                      }, childCount: partsState.parts.length),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => authState.isAuthenticated
            ? const RoleBottomNav(currentIndex: 3)
            : const SizedBox.shrink(),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, PartsState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FilterSheet(state: state),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  final PartsState state;
  const _FilterSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advanced Filters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  state.clearAllFilters();
                  Navigator.pop(context);
                },
                child: const Text('Reset All'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'CONDITION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Wrap(
              spacing: 8,
              children: ['new', 'used', 'refurbished'].map((cond) {
                final isSelected = state.selectedCondition == cond;
                return ChoiceChip(
                  label: Text(cond.toUpperCase()),
                  selected: isSelected,
                  onSelected: (val) => state.setCondition(val ? cond : null),
                  selectedColor: AppTheme.redPrimary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'PRICE RANGE (AED)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Min',
                    hintText: '0',
                    hintStyle: TextStyle(color: theme.colorScheme.outline),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) =>
                      state.setPriceRange(double.tryParse(v), state.maxPrice),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Max',
                    hintText: '10000+',
                    hintStyle: TextStyle(color: theme.colorScheme.outline),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) =>
                      state.setPriceRange(state.minPrice, double.tryParse(v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.redPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Apply Filters',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final int totalCompanies;
  final int totalParts;
  final bool isAuthenticated;
  final VoidCallback onLogin;
  final Function(String) onSearch;

  const _HeroHeader({
    required this.totalCompanies,
    required this.totalParts,
    required this.isAuthenticated,
    required this.onLogin,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            AppTheme.redPrimary.withOpacity(0.15),
            AppTheme.redPressed.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.redPrimary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.redPrimary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    AppTheme.redPrimary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppTheme.redPrimary,
                                      AppTheme.redPressed,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.redPrimary.withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.build_circle_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Parts Store',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!isAuthenticated)
                      IconButton(
                        onPressed: onLogin,
                        icon: const Icon(
                          Icons.account_circle_outlined,
                          size: 30,
                          color: AppTheme.redPrimary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Explore Premium Components',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: onSearch,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search parts, brands, OEM...',
                    hintStyle: TextStyle(color: theme.colorScheme.outline),
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.outline,
                    ),
                    filled: true,
                    fillColor: AppTheme.bgSecondary.withOpacity(0.8),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: theme.dividerColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.business_rounded,
                        label: 'Verified Brands',
                        value: totalCompanies.toString(),
                        color: AppTheme.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.inventory_2_rounded,
                        label: 'Total Parts',
                        value: totalParts.toString(),
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PartGridCard extends StatelessWidget {
  final PartModel part;
  final VoidCallback onTap;

  const _PartGridCard({required this.part, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Part Image Section
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest),
                        child: part.imageUrl != null
                            ? Image.network(
                                part.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: theme.colorScheme.outline,
                                    size: 32,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.settings_suggest_outlined,
                                  color: AppTheme.redPrimary,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                    // Part Info Section
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxHeight <= 110;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      part.category.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: isCompact ? 8 : 9,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.redPrimary,
                                        letterSpacing: 1,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: isCompact ? 1 : 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getConditionColor(
                                          part.condition,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        part.condition.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: isCompact ? 7 : 8,
                                          fontWeight: FontWeight.bold,
                                          color: _getConditionColor(
                                            part.condition,
                                          ),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isCompact ? 4 : 6),
                                Text(
                                  part.name,
                                  style: TextStyle(
                                    fontSize: isCompact ? 13 : 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                    height: 1.2,
                                  ),
                                  maxLines: isCompact ? 1 : 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: isCompact ? 2 : 4),
                                Text(
                                  part.brand ?? part.companyName,
                                  style: TextStyle(
                                    fontSize: isCompact ? 10 : 11,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (!isCompact &&
                                    (part.partNumber != null ||
                                        part.oemNumber != null))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      part.oemNumber ?? part.partNumber ?? '',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            AppTheme.textMuted.withOpacity(0.8),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (part.hasDiscount && !isCompact)
                                          Text(
                                            '${part.price.toStringAsFixed(0)} ${part.currency}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: theme.colorScheme.outline,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        Text(
                                          '${part.currentPrice.toStringAsFixed(0)} ${part.currency}',
                                          style: TextStyle(
                                            fontSize: isCompact ? 14 : 16,
                                            fontWeight: FontWeight.w900,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(
                                        isCompact ? 6 : 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.redPrimary,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.redPrimary
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.add_shopping_cart_rounded,
                                        color: Colors.white,
                                        size: isCompact ? 14 : 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (part.isFeatured)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.bolt, color: AppTheme.warning, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'FEATURED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return AppTheme.success;
      case 'used':
        return AppTheme.warning;
      case 'refurbished':
        return AppTheme.info;
      default:
        return AppTheme.textMuted;
    }
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandSelector extends StatelessWidget {
  final List<CompanyModel> companies;
  final String? selectedCompanyId;
  final Function(String?) onSelected;

  const _BrandSelector({
    required this.companies,
    this.selectedCompanyId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: Text(
            'SHOP BY BRAND',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: companies.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                final isSelected = selectedCompanyId == null;
                return _BrandCard(
                  name: 'All Brands',
                  isSelected: isSelected,
                  onTap: () => onSelected(null),
                  icon: Icons.apps_rounded,
                );
              }

              final company = companies[index - 1];
              final isSelected = selectedCompanyId == company.id;
              return _BrandCard(
                name: company.name,
                logoUrl: company.logoUrl,
                isSelected: isSelected,
                onTap: () => onSelected(company.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BrandCard extends StatelessWidget {
  final String name;
  final String? logoUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _BrandCard({
    required this.name,
    this.logoUrl,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.redPrimary : AppTheme.bgSecondary,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.redPrimary
                      : AppTheme.border.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.redPrimary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: icon != null
                      ? Icon(
                          icon,
                          color: isSelected ? Colors.white : AppTheme.textMuted,
                          size: 28,
                        )
                      : (logoUrl != null && logoUrl!.isNotEmpty)
                      ? Image.network(
                          logoUrl!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => Text(
                            name[0],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        )
                      : Text(
                          name[0],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textPrimary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 70,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                  fontFamily: AppTheme.fontFamily,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
