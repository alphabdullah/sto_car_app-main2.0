import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../../state/auth_state.dart';
import '../../../../services/stripe_service.dart';
import '../../../../services/wallet_service.dart';
import '../../../../models/wallet_model.dart';

/// User wallet controller (MVC pattern - Controller layer)
class UserWalletController extends GetxController {
  final AuthState _authState = AuthState();
  final StripeService _stripeService = StripeService();
  final WalletService _walletService = WalletService();

  final _depositAmount = 0.0.obs;
  final _isLoading = false.obs;
  final _isLoadingSummary = false.obs;
  final _errorMessage = ''.obs;
  final _walletSummary = Rxn<WalletSummary>();

  double get depositAmount => _depositAmount.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingSummary => _isLoadingSummary.value;
  String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value;
  WalletSummary? get walletSummary => _walletSummary.value;

  @override
  void onInit() {
    super.onInit();
    loadWalletSummary();
  }

  void setDepositAmount(String value) {
    final amount = double.tryParse(value) ?? 0.0;
    _depositAmount.value = amount;
    _errorMessage.value = '';
  }

  /// Load wallet summary from API
  Future<void> loadWalletSummary() async {
    _isLoadingSummary.value = true;
    try {
      final data = await _walletService.getWalletSummary();
      _walletSummary.value = WalletSummary.fromJson(data);
      print('UserWalletController: Wallet summary loaded: ${_walletSummary.value?.balance}');
    } catch (e) {
      print('UserWalletController.loadWalletSummary error: $e');
      // Don't show error to user, just log it
    } finally {
      _isLoadingSummary.value = false;
    }
  }

  Future<void> deposit(BuildContext context) async {
    if (_depositAmount.value <= 0) {
      _errorMessage.value = AppLocalizations.of(context)!.pleaseEnterValidAmount;
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final response = await _stripeService.handleDeposit(_depositAmount.value);

      if (response['success'] == true) {
        // Refresh user data to get updated balance and verification status
        await _authState.refreshUser();
        
        // Reload wallet summary to get updated balance and transactions
        await loadWalletSummary();

        if (context.mounted) {
          final l = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l.depositSuccess(_depositAmount.value),
              ),
              backgroundColor: Colors.green,
            ),
          );

          // Check if wallet is now verified
          if (_authState.wallet?.isVerified ?? false) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.accountVerifiedMessage),
                backgroundColor: AppTheme.redPrimary,
              ),
            );
          }
        }
        _depositAmount.value = 0.0;
      } else {
        final ctx = Get.context;
        _errorMessage.value = response['message'] ??
            (ctx != null ? AppLocalizations.of(ctx)!.depositFailed : 'Deposit failed');
      }
    } catch (e) {
      print('UserWalletController.deposit error: $e');
      final ctx = Get.context;
      _errorMessage.value = e.toString().contains('Exception:')
          ? e.toString().split('Exception:')[1].trim()
          : (ctx != null ? AppLocalizations.of(ctx)!.depositFailedTryAgain : 'Deposit failed. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> quickDeposit(BuildContext context, double amount) async {
    _depositAmount.value = amount;
    await deposit(context);
  }
}

