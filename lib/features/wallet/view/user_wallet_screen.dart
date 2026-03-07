import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared_widgets/custom_card.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/auth_state.dart';
import '../../../models/wallet_model.dart';
import '../controller/user_wallet_controller.dart';
import '../../../core/utils/responsive.dart';

/// User wallet screen
class UserWalletScreen extends StatelessWidget {
  const UserWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = Get.put(AuthState());
    final controller = Get.put(UserWalletController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.wallet,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
          child: Responsive.constrained(
            RefreshIndicator(
              onRefresh: () async {
                await controller.loadWalletSummary();
                await authState.refreshUser();
              },
              color: AppTheme.redPrimary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      final walletSummary = controller.walletSummary;
                      final isVerified = authState.isVerified;
                      final isLoadingSummary = controller.isLoadingSummary;

                      if (isLoadingSummary && walletSummary == null) {
                        return CustomCard(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.redPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return CustomCard(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.balance,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${walletSummary?.balance ?? 0.0} ${AppConstants.currency}',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: AppTheme.redPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isVerified ? Icons.verified : Icons.warning,
                                  color: isVerified
                                      ? AppTheme.success
                                      : AppTheme.warning,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isVerified
                                      ? AppLocalizations.of(context)!.accountVerified
                                      : AppLocalizations.of(context)!.verificationRequired,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: isVerified
                                            ? AppTheme.success
                                            : AppTheme.warning,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Obx(() {
                      final walletSummary = controller.walletSummary;
                      final transactions =
                          walletSummary?.recentTransactions ?? [];

                      if (transactions.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.recentTransactions,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          CustomCard(
                            child: Column(
                              children: transactions.map((transaction) {
                                return _TransactionItem(
                                  transaction: transaction,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                    Obx(() {
                      final isVerified = authState.isVerified;
                      if (isVerified) return const SizedBox.shrink();

                      return CustomCard(
                        color: AppTheme.warning.withValues(alpha: 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppTheme.warning,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.verificationRequired,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(AppLocalizations.of(context)!.verificationDescription),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.redPrimary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.dividerColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: AppTheme.redPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${AppConstants.requiredWalletDeposit} ${AppConstants.currency}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: AppTheme.redPrimary,
                                          fontFamily: AppTheme.fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.depositAmountLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextField(
                        onChanged: controller.setDepositAmount,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.amountCurrency(AppConstants.currency),
                          hintText: AppLocalizations.of(context)!.enterDepositAmount,
                          prefixIcon: Icon(
                            Icons.account_balance_wallet,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          errorText: controller.errorMessage,
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest,
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
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomButton(
                        text: AppLocalizations.of(context)!.depositWithStripe,
                        onPressed: controller.depositAmount > 0
                            ? () => controller.deposit(context)
                            : null,
                        isLoading: controller.isLoading,
                        icon: Icons.credit_card,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.quickDeposit,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text:
                                '${AppConstants.requiredWalletDeposit} ${AppConstants.currency}',
                            onPressed: () => controller.quickDeposit(
                              context,
                              AppConstants.requiredWalletDeposit,
                            ),
                            backgroundColor: AppTheme.redPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}

/// Transaction item widget
class _TransactionItem extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == 'deposit';
    final amount = transaction.amount;
    final date = DateFormat('MMM dd, yyyy').format(transaction.timestamp);
    final time = DateFormat('hh:mm a').format(transaction.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDeposit
                  ? AppTheme.success.withValues(alpha: 0.1)
                  : AppTheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1.5,
              ),
            ),
            child: Icon(
              isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isDeposit ? AppTheme.success : AppTheme.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ??
                      (isDeposit
                          ? AppLocalizations.of(context)!.deposit
                          : AppLocalizations.of(context)!.withdrawal),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.dateAtTime(date, time),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isDeposit ? '+' : '-'}${amount.toStringAsFixed(2)} ${AppConstants.currency}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isDeposit ? AppTheme.success : AppTheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
