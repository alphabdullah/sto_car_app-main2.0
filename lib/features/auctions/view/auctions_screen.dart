import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/auction_state.dart';
import '../../../state/auth_state.dart';
import '../controller/auction_controller.dart';
import '../widgets/auction_card.dart';
import '../../../core/utils/responsive.dart';

/// Unified auctions screen with tabs
class AuctionsScreen extends StatefulWidget {
  const AuctionsScreen({super.key});

  @override
  State<AuctionsScreen> createState() => _AuctionsScreenState();
}

class _AuctionsScreenState extends State<AuctionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _hasLoadedAuctions = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auctionState = Get.find<AuctionState>();
    final authState = Get.find<AuthState>();
    final controller = Get.find<AuctionController>();

    // Load auctions from API only if not already loaded
    if (!_hasLoadedAuctions) {
      _hasLoadedAuctions = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only load if data doesn't exist, don't force refresh
        if (auctionState.auctions.isEmpty) {
          auctionState.loadAuctions(forceRefresh: false);
        }
      });
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Responsive.constrained(
          Column(
            children: [
              // Back Button at Top Left (always visible)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () =>
                        context.push(AppConstants.routeHomeFeature),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              // Custom Prettier Tabs (always visible)
              _CustomTabBar(controller: _tabController),
              // Tab Bar View (content area)
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _LiveAuctionsTab(controller: controller),
                    _BiddedAuctionsTab(controller: controller),
                    _ClosedAuctionsTab(controller: controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => authState.isAuthenticated
            ? const RoleBottomNav(currentIndex: 2)
            : const SizedBox.shrink(),
      ),
    );
  }
}

/// Live Auctions Tab
class _LiveAuctionsTab extends StatelessWidget {
  final AuctionController controller;

  const _LiveAuctionsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final auctionState = Get.find<AuctionState>();
    final authState = Get.find<AuthState>();

    return Obx(() {
      final liveAuctions = auctionState.liveAuctions;

      return RefreshIndicator(
        onRefresh: () async {
          await auctionState.loadAuctions(forceRefresh: true);
        },
        color: AppTheme.redPrimary,
        child: (auctionState.isLoading && liveAuctions.isEmpty)
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.redPrimary,
                    ),
                  ),
                ),
              )
            : liveAuctions.isEmpty
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _EmptyState(
                      icon: Icons.gavel_outlined,
                      title: AppLocalizations.of(context)!.noLiveAuctions,
                      message: AppLocalizations.of(context)!.noLiveAuctionsMessage,
                    ),
                  ),
                ],
              )
            : Responsive(
                mobile: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: liveAuctions.length,
                  itemBuilder: (context, index) {
                    final auction = liveAuctions[index];
                    final isAuthenticated = authState.isAuthenticated;
                    return AuctionCard(
                      auction: auction,
                      onBid: isAuthenticated
                          ? () => controller.showBidDialog(context, auction)
                          : null,
                      onView: () =>
                          controller.showAuctionDetails(context, auction),
                      showBidButton: isAuthenticated,
                      showViewButton: !isAuthenticated,
                      isAuthenticated: isAuthenticated,
                      isBidded:
                          isAuthenticated &&
                          auction.bids.any(
                            (bid) => bid.userId == authState.currentUser?.id,
                          ),
                    );
                  },
                ),
                tablet: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: liveAuctions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 180,
                  ),
                  itemBuilder: (context, index) {
                    final auction = liveAuctions[index];
                    final isAuthenticated = authState.isAuthenticated;
                    return AuctionCard(
                      auction: auction,
                      onView: () =>
                          controller.showAuctionDetails(context, auction),
                      showBidButton: false,
                      showViewButton: true,
                      isAuthenticated: isAuthenticated,
                    );
                  },
                ),
                desktop: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: liveAuctions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    mainAxisExtent: 200,
                  ),
                  itemBuilder: (context, index) {
                    final auction = liveAuctions[index];
                    final isAuthenticated = authState.isAuthenticated;
                    return AuctionCard(
                      auction: auction,
                      onView: () =>
                          controller.showAuctionDetails(context, auction),
                      showBidButton: false,
                      showViewButton: true,
                      isAuthenticated: isAuthenticated,
                    );
                  },
                ),
              ),
      );
    });
  }
}

/// Bidded Auctions Tab (Auctions where user has placed bids)
class _BiddedAuctionsTab extends StatefulWidget {
  final AuctionController controller;

  const _BiddedAuctionsTab({required this.controller});

  @override
  State<_BiddedAuctionsTab> createState() => _BiddedAuctionsTabState();
}

class _BiddedAuctionsTabState extends State<_BiddedAuctionsTab> {
  bool _hasLoadedOnce = false;

