import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/guards/verification_guard_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/parts_state.dart';

/// Unified parts controller for both guest and logged-in users
class PartsController extends GetxController {
  final PartsState _partsState = PartsState();

  /// Navigate to company parts screen
  void navigateToCompanyParts(BuildContext context, String companyId) {
    context.push('${AppConstants.routeParts}/$companyId');
  }

  /// Purchase a part
  Future<void> purchasePart(BuildContext context, String partId) async {
    final part = _partsState.selectedPart;
    if (part == null) {
      _partsState.selectPart(partId);
    }
    final selectedPart = _partsState.selectedPart;
    if (selectedPart == null) return;

    final success = await _partsState.purchasePart(partId, 1);
    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.purchasedSuccess(selectedPart.name),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.purchaseFailedTryAgain,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void showPartDetails(BuildContext context, String partId) {
    _partsState.selectPart(partId);
    final part = _partsState.selectedPart;

    if (part == null) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: AppTheme.bgSecondary,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppTheme.border.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hero Image Section (Carousel)
              Stack(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.bgElevated,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: part.images.isNotEmpty
                        ? PageView.builder(
                            itemCount: part.images.length,
                            itemBuilder: (context, index) => Image.network(
                              part.images[index],
                              fit: BoxFit.cover,
                            ),
                          )
                        : (part.imageUrl != null
                              ? Image.network(part.imageUrl!, fit: BoxFit.cover)
                              : const Center(
                                  child: Icon(
                                    Icons.settings_suggest_outlined,
                                    color: AppTheme.redPrimary,
                                    size: 80,
                                  ),
                                )),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (part.images.length > 1)
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          part.images.length,
                          (index) => Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (part.isFeatured)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.warning,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bolt,
                              color: Colors.black,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context)!.featured,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Info Section
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.redPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              part.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.redPrimary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Text(
                            part.condition.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getConditionColor(part.condition),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        part.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.business_rounded,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            part.brand ?? part.companyName,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        part.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Specifications Grid
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.bgElevated,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow(
                              AppLocalizations.of(context)!.partNumber,
                              part.partNumber ?? 'N/A',
                            ),
                            Divider(height: 24, color: AppTheme.border),
                            _buildSpecRow(
                              AppLocalizations.of(context)!.oemNumber,
                              part.oemNumber ?? 'N/A',
                            ),
                            Divider(height: 24, color: AppTheme.border),
                            _buildSpecRow(
                              AppLocalizations.of(context)!.compatible,
                              '${part.compatibleMake ?? ""} ${part.compatibleModel ?? ""}',
                            ),
                            if (part.yearFrom != null) ...[
                              Divider(height: 24, color: AppTheme.border),
                              _buildSpecRow(
                                AppLocalizations.of(context)!.years,
                                '${part.yearFrom} - ${part.yearTo ?? AppLocalizations.of(context)!.present}',
                              ),
                            ],
                            Divider(height: 24, color: AppTheme.border),
                            _buildSpecRow(
                              AppLocalizations.of(context)!.stock,
                              part.stockQuantity > 0
                                  ? AppLocalizations.of(context)!.unitsCount(part.stockQuantity)
                                  : AppLocalizations.of(context)!.outOfStock,
                              valueColor: part.stockQuantity > 0
                                  ? AppTheme.success
                                  : AppTheme.redPrimary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Price and Action
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (part.hasDiscount)
                                Text(
                                  '${part.price.toStringAsFixed(0)} ${part.currency}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textMuted,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                '${part.currentPrice.toStringAsFixed(0)} ${part.currency}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: VerificationGuardWidget(
                              actionDescription: AppLocalizations.of(context)!.verifyAccountToPurchase,
                              inline: true,
                              child: ElevatedButton(
                                onPressed: part.isInStock
                                    ? () => _purchasePart(context, part.id)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.redPrimary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.purchaseNow,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
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

  Future<void> _purchasePart(BuildContext context, String partId) async {
    final part = _partsState.selectedPart;
    if (part == null) return;

    final success = await _partsState.purchasePart(partId, 1);
    if (context.mounted) {
      Navigator.pop(context);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.purchasedSuccess(part.name),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.purchaseFailedTryAgain,
            ),
          ),
        );
      }
    }
  }
}
