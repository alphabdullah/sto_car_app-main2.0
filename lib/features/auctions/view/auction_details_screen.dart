import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/guards/verification_guard_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/auction_state.dart';
import '../../../state/auth_state.dart';
import '../../../models/auction_model.dart';
import '../controller/auction_controller.dart';
import '../../../core/utils/responsive.dart';

/// Full-screen auction details view
class AuctionDetailsScreen extends StatefulWidget {
  final String auctionId;

  const AuctionDetailsScreen({super.key, required this.auctionId});

  @override
  State<AuctionDetailsScreen> createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen> {
  bool _hasLoadedDetails = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Clear previous selected auction
    final auctionState = Get.find<AuctionState>();
    auctionState.selectAuction(''); // Clear selection

    // Load auction details on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoadedDetails) {
        _hasLoadedDetails = true;
        auctionState.loadAuctionDetails(widget.auctionId);
      }
    });
  }

  @override
  void dispose() {
    // Clear selected auction when leaving screen
    final auctionState = Get.find<AuctionState>();
    auctionState.selectAuction('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auctionState = Get.find<AuctionState>();
    final authState = Get.find<AuthState>();
    final controller = Get.find<AuctionController>();
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isMediumMobile = screenWidth >= 360 && screenWidth < 600;
    final isLargeMobile = screenWidth >= 600 && screenWidth < 768;
    final isTablet = screenWidth >= 768;

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Responsive.constrained(
          Obx(() {
            // Get auction from selected (from API) or from list (cached)
            AuctionModel? auction = auctionState.selectedAuction;

            // If not selected yet, try to find in list
            if (auction == null || auction.id != widget.auctionId) {
              try {
                auction = auctionState.auctions.firstWhere(
                  (a) => a.id == widget.auctionId,
                );
              } catch (e) {
                auction = null;
              }
            }

            // Show loading state (but keep app bar visible)
            final isLoading =
                auctionState.isLoading &&
                auctionState.selectedAuction == null &&
                (auction == null || auction.id != widget.auctionId);

            // Show error if auction not found (only after loading completes)
            if (!isLoading &&
                (auction == null ||
                    auction.id != widget.auctionId ||
                    auction.id.isEmpty)) {
              return Column(
                children: [
                  // Back Button Header (always visible)
                  _buildHeader(context),
                  // Error Content
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.auctionNotFound,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () =>
                                context.push(AppConstants.routeAuctions),
                            child: Text(AppLocalizations.of(context)!.backToAuctions),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // If still no auction after loading, show error
            if (auction == null || auction.id.isEmpty) {
              return Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.auctionNotFound,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () =>
                                context.push(AppConstants.routeAuctions),
                            child: Text(AppLocalizations.of(context)!.backToAuctions),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // At this point, auction is guaranteed to be non-null
            final currentAuction = auction;
            final timeRemaining = currentAuction.timeRemaining;
            // Use bids_count from API if available, otherwise use bids.length
            final bidCount = currentAuction.bids.length;
            final isBidded =
                authState.isAuthenticated &&
                currentAuction.bids.any(
                  (bid) => bid.userId == authState.currentUser?.id,
                );

            return Column(
              children: [
                // Header (always visible)
                _buildHeader(context),
                // Content Area
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.redPrimary,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Section
                              _buildImageSection(
                                context,
                                currentAuction,
                                isTablet,
                                isLargeMobile,
                              ),

                              // Content Section
                              Padding(
                                padding: EdgeInsets.all(
                                  isTablet
                                      ? 24.0
                                      : isLargeMobile
                                      ? 20.0
                                      : 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Status Badge
                                    if (isBidded)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: isTablet ? 20 : 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            _buildBiddedBadge(
                                              currentAuction.bids.any(
                                                (bid) =>
                                                    bid.userId ==
                                                        authState
                                                            .currentUser
                                                            ?.id &&
                                                    currentAuction.currentBid !=
                                                        null &&
                                                    bid.amount ==
                                                        currentAuction
                                                            .currentBid,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // Title
                                    Text(
                                      currentAuction.title,
                                      style: TextStyle(
                                        fontSize: isTablet
                                            ? 32
                                            : isLargeMobile
                                            ? 28
                                            : 24,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                        fontFamily: AppTheme.fontFamily,
                                        height: 1.2,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 28 : 24),

                                    // Description
                                    if (currentAuction
                                        .description
                                        .isNotEmpty) ...[
                                      Text(
                                        AppLocalizations.of(context)!.description,
                                        style: TextStyle(
                                          fontSize: isTablet
                                              ? 22
                                              : isLargeMobile
                                              ? 20
                                              : 18,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                          fontFamily: AppTheme.fontFamily,
                                        ),
                                      ),
                                      SizedBox(height: isTablet ? 16 : 12),
                                      Container(
                                        padding: EdgeInsets.all(
                                          isTablet ? 20 : 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Text(
                                          currentAuction.description,
                                          style: TextStyle(
                                            fontSize: isTablet
                                                ? 16
                                                : isLargeMobile
                                                ? 15
                                                : 14,
                                            color: theme.colorScheme.onSurfaceVariant,
                                            height: 1.6,
                                            fontFamily: AppTheme.fontFamily,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: isTablet ? 28 : 24),
                                    ],

                                    // Stats Grid
                                    _buildStatsGrid(
                                      context,
                                      currentAuction,
                                      timeRemaining,
                                      bidCount,
                                      isTablet,
                                      isLargeMobile,
                                      isMediumMobile,
                                    ),

                                    SizedBox(height: isTablet ? 36 : 32),

                                    // Bid Button (only for live auctions)
                                    if (currentAuction.isLive)
                                      _buildBidSection(
                                        context,
                                        currentAuction,
                                        controller,
                                        authState,
                                        isTablet,
                                        isLargeMobile,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.push(AppConstants.routeAuctions),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    AuctionModel auction,
    bool isTablet,
    bool isLargeMobile,
  ) {
    final theme = Theme.of(context);
    final imageHeight = isTablet
        ? 400.0
        : isLargeMobile
        ? 350.0
        : 300.0;
    final images = auction.images;

    if (images.isEmpty) {
      return _buildImagePlaceholder(context, auction, height: imageHeight);
    }

    return Container(
      height: imageHeight,
      width: double.infinity,
      color: theme.colorScheme.surface,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImagePlaceholder(context, auction, height: imageHeight),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: theme.colorScheme.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.redPrimary,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? AppTheme.redPrimary
                          : Colors.white.withValues(alpha: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Counter badge
          if (images.length > 1)
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentImageIndex + 1} / ${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context, AuctionModel auction, {double? height}) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: height ?? 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.surface, theme.colorScheme.surfaceContainerHighest],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_rounded,
                size: 64,
                color: theme.colorScheme.outline.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${auction.carMake} ${auction.carModel}',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiddedBadge(bool isWinning) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isWinning
              ? const [AppTheme.success, AppTheme.success]
              : const [AppTheme.warning, AppTheme.warning],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isWinning ? AppTheme.success : AppTheme.warning).withValues(
              alpha: 0.3,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWinning ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            isWinning
                ? AppLocalizations.of(context)!.winningBid
                : AppLocalizations.of(context)!.outbid,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AuctionModel auction,
    Duration timeRemaining,
    int bidCount,
    bool isTablet,
    bool isLargeMobile,
    bool isMediumMobile,
  ) {
    final theme = Theme.of(context);
    final spacing = isTablet ? 16.0 : 12.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context: context,
                iconImage: 'assets/images/money.png',
                label: AppLocalizations.of(context)!.currentBid,
                value: '${auction.currentBid ?? auction.startingBid}',
                currency: 'AED',
                color: theme.colorScheme.onSurface,
                isTablet: isTablet,
                isLargeMobile: isLargeMobile,
                isMediumMobile: isMediumMobile,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildStatCard(
                context: context,
                iconImage: 'assets/images/calendar.png',
                label: AppLocalizations.of(context)!.timeLeft,
                value: _formatTimeRemaining(context, timeRemaining),
                color: theme.colorScheme.onSurface,
                isTablet: isTablet,
                isLargeMobile: isLargeMobile,
                isMediumMobile: isMediumMobile,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        _buildStatCard(
          context: context,
          iconImage: 'assets/images/auction.png',
          label: AppLocalizations.of(context)!.totalBids,
          value: '$bidCount',
          color: theme.colorScheme.onSurface,
          isTablet: isTablet,
          isLargeMobile: isLargeMobile,
          isMediumMobile: isMediumMobile,
        ),
      ],
    );
  }

  String _formatTimeRemaining(BuildContext context, Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return AppLocalizations.of(context)!.endingSoon;
    }
  }

  Widget _buildStatCard({
    required BuildContext context,
    IconData? icon,
    String? iconImage,
    required String label,
    required String value,
    String? currency,
    required Color color,
    bool isTablet = false,
    bool isLargeMobile = false,
    bool isMediumMobile = false,
  }) {
    final theme = Theme.of(context);
    final padding = isTablet
        ? 24.0
        : isLargeMobile
        ? 20.0
        : 16.0;
    final iconSize = isTablet
        ? 64.0
        : isLargeMobile
        ? 56.0
        : 48.0;
    final labelFontSize = isTablet
        ? 15.0
        : isLargeMobile
        ? 14.0
        : 13.0;
    final valueFontSize = isTablet
        ? 26.0
        : isLargeMobile
        ? 24.0
        : 22.0;
    final currencyFontSize = isTablet
        ? 16.0
        : isLargeMobile
        ? 15.0
        : 14.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              iconImage != null
                  ? SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Image.asset(
                        iconImage,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            icon ?? Icons.image_not_supported,
                            size: iconSize,
                            color: color,
                          );
                        },
                      ),
                    )
                  : Icon(
                      icon ?? Icons.info,
                      size: iconSize,
                      color: color,
                    ),
              SizedBox(width: isTablet ? 16 : 12),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: labelFontSize,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                    letterSpacing: -0.5,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (currency != null) ...[
                SizedBox(width: isTablet ? 8 : 6),
                Padding(
                  padding: EdgeInsets.only(bottom: isTablet ? 4 : 3),
                  child: Text(
                    currency,
                    style: TextStyle(
                      fontSize: currencyFontSize,
                                          color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBidSection(
    BuildContext context,
    AuctionModel auction,
    AuctionController controller,
    AuthState authState,
    bool isTablet,
    bool isLargeMobile,
  ) {
    final theme = Theme.of(context);
    return Obx(() {
      final isAuthenticated = authState.isAuthenticated;
      final isVerified = authState.isVerified;

      if (!isAuthenticated) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                AppTheme.redPrimary,
                AppTheme.redPressed,
                AppTheme.redPrimary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.redPrimary.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppTheme.redPrimary.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.push(AppConstants.routeLogin);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.login_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      AppLocalizations.of(context)!.loginToPlaceBid,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: Colors.white,
                        fontFamily: AppTheme.fontFamily,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if (!isVerified) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.warning.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: AppTheme.warning,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.verificationRequired,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.warning,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.pleaseVerifyToPlaceBids,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.warning,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.warning,
                      AppTheme.warning.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.push(AppConstants.routeWallet);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.verifyNow,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: AppTheme.fontFamily,
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
        );
      }

      return VerificationGuardWidget(
        actionDescription: AppLocalizations.of(context)!.verifyAccountToPlaceBids,
        child: Container(
          width: double.infinity,
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
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.redPrimary.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppTheme.redPrimary.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.showBidDialog(context, auction),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.gavel_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      authState.isAuthenticated &&
                              auction.bids.any(
                                (bid) =>
                                    bid.userId == authState.currentUser?.id,
                              )
                          ? AppLocalizations.of(context)!.updateBid
                          : AppLocalizations.of(context)!.placeBid,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: Colors.white,
                        fontFamily: AppTheme.fontFamily,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
