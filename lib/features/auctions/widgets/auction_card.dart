import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../models/auction_model.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auth_state.dart';

/// Auction Card Widget with horizontal layout matching Emirates Auction style
class AuctionCard extends StatelessWidget {
  final AuctionModel auction;
  final VoidCallback? onBid;
  final VoidCallback? onView;
  final VoidCallback? onTap;
  final bool showBidButton;
  final bool showViewButton;
  final bool isBidded;
  final bool isOutbid;
  final bool isAuthenticated;

  const AuctionCard({
    super.key,
    required this.auction,
    this.onBid,
    this.onView,
    this.onTap,
    required this.showBidButton,
    this.showViewButton = false,
    this.isBidded = false,
    this.isOutbid = false,
    this.isAuthenticated = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (auction.carImageUrl != null) {
      print(
        'AuctionCard: Loading image for Lot #${auction.id}: ${auction.carImageUrl}',
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final timeRemaining = auction.timeRemaining;
    final bidCount = auction.bids.length;

    // Responsive breakpoints
    final isMediumMobile = screenWidth >= 360 && screenWidth < 600;
    final isLargeMobile = screenWidth >= 600 && screenWidth < 768;
    final isTablet = screenWidth >= 768;

    // Responsive sizing
    final imageSize = isTablet
        ? 180.0
        : isLargeMobile
        ? 160.0
        : isMediumMobile
        ? 140.0
        : 120.0;

    final cardPadding = isTablet
        ? 16.0
        : isLargeMobile
        ? 14.0
        : isMediumMobile
        ? 12.0
        : 10.0;

    final cardMargin = isTablet
        ? 16.0
        : isLargeMobile
        ? 14.0
        : 12.0;

    final borderRadius = isTablet
        ? 12.0
        : isLargeMobile
        ? 10.0
        : 8.0;

    return Container(
      margin: EdgeInsets.only(bottom: cardMargin),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: isTablet ? 15 : 12,
            offset: Offset(0, isTablet ? 4 : 3),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: isTablet ? 8 : 6,
            offset: Offset(0, isTablet ? 2 : 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final textScale = MediaQuery.textScaleFactorOf(context);
              final isCompactLayout =
                  constraints.maxWidth <= 360 || textScale > 1.25;
              final maxImageWidth = constraints.maxWidth * 0.4;
              final actualImageSize = isCompactLayout
                  ? constraints.maxWidth
                  : imageSize.clamp(0.0, maxImageWidth);

              final cardContent = Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lot # ${auction.id.length >= 6 ? auction.id.substring(0, 6) : auction.id}',
                      style: TextStyle(
                        fontSize: isTablet
                            ? 12
                            : isLargeMobile
                                ? 11.5
                                : isMediumMobile
                                    ? 11
                                    : 10,
                        color: theme.colorScheme.outline,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    SizedBox(height: isTablet ? 6 : 4),
                    Text(
                      '${auction.carMake} ${auction.carModel} ${auction.carYear}',
                      style: TextStyle(
                        fontSize: isTablet
                            ? 17
                            : isLargeMobile
                                ? 16
                                : isMediumMobile
                                    ? 15
                                    : 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        height: 1.2,
                        fontFamily: AppTheme.fontFamily,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isTablet ? 10 : 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          context,
                          timeRemaining,
                          bidCount,
                          isTablet,
                          isLargeMobile,
                          isMediumMobile,
                        ),
                        if (auction.isLive) ...[
                          SizedBox(height: isTablet ? 12 : 10),
                          if (isAuthenticated && showBidButton)
                            _buildBidButton(context, isTablet, isLargeMobile)
                          else if (!isAuthenticated)
                            _buildViewButton(context, isTablet, isLargeMobile),
                        ],
                      ],
                    ),
                  ],
                ),
              );

              final arrowWidget = Padding(
                padding: EdgeInsets.only(
                  right: cardPadding,
                  top: cardPadding,
                ),
                child: InkWell(
                  onTap: onView ?? onTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: isTablet
                        ? 40.0
                        : isLargeMobile
                            ? 38.0
                            : 36.0,
                    height: isTablet
                        ? 40.0
                        : isLargeMobile
                            ? 38.0
                            : 36.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.surfaceContainerHighest, theme.colorScheme.surface],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.dividerColor,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: isTablet
                          ? 20.0
                          : isLargeMobile
                              ? 19.0
                              : 18.0,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );

              if (isCompactLayout) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: actualImageSize,
                      child: _buildImageSection(
                        context,
                        actualImageSize,
                        borderRadius,
                      ),
                    ),
                    cardContent,
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: arrowWidget,
                    // ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: actualImageSize,
                    height: actualImageSize,
                    child: _buildImageSection(
                      context,
                      actualImageSize,
                      borderRadius,
                    ),
                  ),
                  Expanded(child: cardContent),
                  arrowWidget,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    double imageSize,
    double borderRadius,
  ) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          // Car Image
          Container(
            width: imageSize,
            height: imageSize,
            color: theme.colorScheme.surfaceContainerHighest,
            child: auction.images.isNotEmpty
                ? PageView.builder(
                    itemCount: auction.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        auction.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print(
                            'AuctionCard: Error loading image: ${auction.images[index]}, Error: $error',
                          );
                          return _buildImagePlaceholder(context, imageSize);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.redPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : _buildImagePlaceholder(context, imageSize),
          ),

          // Image Count Badge
          if (auction.images.length > 1)
            Positioned(
              bottom: imageSize * 0.05,
              right: imageSize * 0.05,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: imageSize * 0.04,
                  vertical: imageSize * 0.015,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: imageSize * 0.07,
                    ),
                    SizedBox(width: imageSize * 0.015),
                    Text(
                      '${auction.images.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: imageSize * 0.065,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bidded Badge (Top Right)
          if (isBidded)
            Positioned(
              top: imageSize * 0.04,
              right: imageSize * 0.04,
              child: _buildBiddedBadge(imageSize),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context, double imageSize) {
    final theme = Theme.of(context);
    return Container(
      width: imageSize,
      height: imageSize,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.directions_car_rounded,
          size: imageSize * 0.3,
          color: theme.colorScheme.outline.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildBiddedBadge(double imageSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: imageSize * 0.04,
        vertical: imageSize * 0.02,
      ),
      decoration: BoxDecoration(
        color: isOutbid ? AppTheme.warning : AppTheme.success,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOutbid ? Icons.trending_down : Icons.trending_up,
            color: Colors.white,
            size: imageSize * 0.07,
          ),
          SizedBox(width: imageSize * 0.015),
          Text(
            isOutbid ? 'Outbid' : 'Winning',
            style: TextStyle(
              fontSize: imageSize * 0.065,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    Duration timeRemaining,
    int bidCount,
    bool isTablet,
    bool isLargeMobile,
    bool isMediumMobile,
  ) {
    final theme = Theme.of(context);
    final spacing = isTablet
        ? 8.0
        : isLargeMobile
        ? 6.0
        : 4.0;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        // Bid Count
        _buildInfoChip(
          context: context,
          icon: Icons.person_outline,
          value: '$bidCount Bids',
          color: AppTheme.info,
          isTablet: isTablet,
          isLargeMobile: isLargeMobile,
          isMediumMobile: isMediumMobile,
        ),
        // Time Remaining
        if (auction.isLive)
          _buildInfoChip(
            context: context,
            icon: Icons.access_time,
            value: _formatTimeRemaining(timeRemaining),
            color: AppTheme.warning,
            isTablet: isTablet,
            isLargeMobile: isLargeMobile,
            isMediumMobile: isMediumMobile,
          ),
        // Current Bid Price
        _buildInfoChip(
          context: context,
          icon: null,
          value: '${auction.currentBid ?? auction.startingBid} AED',
          color: AppTheme.redPrimary,
          isTablet: isTablet,
          isLargeMobile: isLargeMobile,
          isMediumMobile: isMediumMobile,
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required BuildContext context,
    IconData? icon,
    required String value,
    required Color color,
    required bool isTablet,
    required bool isLargeMobile,
    required bool isMediumMobile,
  }) {
    final theme = Theme.of(context);
    final iconSize = isTablet
        ? 14.0
        : isLargeMobile
        ? 13.0
        : isMediumMobile
        ? 12.0
        : 11.0;

    final fontSize = isTablet
        ? 11.0
        : isLargeMobile
        ? 10.5
        : isMediumMobile
        ? 10.0
        : 9.5;

    final padding = isTablet
        ? 8.0
        : isLargeMobile
        ? 7.0
        : isMediumMobile
        ? 6.0
        : 5.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 0.6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: color),
            SizedBox(width: isTablet ? 4 : 3),
          ],
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                color: theme.colorScheme.onSurface,
                fontFamily: AppTheme.fontFamily,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidButton(
    BuildContext context,
    bool isTablet,
    bool isLargeMobile,
  ) {
    final iconSize = isTablet
        ? 18.0
        : isLargeMobile
        ? 17.0
        : 16.0;
    final fontSize = isTablet
        ? 14.0
        : isLargeMobile
        ? 13.5
        : 13.0;
    final horizontalPadding = isTablet
        ? 20.0
        : isLargeMobile
        ? 18.0
        : 16.0;
    final verticalPadding = isTablet ? 14.0 : 12.0;

    // Check verification status
    final authState = Get.put(AuthState());
    final isVerified =
        authState.isAuthenticated &&
        (authState.currentUser?.isVerified ?? false);

    return InkWell(
      onTap: isVerified
          ? onBid
          : () {
              // Navigate to wallet for verification if not verified
              context.push('/wallet');
            },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.redPrimary, AppTheme.redPressed],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.redPrimary.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVerified ? Icons.gavel_rounded : Icons.verified_user_outlined,
              size: iconSize,
              color: Colors.white,
            ),
            SizedBox(width: isTablet ? 8 : 6),
            Flexible(
              child: Text(
                isVerified
                    ? (isBidded ? 'Update Bid' : AppStrings.placeBid)
                    : 'Verify to Bid',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: AppTheme.fontFamily,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewButton(
    BuildContext context,
    bool isTablet,
    bool isLargeMobile,
  ) {
    final iconSize = isTablet
        ? 18.0
        : isLargeMobile
        ? 17.0
        : 16.0;
    final fontSize = isTablet
        ? 14.0
        : isLargeMobile
        ? 13.5
        : 13.0;
    final horizontalPadding = isTablet
        ? 20.0
        : isLargeMobile
        ? 18.0
        : 16.0;
    final verticalPadding = isTablet ? 14.0 : 12.0;

    return InkWell(
      onTap: onView ?? onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.redPrimary, AppTheme.redPressed],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.redPrimary.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_rounded,
              size: iconSize,
              color: Colors.white,
            ),
            SizedBox(width: isTablet ? 8 : 6),
            Flexible(
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: AppTheme.fontFamily,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return 'Ending soon';
    }
  }
}
