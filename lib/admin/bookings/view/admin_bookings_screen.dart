import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
// import '../../../state/booking_state.dart';
import '../../../models/booking_model.dart';
import '../controller/admin_booking_controller.dart';
import '../../../core/utils/responsive.dart';

/// Admin bookings management screen
class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final bookingState = Get.put(BookingState()); // Removed
    final controller = Get.put(AdminBookingController());

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
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.redPrimary,
                ),
              ),
            );
          }

          final bookings = controller.bookings;
          final pendingBookings = controller.pendingBookings;

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
                                    AppStrings.manageBookings,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 24 : 32,
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
                                    'Manage and approve bookings',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 16,
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
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Custom Prettier Tabs
                _CustomTabBar(controller: _tabController),

                // Tab Bar View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Pending Tab
                      _PendingBookingsTab(
                        pendingBookings: pendingBookings,
                        controller: controller,
                      ),
                      // All Bookings Tab
                      _AllBookingsTab(
                        bookings: bookings,
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
      bottomNavigationBar: const RoleBottomNav(currentIndex: 3),
    );
  }
}

/// Pending Bookings Tab
class _PendingBookingsTab extends StatelessWidget {
  final List<BookingModel> pendingBookings;
  final AdminBookingController controller;

  const _PendingBookingsTab({
    required this.pendingBookings,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (pendingBookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppTheme.redPrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: _EmptyState(
              icon: Icons.pending_actions_rounded,
              title: 'No Pending Bookings',
              message: 'All bookings have been reviewed',
            ),
          ),
        ),
      );
    }

    return Responsive(
      mobile: RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppTheme.redPrimary,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: pendingBookings.length,
          itemBuilder: (context, index) {
            final booking = pendingBookings[index];
            return _AdminBookingCard(
              booking: booking,
              onApprove: () => controller.approveBooking(booking.id),
              onReject: () => controller.rejectBooking(context, booking.id),
              onView: () => controller.showBookingDetails(context, booking.id),
            );
          },
        ),
      ),
      tablet: RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppTheme.redPrimary,
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 260,
          ),
          itemCount: pendingBookings.length,
          itemBuilder: (context, index) {
            final booking = pendingBookings[index];
            return _AdminBookingCard(
              booking: booking,
              onApprove: () => controller.approveBooking(booking.id),
              onReject: () => controller.rejectBooking(context, booking.id),
              onView: () => controller.showBookingDetails(context, booking.id),
            );
          },
        ),
      ),
      desktop: RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppTheme.redPrimary,
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 280,
          ),
          itemCount: pendingBookings.length,
          itemBuilder: (context, index) {
            final booking = pendingBookings[index];
            return _AdminBookingCard(
              booking: booking,
              onApprove: () => controller.approveBooking(booking.id),
              onReject: () => controller.rejectBooking(context, booking.id),
              onView: () => controller.showBookingDetails(context, booking.id),
            );
          },
        ),
      ),
    );
  }
}

/// All Bookings Tab
class _AllBookingsTab extends StatelessWidget {
  final List<BookingModel> bookings;
  final AdminBookingController controller;

