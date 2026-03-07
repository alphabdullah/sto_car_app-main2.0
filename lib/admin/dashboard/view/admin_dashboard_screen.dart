import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/admin_stats_state.dart';
import '../../../state/auth_state.dart';
import '../../../core/utils/responsive.dart';

/// Admin dashboard screen
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedGraphType = 'Bar Chart';
  String _selectedTimePeriod = 'All Time';
  String _selectedMetric = 'All Metrics';

  @override
  void initState() {
    super.initState();
    // Load stats when dashboard screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final statsState = Get.find<AdminStatsState>();
      // Always refresh to get real-time data from the live server
      statsState.refresh();
      // Start real-time periodic updates
      statsState.startRealTimeUpdates();
    });
  }

  @override
  void dispose() {
    // Stop real-time updates when leaving the dashboard
    Get.find<AdminStatsState>().stopRealTimeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use Get.find instead of Get.put to avoid recreating on every build
    final statsState = Get.find<AdminStatsState>();

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
          final stats = statsState.stats;
          final isLoading = statsState.isLoading;
          final errorMessage = statsState.errorMessage;

          return Responsive.constrained(
            Column(
              children: [
                // Header Section - Always visible
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 400;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          isSmallScreen ? 16 : 20,
                          isSmallScreen ? 16 : 20,
                          isSmallScreen ? 16 : 20,
                          isSmallScreen ? 20 : 24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.dashboard,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 26 : 32,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontFamily: AppTheme.fontFamily,
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: isSmallScreen ? 2 : 4),
                                  Text(
                                    AppLocalizations.of(context)!.adminOverview,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontFamily: AppTheme.fontFamily,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            // Refresh Button
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => statsState.refresh(),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 10 : 12,
                                    ),
                                    child: Icon(
                                      Icons.refresh_rounded,
                                      color: AppTheme.redPrimary,
                                      size: isSmallScreen ? 20 : 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            // Logout Button
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.redPrimary,
                                    AppTheme.redPressed,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.redPrimary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.redPrimary.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _showLogoutDialog(context),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 10 : 12,
                                    ),
                                    child: Icon(
                                      Icons.logout_rounded,
                                      color: Colors.white,
                                      size: isSmallScreen ? 20 : 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Content Area
                Expanded(
                  child: _buildContentArea(
                    context,
                    isLoading,
                    errorMessage,
                    stats,
                    statsState,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const RoleBottomNav(currentIndex: 0),
    );
  }

  Widget _buildContentArea(
    BuildContext context,
    bool isLoading,
    String? errorMessage,
    dynamic stats,
    dynamic statsState,
  ) {
    final theme = Theme.of(context);
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.redPrimary),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppTheme.redPrimary),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => statsState.refresh(),
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stats Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isSmallScreen = screenWidth < 400;

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  isSmallScreen ? 16 : 20,
                  24,
                  isSmallScreen ? 16 : 20,
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.statisticsOverview,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 22,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontFamily: AppTheme.fontFamily,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // First Row - Revenue Highlights
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.auctionRevenue,
                            value:
                                '${AppConstants.currency} ${stats.totalAuctionValue.toStringAsFixed(0)}',
                            icon: Icons.payments_rounded,
                            color: AppTheme.success,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.partsRevenue,
                            value:
                                '${AppConstants.currency} ${stats.totalPartsSold.toStringAsFixed(0)}',
                            icon: Icons.shopping_bag_rounded,
                            color: AppTheme.info,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // Second Row - Auctions
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.totalAuctions,
                            value: stats.totalAuctions.toString(),
                            icon: Icons.gavel_rounded,
                            color: AppTheme.info,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.liveAuctions,
                            value: stats.liveAuctions.toString(),
                            icon: Icons.trending_up_rounded,
                            color: AppTheme.success,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // Third Row - Pending & Parts Available
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.pendingAuctions,
                            value: stats.pendingApprovalAuctions.toString(),
                            icon: Icons.pending_rounded,
                            color: AppTheme.warning,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.partsAvailable,
                            value: stats.availableParts.toString(),
                            icon: Icons.inventory_2_outlined,
                            color: AppTheme.redPrimary,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // Fourth Row - Bookings
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.bookingsToday,
                            value: stats.todayBookings.toString(),
                            icon: Icons.today_rounded,
                            color: AppTheme.success,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.pendingBookings,
                            value: stats.pendingBookings.toString(),
                            icon: Icons.pending_actions_rounded,
                            color: AppTheme.warning,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // Fifth Row - Users
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.totalUsers,
                            value: stats.totalUsers.toString(),
                            icon: Icons.people_rounded,
                            color: AppTheme.info,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Expanded(
                          child: _StatCard(
                            title: AppLocalizations.of(context)!.verifiedUsers,
                            value: stats.verifiedUsers.toString(),
                            icon: Icons.verified_user_rounded,
                            color: AppTheme.success,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 24),

                    // Statistics Graphs Section
                    Text(
                      AppLocalizations.of(context)!.visualAnalytics,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 22,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontFamily: AppTheme.fontFamily,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Graph Filters Row
                    Row(
                      children: [
                        // Metric Selector
                        Expanded(
                          child: _MetricFilter(
                            selectedMetric: _selectedMetric,
                            onMetricChanged: (value) {
                              setState(() {
                                _selectedMetric = value;
                              });
                            },
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        // Time Period Filter for Graphs
                        Expanded(
                          child: _GraphTimePeriodFilter(
                            selectedTimePeriod: _selectedTimePeriod,
                            onTimePeriodChanged: (value) {
                              setState(() {
                                _selectedTimePeriod = value;
                              });
                            },
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // Graph Type Filter
                    _GraphTypeFilter(
                      selectedGraphType: _selectedGraphType,
                      onGraphTypeChanged: (value) {
                        setState(() {
                          _selectedGraphType = value;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Selected Graph Display
                    _buildSelectedGraph(
                      stats: _filterStatsByTimePeriod(
                        stats,
                        _selectedTimePeriod,
                      ),
                      graphType: _selectedGraphType,
                      timePeriod: _selectedTimePeriod,
                      metric: _selectedMetric,
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildSelectedGraph({
    required dynamic stats,
    required String graphType,
    required String timePeriod,
    required String metric,
    required bool isSmallScreen,
  }) {
    switch (graphType) {
      case 'Bar Chart':
        return _StatsBarChart(
          stats: stats,
          isSmallScreen: isSmallScreen,
          timePeriod: timePeriod,
          selectedMetric: metric,
        );
      case 'Pie Chart':
        return _StatsPieChart(
          stats: stats,
          isSmallScreen: isSmallScreen,
          timePeriod: timePeriod,
          selectedMetric: metric,
        );
      case 'Line Chart':
        return _StatsLineChart(
          stats: stats,
          isSmallScreen: isSmallScreen,
          timePeriod: timePeriod,
          selectedMetric: metric,
        );
      default:
        return _StatsBarChart(
          stats: stats,
          isSmallScreen: isSmallScreen,
          timePeriod: timePeriod,
          selectedMetric: metric,
        );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.redPrimary.withValues(alpha: 0.2),
                          AppTheme.redPressed.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.redPrimary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      size: 32,
                      color: AppTheme.redPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    AppLocalizations.of(dialogContext)!.logout,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Message
                  Text(
                    AppLocalizations.of(dialogContext)!.logoutConfirmMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: theme.dividerColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(dialogContext)!.cancel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.redPrimary, AppTheme.redPressed],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.redPrimary.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final authState = Get.find<AuthState>();
                                await authState.logout();
                                if (dialogContext.mounted) {
                                  Navigator.pop(dialogContext);
                                  context.go(AppConstants.routeHomeFeature);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(dialogContext)!.logout,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: AppTheme.fontFamily,
                                    ),
                                  ),
                                ),
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
        );
      },
    );
  }

  dynamic _filterStatsByTimePeriod(dynamic stats, String timePeriod) {
    // Return real stats as-is.
    // Since the backend currently provides snapshot data, we show real snapshot data
    // for all time periods to avoid showing fake/multiplied numbers.
    return stats;
  }
}

String _localizedMetric(BuildContext context, String key) {
  final l = AppLocalizations.of(context)!;
  switch (key) {
    case 'All Metrics':
      return l.allMetrics;
    case 'Total Auctions':
      return l.totalAuctions;
    case 'Live Auctions':
      return l.liveAuctions;
    case 'Pending Approval':
      return l.pendingApproval;
    case 'Total Parts':
      return l.totalParts;
    case 'Total Bookings':
      return l.totalBookings;
    case 'Pending Bookings':
      return l.pendingBookings;
    case 'Total Users':
      return l.totalUsers;
    case 'Verified Users':
      return l.verifiedUsers;
    case 'Auctions':
      return l.chartAuctions;
    case 'Live':
      return l.chartLive;
    case 'Pending':
      return l.chartPending;
    case 'Parts':
      return l.chartParts;
    case 'Bookings':
      return l.chartBookings;
    case 'Pending B':
      return l.chartPendingB;
    case 'Users':
      return l.chartUsers;
    case 'Verified':
      return l.chartVerified;
    default:
      return key;
  }
}

String _localizedTimePeriod(BuildContext context, String key) {
  final l = AppLocalizations.of(context)!;
  switch (key) {
    case 'All Time':
      return l.allTime;
    case 'This Week':
      return l.thisWeek;
    case 'This Month':
      return l.thisMonth;
    case 'This Year':
      return l.thisYear;
    default:
      return key;
  }
}

/// Metric Filter Widget for Graphs
class _MetricFilter extends StatelessWidget {
  final String selectedMetric;
  final ValueChanged<String> onMetricChanged;
  final bool isSmallScreen;

  const _MetricFilter({
    required this.selectedMetric,
    required this.onMetricChanged,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      child: DropdownButton<String>(
        value: selectedMetric,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: theme.colorScheme.surface,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: isSmallScreen ? 13 : 14,
          fontFamily: AppTheme.fontFamily,
        ),
        items: [
          DropdownMenuItem(value: 'All Metrics', child: Text(l.allMetrics)),
          DropdownMenuItem(value: 'Total Auctions', child: Text(l.totalAuctions)),
          DropdownMenuItem(value: 'Live Auctions', child: Text(l.liveAuctions)),
          DropdownMenuItem(value: 'Pending Approval', child: Text(l.pendingApproval)),
          DropdownMenuItem(value: 'Total Parts', child: Text(l.totalParts)),
          DropdownMenuItem(value: 'Total Bookings', child: Text(l.totalBookings)),
          DropdownMenuItem(value: 'Pending Bookings', child: Text(l.pendingBookings)),
          DropdownMenuItem(value: 'Total Users', child: Text(l.totalUsers)),
          DropdownMenuItem(value: 'Verified Users', child: Text(l.verifiedUsers)),
        ],
        onChanged: (value) {
          if (value != null) {
            onMetricChanged(value);
          }
        },
      ),
    );
  }
}

/// Graph Time Period Filter Widget
class _GraphTimePeriodFilter extends StatelessWidget {
  final String selectedTimePeriod;
  final ValueChanged<String> onTimePeriodChanged;
  final bool isSmallScreen;

  const _GraphTimePeriodFilter({
    required this.selectedTimePeriod,
    required this.onTimePeriodChanged,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      child: DropdownButton<String>(
        value: selectedTimePeriod,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: theme.colorScheme.surface,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: isSmallScreen ? 13 : 14,
          fontFamily: AppTheme.fontFamily,
        ),
        items: [
          DropdownMenuItem(value: 'All Time', child: Text(AppLocalizations.of(context)!.allTime)),
          DropdownMenuItem(value: 'This Week', child: Text(AppLocalizations.of(context)!.thisWeek)),
          DropdownMenuItem(value: 'This Month', child: Text(AppLocalizations.of(context)!.thisMonth)),
          DropdownMenuItem(value: 'This Year', child: Text(AppLocalizations.of(context)!.thisYear)),
        ],
        onChanged: (value) {
          if (value != null) {
            onTimePeriodChanged(value);
          }
        },
      ),
    );
  }
}

/// Graph Type Filter Widget
class _GraphTypeFilter extends StatelessWidget {
  final String selectedGraphType;
  final ValueChanged<String> onGraphTypeChanged;
  final bool isSmallScreen;

  const _GraphTypeFilter({
    required this.selectedGraphType,
    required this.onGraphTypeChanged,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      child: DropdownButton<String>(
        value: selectedGraphType,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: theme.colorScheme.surface,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: isSmallScreen ? 13 : 14,
          fontFamily: AppTheme.fontFamily,
        ),
        items: [
          DropdownMenuItem(value: 'Bar Chart', child: Text(AppLocalizations.of(context)!.barChart)),
          DropdownMenuItem(value: 'Pie Chart', child: Text(AppLocalizations.of(context)!.pieChart)),
          DropdownMenuItem(value: 'Line Chart', child: Text(AppLocalizations.of(context)!.lineChart)),
        ],
        onChanged: (value) {
          if (value != null) {
            onGraphTypeChanged(value);
          }
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isSmallScreen;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.2),
                      color.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: color, size: isSmallScreen ? 24 : 28),
              ),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: AppTheme.fontFamily,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontFamily: AppTheme.fontFamily,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Statistics Bar Chart Widget
class _StatsBarChart extends StatelessWidget {
  final dynamic stats;
  final bool isSmallScreen;
  final String timePeriod;
  final String selectedMetric;

  const _StatsBarChart({
    required this.stats,
    this.isSmallScreen = false,
    this.timePeriod = 'All Time',
    this.selectedMetric = 'All Metrics',
  });

  List<Map<String, dynamic>> _getChartData() {
    if (selectedMetric == 'All Metrics') {
      return [
        {
          'label': 'Auctions',
          'value': stats.totalAuctions.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Live',
          'value': stats.liveAuctions.toDouble(),
          'color': AppTheme.success,
        },
        {
          'label': 'Pending',
          'value': stats.pendingApprovalAuctions.toDouble(),
          'color': AppTheme.warning,
        },
        {
          'label': 'Parts',
          'value': stats.totalParts.toDouble(),
          'color': AppTheme.redPrimary,
        },
        {
          'label': 'Bookings',
          'value': stats.totalBookings.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Pending B',
          'value': stats.pendingBookings.toDouble(),
          'color': AppTheme.warning,
        },
        {
          'label': 'Users',
          'value': stats.totalUsers.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Verified',
          'value': stats.verifiedUsers.toDouble(),
          'color': AppTheme.success,
        },
      ];
    }

    // Single metric selected
    switch (selectedMetric) {
      case 'Total Auctions':
        return [
          {
            'label': 'Total Auctions',
            'value': stats.totalAuctions.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Live Auctions':
        return [
          {
            'label': 'Live Auctions',
            'value': stats.liveAuctions.toDouble(),
            'color': AppTheme.success,
          },
        ];
      case 'Pending Approval':
        return [
          {
            'label': 'Pending Approval',
            'value': stats.pendingApprovalAuctions.toDouble(),
            'color': AppTheme.warning,
          },
        ];
      case 'Total Parts':
        return [
          {
            'label': 'Total Parts',
            'value': stats.totalParts.toDouble(),
            'color': AppTheme.redPrimary,
          },
        ];
      case 'Total Bookings':
        return [
          {
            'label': 'Total Bookings',
            'value': stats.totalBookings.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Pending Bookings':
        return [
          {
            'label': 'Pending Bookings',
            'value': stats.pendingBookings.toDouble(),
            'color': AppTheme.warning,
          },
        ];
      case 'Total Users':
        return [
          {
            'label': 'Total Users',
            'value': stats.totalUsers.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Verified Users':
        return [
          {
            'label': 'Verified Users',
            'value': stats.verifiedUsers.toDouble(),
            'color': AppTheme.success,
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartData = _getChartData();
    final maxValue = chartData.isEmpty
        ? 10.0
        : chartData
              .map((e) => e['value'] as double)
              .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedMetric == 'All Metrics'
                      ? AppLocalizations.of(context)!.statisticsComparison
                      : _localizedMetric(context, selectedMetric),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.redPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.redPrimary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _localizedTimePeriod(context, timePeriod),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: AppTheme.redPrimary,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          SizedBox(
            height: isSmallScreen ? 200 : 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue > 0 ? maxValue * 1.2 : 10,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => theme.colorScheme.surface,
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toInt().toString(),
                        TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final l = AppLocalizations.of(context)!;
                        final labels = [
                          l.chartAuctions,
                          l.chartLive,
                          l.chartPending,
                          l.chartParts,
                          l.chartBookings,
                          l.chartPendingB,
                          l.chartUsers,
                          l.chartVerified,
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9 : 11,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: AppTheme.fontFamily,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: isSmallScreen ? 30 : 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isSmallScreen ? 35 : 45,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 12,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue > 0 ? maxValue / 5 : 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.dividerColor.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: theme.dividerColor, width: 1),
                ),
                barGroups: chartData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data['value'] as double,
                        color: data['color'] as Color,
                        width: isSmallScreen ? 12 : 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Statistics Pie Chart Widget
class _StatsPieChart extends StatelessWidget {
  final dynamic stats;
  final bool isSmallScreen;
  final String timePeriod;
  final String selectedMetric;

  const _StatsPieChart({
    required this.stats,
    this.isSmallScreen = false,
    this.timePeriod = 'All Time',
    this.selectedMetric = 'All Metrics',
  });

  List<Map<String, dynamic>> _getChartData() {
    if (selectedMetric == 'All Metrics') {
      return [
        {
          'label': 'Total Auctions',
          'value': stats.totalAuctions.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Live Auctions',
          'value': stats.liveAuctions.toDouble(),
          'color': AppTheme.success,
        },
        {
          'label': 'Pending Approval',
          'value': stats.pendingApprovalAuctions.toDouble(),
          'color': AppTheme.warning,
        },
        {
          'label': 'Total Parts',
          'value': stats.totalParts.toDouble(),
          'color': AppTheme.redPrimary,
        },
        {
          'label': 'Total Bookings',
          'value': stats.totalBookings.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Pending Bookings',
          'value': stats.pendingBookings.toDouble(),
          'color': AppTheme.warning,
        },
        {
          'label': 'Total Users',
          'value': stats.totalUsers.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Verified Users',
          'value': stats.verifiedUsers.toDouble(),
          'color': AppTheme.success,
        },
      ];
    }

    // Single metric selected - show it as 100%
    switch (selectedMetric) {
      case 'Total Auctions':
        return [
          {
            'label': 'Total Auctions',
            'value': stats.totalAuctions.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Live Auctions':
        return [
          {
            'label': 'Live Auctions',
            'value': stats.liveAuctions.toDouble(),
            'color': AppTheme.success,
          },
        ];
      case 'Pending Approval':
        return [
          {
            'label': 'Pending Approval',
            'value': stats.pendingApprovalAuctions.toDouble(),
            'color': AppTheme.warning,
          },
        ];
      case 'Total Parts':
        return [
          {
            'label': 'Total Parts',
            'value': stats.totalParts.toDouble(),
            'color': AppTheme.redPrimary,
          },
        ];
      case 'Total Bookings':
        return [
          {
            'label': 'Total Bookings',
            'value': stats.totalBookings.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Pending Bookings':
        return [
          {
            'label': 'Pending Bookings',
            'value': stats.pendingBookings.toDouble(),
            'color': AppTheme.warning,
          },
        ];
      case 'Total Users':
        return [
          {
            'label': 'Total Users',
            'value': stats.totalUsers.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Verified Users':
        return [
          {
            'label': 'Verified Users',
            'value': stats.verifiedUsers.toDouble(),
            'color': AppTheme.success,
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartData = _getChartData();

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.distributionOverview,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.redPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.redPrimary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _localizedTimePeriod(context, timePeriod),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: AppTheme.redPrimary,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          Row(
            children: [
              // Pie Chart
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: isSmallScreen ? 180 : 220,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: isSmallScreen ? 30 : 40,
                      sections: chartData.map((data) {
                        final value = data['value'] as double;
                        final color = data['color'] as Color;
                        return PieChartSectionData(
                          value: value,
                          color: color,
                          title: value > 0 ? '${value.toInt()}' : '',
                          radius: isSmallScreen ? 50 : 60,
                          titleStyle: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // Legend
              if (chartData.length > 1)
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: chartData.map((data) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _LegendItem(
                            color: data['color'] as Color,
                            label: _localizedMetric(context, data['label'] as String),
                            value: (data['value'] as double).toInt(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Statistics Line Chart Widget
class _StatsLineChart extends StatelessWidget {
  final dynamic stats;
  final bool isSmallScreen;
  final String timePeriod;
  final String selectedMetric;

  const _StatsLineChart({
    required this.stats,
    this.isSmallScreen = false,
    this.timePeriod = 'All Time',
    this.selectedMetric = 'All Metrics',
  });

  List<Map<String, dynamic>> _getChartData() {
    if (selectedMetric == 'All Metrics') {
      return [
        {
          'label': 'Auctions',
          'value': stats.totalAuctions.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Live',
          'value': stats.liveAuctions.toDouble(),
          'color': AppTheme.success,
        },
        {
          'label': 'Pending',
          'value': stats.pendingApprovalAuctions.toDouble(),
          'color': AppTheme.warning,
        },
        {
          'label': 'Parts',
          'value': stats.totalParts.toDouble(),
          'color': AppTheme.redPrimary,
        },
        {
          'label': 'Bookings',
          'value': stats.totalBookings.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Pending B',
          'value': stats.pendingBookings.toDouble(),
          'color': AppTheme.warning,
        },
        {
          'label': 'Users',
          'value': stats.totalUsers.toDouble(),
          'color': AppTheme.info,
        },
        {
          'label': 'Verified',
          'value': stats.verifiedUsers.toDouble(),
          'color': AppTheme.success,
        },
      ];
    }

    // Single metric selected
    switch (selectedMetric) {
      case 'Total Auctions':
        return [
          {
            'label': 'Total Auctions',
            'value': stats.totalAuctions.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Live Auctions':
        return [
          {
            'label': 'Live Auctions',
            'value': stats.liveAuctions.toDouble(),
            'color': AppTheme.success,
          },
        ];
      case 'Pending Approval':
        return [
          {
            'label': 'Pending Approval',
            'value': stats.pendingApprovalAuctions.toDouble(),
            'color': AppTheme.warning,
          },
        ];
      case 'Total Parts':
        return [
          {
            'label': 'Total Parts',
            'value': stats.totalParts.toDouble(),
            'color': AppTheme.redPrimary,
          },
        ];
      case 'Total Bookings':
        return [
          {
            'label': 'Total Bookings',
            'value': stats.totalBookings.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Pending Bookings':
        return [
          {
            'label': 'Pending Bookings',
            'value': stats.pendingBookings.toDouble(),
            'color': AppTheme.warning,
          },
        ];
      case 'Total Users':
        return [
          {
            'label': 'Total Users',
            'value': stats.totalUsers.toDouble(),
            'color': AppTheme.info,
          },
        ];
      case 'Verified Users':
        return [
          {
            'label': 'Verified Users',
            'value': stats.verifiedUsers.toDouble(),
            'color': AppTheme.success,
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartData = _getChartData();
    final maxValue = chartData.isEmpty
        ? 10.0
        : chartData
              .map((e) => e['value'] as double)
              .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedMetric == 'All Metrics'
                      ? AppLocalizations.of(context)!.trendAnalysis
                      : _localizedMetric(context, selectedMetric),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.redPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.redPrimary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _localizedTimePeriod(context, timePeriod),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: AppTheme.redPrimary,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          SizedBox(
            height: isSmallScreen ? 200 : 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue > 0 ? maxValue / 5 : 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.dividerColor.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < chartData.length) {
                          final label =
                              chartData[value.toInt()]['label'] as String;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _localizedMetric(context, label),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9 : 11,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: AppTheme.fontFamily,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: isSmallScreen ? 30 : 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isSmallScreen ? 35 : 45,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 12,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: theme.dividerColor, width: 1),
                ),
                lineBarsData: chartData.isEmpty
                    ? []
                    : [
                        LineChartBarData(
                          spots: chartData.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              entry.value['value'] as double,
                            );
                          }).toList(),
                          isCurved: true,
                          color: chartData[0]['color'] as Color,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: chartData[0]['color'] as Color,
                                strokeWidth: 2,
                                strokeColor: theme.colorScheme.surface,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: (chartData[0]['color'] as Color).withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                      ],
                minY: 0,
                maxY: maxValue > 0 ? maxValue * 1.2 : 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Legend Item Widget
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: AppTheme.fontFamily,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
      ],
    );
  }
}
