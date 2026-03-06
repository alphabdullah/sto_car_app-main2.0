import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/guards/auth_guard_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/booking_state.dart';
import '../../../state/auth_state.dart';
import '../../../models/booking_model.dart';
import '../controller/booking_controller.dart';
import '../../../core/utils/responsive.dart';

/// Unified bookings screen - requires authentication
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = Get.put(AuthState());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: AuthGuardWidget(
        actionDescription: 'Login to view and create bookings',
        child: Responsive.constrained(_BookingsContent()),
      ),
      bottomNavigationBar: Obx(
        () => authState.isAuthenticated
            ? const RoleBottomNav(currentIndex: 1)
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _BookingsContent extends StatefulWidget {
  @override
  State<_BookingsContent> createState() => _BookingsContentState();
}

class _BookingsContentState extends State<_BookingsContent> {
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    // Load bookings when screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingState = Get.find<BookingState>();
      if (!_hasLoadedOnce) {
        _hasLoadedOnce = true;
        bookingState.loadBookings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = Get.put(BookingState());
    final controller = Get.put(BookingController());

    return Obx(() {
      final bookings = bookingState.bookings;
      final bookingsCount = bookings.length;
      final isLoading = bookingState.isLoading;

      // Show loading indicator while loading and no bookings exist
      if (isLoading && bookings.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.redPrimary),
          ),
        );
      }

      if (bookings.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await bookingState.loadBookings(forceRefresh: true);
          },
          color: AppTheme.redPrimary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: _EmptyBookingsView(controller: controller),
            ),
          ),
        );
      }

      return Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Bookings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontFamily: AppTheme.fontFamily,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$bookingsCount ${bookingsCount == 1 ? 'booking' : 'bookings'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.redPrimary, AppTheme.redPressed],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.redPrimary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.showBookingForm(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/new.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 24,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bookings List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await bookingState.loadBookings(forceRefresh: true);
              },
              color: AppTheme.redPrimary,
              child: Responsive(
                mobile: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _BookingCard(
                      booking: booking,
                      onTap: () =>
                          controller.showBookingDetails(context, booking.id),
                    );
                  },
                ),
                tablet: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 320,
                  ),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _BookingCard(
                      booking: booking,
                      onTap: () =>
                          controller.showBookingDetails(context, booking.id),
                    );
                  },
                ),
                desktop: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    mainAxisExtent: 340,
                  ),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _BookingCard(
                      booking: booking,
                      onTap: () =>
                          controller.showBookingDetails(context, booking.id),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

/// Empty bookings view
class _EmptyBookingsView extends StatelessWidget {
  final BookingController controller;

  const _EmptyBookingsView({required this.controller});

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
              child: Icon(
                Icons.calendar_today_outlined,
                size: 64,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Bookings Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Book your first service appointment',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: AppTheme.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [AppTheme.redPrimary, AppTheme.redPressed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => controller.showBookingForm(context),
                icon: Image.asset(
                  'assets/images/new.png',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.add, size: 22);
                  },
                ),
                label: const Text(
                  'Book a Service',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Booking card widget
class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const _BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(context, booking.status);
    final carInfo = _getCarInfo(booking);
    final time = booking.formData['time']?.toString() ?? '';
    final phone = booking.formData['phoneNumber']?.toString() ?? '';
    final name = booking.formData['name']?.toString() ?? booking.userName;
    final date = booking.formData['date']?.toString() ?? '';
    final bookingNumber =
        booking.formData['bookingNumber']?.toString() ?? booking.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              statusColor.withValues(alpha: 0.2),
                              statusColor.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(booking.status),
                              color: statusColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getStatusText(booking.status),
                              style: TextStyle(
                                fontSize: 13,
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTheme.fontFamily,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Service Type Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.redPrimary.withValues(alpha: 0.15),
                              AppTheme.redPressed.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.redPrimary.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.build_circle_outlined,
                          color: AppTheme.redPrimary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Service Type
                  Text(
                    booking.serviceType,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      fontFamily: AppTheme.fontFamily,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Details Grid (API: full_name, car_name, car_model, prefered_time, prefered_date, phone_number)
                  if (carInfo.isNotEmpty ||
                      time.isNotEmpty ||
                      phone.isNotEmpty ||
                      name.isNotEmpty ||
                      date.isNotEmpty ||
                      bookingNumber.isNotEmpty)
                    Column(
                      children: [
                        // if (name.isNotEmpty) ...[
                        //   _InfoRow(
                        //     icon: Icons.person_outline_rounded,
                        //     label: 'Name',
                        //     value: name,
                        //     iconColor: Colors.purple,
                        //   ),
                        //   const SizedBox(height: 12),
                        // ],
                        if (carInfo.isNotEmpty) ...[
                          _InfoRow(
                            icon: Icons.directions_car,
                            label: 'Vehicle',
                            value: carInfo,
                            iconColor: Colors.blue,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (date.isNotEmpty) ...[
                          _InfoRow(
                            icon: Icons.calendar_today_rounded,
                            label: 'Date',
                            value: date,
                            iconColor: Colors.teal,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (time.isNotEmpty) ...[
                          _InfoRow(
                            icon: Icons.access_time,
                            label: 'Time',
                            value: time,
                            iconColor: Colors.orange,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (phone.isNotEmpty) ...[
                          _InfoRow(
                            icon: Icons.phone,
                            label: 'Phone',
                            value: phone,
                            iconColor: Colors.green,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (bookingNumber.isNotEmpty &&
                            carInfo.isEmpty &&
                            phone.isEmpty) ...[
                          _InfoRow(
                            icon: Icons.confirmation_number_outlined,
                            label: 'Booking #',
                            value: bookingNumber,
                            iconColor: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ],
                    ),

                  const SizedBox(height: 18),

                  // View Details Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.surfaceContainerHighest, theme.colorScheme.surface],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.dividerColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                  fontFamily: AppTheme.fontFamily,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: theme.colorScheme.onSurface,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCarInfo(BookingModel booking) {
    // Check for vehicle_make and vehicle_model (from API)
    final vehicleMake = booking.formData['carName']?.toString() ?? '';
    final vehicleModel = booking.formData['carModel']?.toString() ?? '';
    final vehicleYear = booking.formData['carYear']?.toString();

    final parts = <String>[];
    if (vehicleMake.isNotEmpty) parts.add(vehicleMake);
    if (vehicleModel.isNotEmpty) parts.add(vehicleModel);
    if (vehicleYear != null && vehicleYear.isNotEmpty) parts.add(vehicleYear);

    if (parts.isNotEmpty) {
      return parts.join(' ');
    }
    return '';
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.pending;
      case BookingStatus.approved:
        return Icons.check_circle;
      case BookingStatus.rejected:
        return Icons.cancel;
      case BookingStatus.completed:
        return Icons.done_all;
      case BookingStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  Color _getStatusColor(BuildContext context, BookingStatus status) {
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

/// Info Row Widget for Booking Card
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                iconColor.withValues(alpha: 0.15),
                iconColor.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.fontFamily,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontFamily,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
