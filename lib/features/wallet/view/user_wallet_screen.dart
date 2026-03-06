import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/custom_card.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../core/background/app_background.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auth_state.dart';
import '../../../models/wallet_model.dart';
import '../controller/user_wallet_controller.dart';
import '../../../core/utils/responsive.dart';

/// User wallet screen
class UserWalletScreen extends StatelessWidget {
  const UserWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.put(AuthState());
    final controller = Get.put(UserWalletController());

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(AppStrings.wallet),
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
                              AppStrings.balance,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${walletSummary?.balance ?? 0.0} ${AppConstants.currency}',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: Colors.blue,
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
                                      ? 'Account Verified'
                                      : 'Verification Required',
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
                            'Recent Transactions',
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
                                  AppStrings.verificationRequired,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(AppStrings.verificationDescription),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.info.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: AppTheme.info,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${AppConstants.requiredWalletDeposit} ${AppConstants.currency}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: AppTheme.info,
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
                      'Deposit Amount',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextField(
                        onChanged: controller.setDepositAmount,
                        decoration: InputDecoration(
                          labelText: 'Amount (${AppConstants.currency})',
                          hintText: 'Enter deposit amount',
                          prefixIcon: const Icon(Icons.account_balance_wallet),
                          errorText: controller.errorMessage,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomButton(
                        text: 'Deposit with Stripe',
                        onPressed: controller.depositAmount > 0
                            ? () => controller.deposit(context)
                            : null,
                        isLoading: controller.isLoading,
                        icon: Icons.credit_card,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Quick Deposit',
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
                            backgroundColor: AppTheme.info,
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
              borderRadius: BorderRadius.circular(8),
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
                      (isDeposit ? 'Deposit' : 'Withdrawal'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date at $time',
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
