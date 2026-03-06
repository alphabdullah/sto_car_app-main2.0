import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auction_state.dart';
import '../../../models/auction_model.dart';
import '../controller/admin_auction_controller.dart';
import '../../../core/utils/responsive.dart';

/// Admin auctions management screen
class AdminAuctionsScreen extends StatefulWidget {
  const AdminAuctionsScreen({super.key});

  @override
  State<AdminAuctionsScreen> createState() => _AdminAuctionsScreenState();
}

class _AdminAuctionsScreenState extends State<AdminAuctionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load pending auctions when screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<AdminAuctionController>();
      // Always refresh to show current data from the live server
      controller.loadPendingAuctions(forceRefresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auctionState = Get.find<AuctionState>();
    final controller = Get.find<AdminAuctionController>();

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
        child: Obx(() {
          // Show loading from controller if loading pending auctions
          if (controller.isLoadingPending) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.redPrimary,
                ),
              ),
            );
          }

          // Use pending auctions from controller (API data)
          final pendingAuctions = controller.pendingAuctions;
          // Filter out pending auctions from all auctions list (from AuctionState)
          final allAuctions = auctionState.auctions
              .where((auction) => !auction.isPendingApproval)
              .toList();

          return Responsive.constrained(
            Column(
              children: [
                // Header Section
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.manageAuctions,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontFamily: AppTheme.fontFamily,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage and approve auctions',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Custom Prettier Tabs
                _CustomTabBar(controller: _tabController),

                // Tab Bar View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Pending Approval Tab
                      _PendingApprovalTab(
                        pendingAuctions: pendingAuctions,
                        controller: controller,
                      ),
                      // All Auctions Tab
                      _AllAuctionsTab(
                        allAuctions: allAuctions,
                        controller: controller,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const RoleBottomNav(currentIndex: 1),
    );
  }
}

/// Pending Approval Tab
class _PendingApprovalTab extends StatelessWidget {
  final List<AuctionModel> pendingAuctions;
  final AdminAuctionController controller;

  const _PendingApprovalTab({
    required this.pendingAuctions,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (pendingAuctions.isEmpty) {
      return _EmptyState(
        icon: Icons.pending_actions_rounded,
        title: 'No Pending Auctions',
        message: 'All auctions have been reviewed',
      );
    }

    return Responsive(
      mobile: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: pendingAuctions.length,
        itemBuilder: (context, index) {
          final auction = pendingAuctions[index];
          return _AdminAuctionCard(
            auction: auction,
            onApprove: () => controller.approveAuction(auction.id),
            onReject: () => controller.rejectAuction(auction.id),
          );
        },
      ),
      tablet: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 280,
        ),
        itemCount: pendingAuctions.length,
        itemBuilder: (context, index) {
          final auction = pendingAuctions[index];
          return _AdminAuctionCard(
            auction: auction,
            onApprove: () => controller.approveAuction(auction.id),
            onReject: () => controller.rejectAuction(auction.id),
          );
        },
      ),
      desktop: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 300,
        ),
        itemCount: pendingAuctions.length,
        itemBuilder: (context, index) {
          final auction = pendingAuctions[index];
          return _AdminAuctionCard(
            auction: auction,
            onApprove: () => controller.approveAuction(auction.id),
            onReject: () => controller.rejectAuction(auction.id),
          );
        },
      ),
    );
  }
}

/// All Auctions Tab
class _AllAuctionsTab extends StatelessWidget {
  final List<AuctionModel> allAuctions;
  final AdminAuctionController controller;

  const _AllAuctionsTab({required this.allAuctions, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (allAuctions.isEmpty) {
      return _EmptyState(
        icon: Icons.gavel_rounded,
        title: 'No Auctions',
        message: 'No auctions have been created yet',
      );
    }

    return Responsive(
      mobile: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: allAuctions.length,
        itemBuilder: (context, index) {
          final auction = allAuctions[index];
          return _AdminAuctionCard(
            auction: auction,
            onApprove: auction.isPendingApproval
                ? () => controller.approveAuction(auction.id)
                : null,
            onReject: auction.isPendingApproval
                ? () => controller.rejectAuction(auction.id)
                : null,
          );
        },
      ),
      tablet: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 280,
        ),
        itemCount: allAuctions.length,
        itemBuilder: (context, index) {
          final auction = allAuctions[index];
          return _AdminAuctionCard(
            auction: auction,
            onApprove: auction.isPendingApproval
                ? () => controller.approveAuction(auction.id)
                : null,
            onReject: auction.isPendingApproval
                ? () => controller.rejectAuction(auction.id)
                : null,
          );
        },
      ),
      desktop: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 300,
        ),
        itemCount: allAuctions.length,
        itemBuilder: (context, index) {
          final auction = allAuctions[index];
          return _AdminAuctionCard(
            auction: auction,
            onApprove: auction.isPendingApproval
                ? () => controller.approveAuction(auction.id)
                : null,
            onReject: auction.isPendingApproval
                ? () => controller.rejectAuction(auction.id)
                : null,
          );
        },
      ),
    );
  }
}