  const _AllBookingsTab({required this.bookings, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppTheme.redPrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: _EmptyState(
              icon: Icons.calendar_today_rounded,
              title: 'No Bookings',
              message: 'No bookings have been created yet',
            ),
          ),
        ),
      );
    }

    return Responsive(
      mobile: RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppTheme.redPrimary,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _AdminBookingCard(
              booking: booking,
              onApprove: booking.isPending
                  ? () => controller.approveBooking(booking.id)
                  : null,
              onReject: booking.isPending
                  ? () => controller.rejectBooking(context, booking.id)
                  : null,
              onView: () => controller.showBookingDetails(context, booking.id),
            );
          },
        ),
      ),
      tablet: RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppTheme.redPrimary,
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 260,
          ),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _AdminBookingCard(
              booking: booking,
              onApprove: booking.isPending
                  ? () => controller.approveBooking(booking.id)
                  : null,
              onReject: booking.isPending
                  ? () => controller.rejectBooking(context, booking.id)
                  : null,
              onView: () => controller.showBookingDetails(context, booking.id),
            );
          },
        ),
      ),
      desktop: RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppTheme.redPrimary,
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 280,
          ),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _AdminBookingCard(
              booking: booking,
              onApprove: booking.isPending
                  ? () => controller.approveBooking(booking.id)
                  : null,
              onReject: booking.isPending
                  ? () => controller.rejectBooking(context, booking.id)
                  : null,
              onView: () => controller.showBookingDetails(context, booking.id),
            );
          },
        ),
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
              label: 'Pending',
              index: 0,
              controller: controller,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _CustomTab(
              label: 'All Bookings',
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

/// Admin Booking Card
class _AdminBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback onView;

  const _AdminBookingCard({
    required this.booking,
    this.onApprove,
    this.onReject,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(context, booking.status);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;

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
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Service Type and Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.serviceType,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: isSmallScreen ? 6 : 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_rounded,
                                    size: isSmallScreen ? 14 : 16,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: isSmallScreen ? 4 : 4),
                                  Flexible(
                                    child: Text(
                                      booking.userName,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontFamily: AppTheme.fontFamily,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 10 : 12,
                            vertical: isSmallScreen ? 5 : 6,
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
                            _getStatusText(booking.status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: isSmallScreen ? 11 : 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // Date Information
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: isSmallScreen ? 14 : 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: isSmallScreen ? 6 : 8),
                          Flexible(
                            child: Text(
                              'Created: ${booking.createdAt.toString().split(' ')[0]}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: AppTheme.fontFamily,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Action Buttons
                    LayoutBuilder(
                      builder: (context, buttonConstraints) {
                        final isButtonSmallScreen =
                            buttonConstraints.maxWidth < 400;
                        final hasActions =
                            onApprove != null || onReject != null;

                        if (isButtonSmallScreen && hasActions) {
                          // Stack vertically on small screens when there are multiple actions
                          return Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: _ActionButton(
                                  label: 'View Details',
                                  icon: Icons.visibility_rounded,
                                  color: AppTheme.info,
                                  onPressed: onView,
                                  isSmallScreen: true,
                                ),
                              ),
                              if (onApprove != null || onReject != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (onApprove != null)
                                      Expanded(
                                        child: _ActionButton(
                                          label: AppStrings.approve,
                                          icon: Icons.check_circle_rounded,
                                          color: AppTheme.success,
                                          onPressed: onApprove!,
                                          isSmallScreen: true,
                                        ),
                                      ),
                                    if (onApprove != null && onReject != null)
                                      const SizedBox(width: 8),
                                    if (onReject != null)
                                      Expanded(
                                        child: _ActionButton(
                                          label: AppStrings.reject,
                                          icon: Icons.cancel_rounded,
                                          color: AppTheme.error,
                                          onPressed: onReject!,
                                          isSmallScreen: true,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          );
                        } else {
                          // Horizontal layout for larger screens
                          return Row(
                            children: [
                              Expanded(
                                child: _ActionButton(
                                  label: 'View Details',
                                  icon: Icons.visibility_rounded,
                                  color: AppTheme.info,
                                  onPressed: onView,
                                  isSmallScreen: isButtonSmallScreen,
                                ),
                              ),
                              if (onApprove != null || onReject != null) ...[
                                SizedBox(width: isButtonSmallScreen ? 8 : 12),
                                if (onApprove != null)
                                  Expanded(
                                    child: _ActionButton(
                                      label: AppStrings.approve,
                                      icon: Icons.check_circle_rounded,
                                      color: AppTheme.success,
                                      onPressed: onApprove!,
                                      isSmallScreen: isButtonSmallScreen,
                                    ),
                                  ),
                                if (onApprove != null && onReject != null)
                                  SizedBox(width: isButtonSmallScreen ? 8 : 12),
                                if (onReject != null)
                                  Expanded(
                                    child: _ActionButton(
                                      label: AppStrings.reject,
                                      icon: Icons.cancel_rounded,
                                      color: AppTheme.error,
                                      onPressed: onReject!,
                                      isSmallScreen: isButtonSmallScreen,
                                    ),
                                  ),
                              ],
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Color _getStatusColor(BuildContext context, BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppTheme.warning;
      case BookingStatus.approved:
        return AppTheme.success;
      case BookingStatus.rejected:
        return AppTheme.error;
      case BookingStatus.completed:
        return AppTheme.info;
      case BookingStatus.cancelled:
        return Theme.of(context).colorScheme.outline;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppStrings.pending;
      case BookingStatus.approved:
        return AppStrings.approved;
      case BookingStatus.rejected:
        return AppStrings.rejected;
      case BookingStatus.completed:
        return AppStrings.completed;
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Action Button Widget
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isSmallScreen;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isSmallScreen = false,
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
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 10 : 12,
              horizontal: isSmallScreen ? 8 : 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: isSmallScreen ? 16 : 18,
                ),
                SizedBox(width: isSmallScreen ? 4 : 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