  @override
  Widget build(BuildContext context) {
    final auctionState = Get.find<AuctionState>();
    final authState = Get.find<AuthState>();

    return Obx(() {
      if (!authState.isAuthenticated) {
        return RefreshIndicator(
          onRefresh: () async {
            await auctionState.loadAuctions(forceRefresh: true);
          },
          color: AppTheme.redPrimary,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: _EmptyState(
                  icon: Icons.gavel_outlined,
                  title: AppLocalizations.of(context)!.noBidsYet,
                  message: AppLocalizations.of(context)!.loginToViewBiddedAuctions,
                ),
              ),
            ],
          ),
        );
      }

      // Load my bids from API only once on first build
      if (!_hasLoadedOnce && !auctionState.isLoadingMyBids) {
        _hasLoadedOnce = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            auctionState.loadMyBids(forceRefresh: false);
          }
        });
      }

      // Use API data for my bids
      final biddedAuctions = auctionState.myBids.toList();

      return RefreshIndicator(
        onRefresh: () async {
          await auctionState.loadMyBids(forceRefresh: true);
        },
        color: AppTheme.redPrimary,
        child: (auctionState.isLoadingMyBids && biddedAuctions.isEmpty)
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.redPrimary,
                    ),
                  ),
                ),
              )
            : biddedAuctions.isEmpty
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _EmptyState(
                      icon: Icons.gavel_outlined,
                      title: AppLocalizations.of(context)!.noBidsYet,
                      message: AppLocalizations.of(context)!.noBidsYetMessage,
                    ),
                  ),
                ],
              )
            : Responsive(
                mobile: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: biddedAuctions.length,
                  itemBuilder: (context, index) {
                    final auction = biddedAuctions[index];
                    return AuctionCard(
                      auction: auction,
                      onBid: () =>
                          widget.controller.showBidDialog(context, auction),
                      onView: () => widget.controller.showAuctionDetails(
                        context,
                        auction,
                      ),
                      showBidButton: true,
                      isAuthenticated: true,
                      isBidded: true,
                    );
                  },
                ),
                tablet: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: biddedAuctions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 180,
                  ),
                  itemBuilder: (context, index) {
                    final auction = biddedAuctions[index];
                    return AuctionCard(
                      auction: auction,
                      onView: () => widget.controller.showAuctionDetails(
                        context,
                        auction,
                      ),
                      showBidButton: false,
                      showViewButton: true,
                      isAuthenticated: true,
                      isBidded: true,
                    );
                  },
                ),
                desktop: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: biddedAuctions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    mainAxisExtent: 200,
                  ),
                  itemBuilder: (context, index) {
                    final auction = biddedAuctions[index];
                    return AuctionCard(
                      auction: auction,
                      onView: () => widget.controller.showAuctionDetails(
                        context,
                        auction,
                      ),
                      showBidButton: false,
                      showViewButton: true,
                      isAuthenticated: true,
                      isBidded: true,
                    );
                  },
                ),
              ),
      );
    });
  }
}

/// Closed Auctions Tab (Auctions where user was outbid)
class _ClosedAuctionsTab extends StatelessWidget {
  final AuctionController controller;

  const _ClosedAuctionsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final auctionState = Get.find<AuctionState>();
    final authState = Get.find<AuthState>();

    return Obx(() {
      if (!authState.isAuthenticated) {
        return RefreshIndicator(
          onRefresh: () async {
            await auctionState.loadAuctions(forceRefresh: true);
          },
          color: AppTheme.redPrimary,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: _EmptyState(
                  icon: Icons.history,
                  title: AppLocalizations.of(context)!.noClosedAuctions,
                  message: AppLocalizations.of(context)!.loginToViewClosedAuctions,
                ),
              ),
            ],
          ),
        );
      }

      final userId = authState.currentUser?.id ?? '';
      final closedOutbidAuctions = auctionState.getClosedOutbidAuctions(userId);

      return RefreshIndicator(
        onRefresh: () async {
          await auctionState.loadAuctions(forceRefresh: true);
        },
        color: AppTheme.redPrimary,
        child: closedOutbidAuctions.isEmpty
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _EmptyState(
                      icon: Icons.history,
                      title: AppLocalizations.of(context)!.noClosedAuctions,
                      message: AppLocalizations.of(context)!.noClosedAuctionsMessage,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: closedOutbidAuctions.length,
                itemBuilder: (context, index) {
                  final auction = closedOutbidAuctions[index];
                  return AuctionCard(
                    auction: auction,
                    onView: () =>
                        controller.showAuctionDetails(context, auction),
                    showBidButton: false,
                    isAuthenticated: true,
                    isBidded: true,
                    isOutbid: true,
                  );
                },
              ),
      );
    });
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CustomTab(
              label: AppLocalizations.of(context)!.liveAuctions,
              index: 0,
              controller: controller,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _CustomTab(
              label: AppLocalizations.of(context)!.myBids,
              index: 1,
              controller: controller,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _CustomTab(
              label: AppLocalizations.of(context)!.closed,
              index: 2,
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
              style: theme.textTheme.bodyMedium?.copyWith(
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
