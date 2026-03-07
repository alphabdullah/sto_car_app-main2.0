import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/admin_service.dart';
import '../../../core/api/api_client.dart' as api;
import '../../../models/auction_model.dart';
import '../../../core/api/api_client.dart';
import '../../../state/auth_state.dart';

/// Admin auction controller (MVC pattern - Controller layer)
class AdminAuctionController extends GetxController {
  static final AdminAuctionController _instance =
      AdminAuctionController._internal();
  factory AdminAuctionController() => _instance;
  AdminAuctionController._internal();

  final AdminService _adminService = AdminService();
  final _isLoading = false.obs;
  final _pendingAuctions = <AuctionModel>[].obs;
  final _isLoadingPending = false.obs;
  bool _hasLoadedPendingAuctions = false;

  bool get isLoading => _isLoading.value;
  bool get isLoadingPending => _isLoadingPending.value;
  List<AuctionModel> get pendingAuctions => _pendingAuctions;

  /// Load pending auctions from API
  ///
  /// [forceRefresh] - If true, will reload even if data already exists
  Future<void> loadPendingAuctions({bool forceRefresh = false}) async {
    // If already loaded and not forcing refresh, skip
    if (_hasLoadedPendingAuctions &&
        !forceRefresh &&
        _pendingAuctions.isNotEmpty) {
      print(
        'AdminAuctionController: Pending auctions already loaded (${_pendingAuctions.length} items), skipping...',
      );
      return;
    }

    // Check if user is authenticated
    final authState = Get.find<AuthState>();
    final token = authState.currentUser?.token;

    if (token == null || token.isEmpty) {
      print('AdminAuctionController: Cannot load pending auctions - no token');
      return;
    }

    // Ensure token is set in ApiClient
    final apiClient = ApiClient();
    if (apiClient.token != token) {
      apiClient.setToken(token);
    }

    print('AdminAuctionController: Token (full): $token');
    print('AdminAuctionController: ApiClient token (full): ${apiClient.token}');

    if (_isLoadingPending.value) {
      print(
        'AdminAuctionController: Already loading, skipping duplicate request',
      );
      return; // Already loading
    }

    _isLoadingPending.value = true;

    try {
      print('AdminAuctionController: Fetching pending auctions from API...');
      final auctionsData = await _adminService.getPendingAuctions();
      print(
        'AdminAuctionController: Received ${auctionsData.length} pending auctions',
      );

      // Parse each auction from JSON
      final auctions = auctionsData
          .map((json) => AuctionModel.fromJson(json))
          .toList();

      _pendingAuctions.value = auctions;
      _hasLoadedPendingAuctions = true;
      print('AdminAuctionController: Parsed ${auctions.length} auctions');
    } on api.ApiException catch (e) {
      print('AdminAuctionController: API error - ${e.message}');
      _showErrorSnackbar(e.message);
    } catch (e) {
      print('AdminAuctionController: Unexpected error - $e');
      _showErrorSnackbar(null);
    } finally {
      _isLoadingPending.value = false;
    }
  }

  void _showErrorSnackbar(String? message) {
    final ctx = Get.context;
    final title = ctx != null ? AppLocalizations.of(ctx)!.error : 'Error';
    final text = message ??
        (ctx != null
            ? AppLocalizations.of(ctx)!.failedToLoadPendingAuctions
            : 'Failed to load pending auctions. Please try again.');
    Get.snackbar(
      title,
      text,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> approveAuction(String auctionId) async {
    _isLoading.value = true;
    final ctx = Get.context;
    try {
      await _adminService.approveAuction(auctionId);
      if (ctx != null) {
        final l = AppLocalizations.of(ctx)!;
        Get.snackbar(
          l.success,
          l.auctionApprovedSuccessfully,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Success',
          'Auction approved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
      // Remove from pending list and refresh
      _pendingAuctions.removeWhere((a) => a.id == auctionId);
      // Reload to get fresh data
      await loadPendingAuctions(forceRefresh: true);
    } on api.ApiException catch (e) {
      _showErrorSnackbar(e.message);
    } catch (e) {
      if (ctx != null) {
        final l = AppLocalizations.of(ctx)!;
        Get.snackbar(
          l.error,
          l.failedToApproveAuction,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to approve auction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> rejectAuction(String auctionId) async {
    _isLoading.value = true;
    final ctx = Get.context;
    try {
      await _adminService.rejectAuction(auctionId);
      if (ctx != null) {
        final l = AppLocalizations.of(ctx)!;
        Get.snackbar(
          l.success,
          l.auctionRejected,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Success',
          'Auction rejected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
      // Remove from pending list and refresh
      _pendingAuctions.removeWhere((a) => a.id == auctionId);
      // Reload to get fresh data
      await loadPendingAuctions(forceRefresh: true);
    } on api.ApiException catch (e) {
      _showErrorSnackbar(e.message);
    } catch (e) {
      if (ctx != null) {
        final l = AppLocalizations.of(ctx)!;
        Get.snackbar(
          l.error,
          l.failedToRejectAuction,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to reject auction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }
}