/// Custom Prettier Tab Bar
class _CustomTabBar extends StatelessWidget {
  final TabController controller;

  const _CustomTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CustomTab(
              label: 'Pending Approval',
              index: 0,
              controller: controller,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _CustomTab(
              label: 'All Auctions',
              index: 1,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Tab Widget
class _CustomTab extends StatelessWidget {
  final String label;
  final int index;
  final TabController controller;

  const _CustomTab({
    required this.label,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final isSelected = controller.index == index;
        return GestureDetector(
          onTap: () {
            controller.animateTo(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [AppTheme.redPrimary, AppTheme.redPressed],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.redPrimary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : theme.colorScheme.outline,
                fontFamily: AppTheme.fontFamily,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Admin Auction Card
class _AdminAuctionCard extends StatelessWidget {
  final AuctionModel auction;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _AdminAuctionCard({
    required this.auction,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(context, auction.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: statusColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section with Image and Header Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image on Left
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child:
                            (auction.carImageUrl != null ||
                                auction.images.isNotEmpty)
                            ? Image.network(
                                auction.carImageUrl ?? auction.images[0],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImagePlaceholder(context),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                          strokeWidth: 2,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(AppTheme.redPrimary),
                                        ),
                                      );
                                    },
                              )
                            : _buildImagePlaceholder(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Header Row with Title and Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  auction.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: statusColor.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(auction.status),
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${auction.carMake} ${auction.carModel} ${auction.carYear}',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Lot # ${auction.id.length >= 6 ? auction.id.substring(0, 6) : auction.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.outline,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Bid Information
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Starting Bid',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: AppTheme.fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${auction.startingBid} AED',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (auction.currentBid != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.redPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.redPrimary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Bid',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontFamily: AppTheme.fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${auction.currentBid} AED',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.redPrimary,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Action Buttons
                if (onApprove != null || onReject != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (onApprove != null)
                        Expanded(
                          child: _ActionButton(
                            label: AppStrings.approve,
                            icon: Icons.check_circle_rounded,
                            color: AppTheme.success,
                            onPressed: onApprove!,
                          ),
                        ),
                      if (onApprove != null && onReject != null)
                        const SizedBox(width: 12),
                      if (onReject != null)
                        Expanded(
                          child: _ActionButton(
                            label: AppStrings.reject,
                            icon: Icons.cancel_rounded,
                            color: AppTheme.error,
                            onPressed: onReject!,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Icon(
        Icons.directions_car_rounded,
        size: 32,
        color: theme.colorScheme.outline.withValues(alpha: 0.5),
      ),
    );
  }

  static Color _getStatusColor(BuildContext context, AuctionStatus status) {
    switch (status) {
      case AuctionStatus.pendingApproval:
        return AppTheme.warning;
      case AuctionStatus.approved:
        return AppTheme.info;
      case AuctionStatus.live:
        return AppTheme.success;
      case AuctionStatus.closed:
        return Theme.of(context).colorScheme.outline;
      case AuctionStatus.rejected:
        return AppTheme.error;
    }
  }

  String _getStatusText(AuctionStatus status) {
    switch (status) {
      case AuctionStatus.pendingApproval:
        return 'PENDING';
      case AuctionStatus.approved:
        return 'APPROVED';
      case AuctionStatus.live:
        return 'LIVE';
      case AuctionStatus.closed:
        return 'CLOSED';
      case AuctionStatus.rejected:
        return 'REJECTED';
    }
  }
}

/// Action Button Widget
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
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
    );
  }
}

/// Empty State Widget
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor, width: 1.5),
              ),
              child: Icon(icon, size: 64, color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: AppTheme.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
