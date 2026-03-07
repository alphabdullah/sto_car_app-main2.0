import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/booking_model.dart';

/// Reusable booking details widget. Use as a dialog or embed the content elsewhere.
///
/// As dialog:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (c) => BookingDetailsDialog(booking: booking),
/// );
/// ```
/// Or use the static helper:
/// ```dart
/// BookingDetailsDialog.show(context, booking);
/// ```
///
/// To show in a route/screen, use [BookingDetailsContent] for the body.
class BookingDetailsDialog extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsDialog({super.key, required this.booking});

  /// Convenience: show the booking details as a dialog.
  static Future<void> show(BuildContext context, BookingModel booking) {
    return showDialog(
      context: context,
      builder: (context) => BookingDetailsDialog(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(booking.status);
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.85;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: maxHeight),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BookingDetailsHeader(
              booking: booking,
              statusColor: statusColor,
              onClose: () => Navigator.pop(context),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: BookingDetailsContent(booking: booking),
              ),
            ),
            // _BookingDetailsCloseButton(onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  static Color _getStatusColor(BookingStatus status) {
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
        return AppTheme.textMuted; // Keep for dialog; theme not available in static
    }
  }
}

/// Header section with service type, status badge, and close button.
class _BookingDetailsHeader extends StatelessWidget {
  final BookingModel booking;
  final Color statusColor;
  final VoidCallback onClose;

  const _BookingDetailsHeader({
    required this.booking,
    required this.statusColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.15),
            statusColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
            child: const Icon(
              Icons.build_circle_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.serviceType,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getStatusIcon(booking.status),
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _getStatusText(context, booking.status),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(color: theme.dividerColor, width: 1),
            ),
            child: IconButton(
              icon: Icon(Icons.close_rounded, color: theme.colorScheme.onSurfaceVariant),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }

  static IconData _getStatusIcon(BookingStatus status) {
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

  static String _getStatusText(BuildContext context, BookingStatus status) {
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
        return AppLocalizations.of(context)!.cancelled;
    }
  }
}

/// Reusable scrollable content showing all booking details.
/// Use this when you want to embed booking details in a screen (e.g. admin view).
class BookingDetailsContent extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsContent({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.bookingDetails,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        const SizedBox(height: 20),
        _BookingDetailCard(
          icon: Icons.confirmation_number_outlined,
          iconColor: AppTheme.redPrimary,
          label: AppLocalizations.of(context)!.bookingNumberFull,
          value: _detailValue(booking.formData['bookingNumber']) != '—'
              ? _detailValue(booking.formData['bookingNumber'])
              : (booking.id.isNotEmpty ? booking.id : '—'),
        ),
        const SizedBox(height: 12),
        _BookingDetailCard(
          icon: Icons.person_outline_rounded,
          iconColor: AppTheme.info,
          label: AppLocalizations.of(context)!.fullName,
          value: _detailValue(booking.formData['name'] ?? booking.userName),
        ),
        const SizedBox(height: 12),
        _BookingDetailCard(
          icon: Icons.phone_outlined,
          iconColor: AppTheme.success,
          label: AppLocalizations.of(context)!.phoneNumber,
          value: _detailValue(booking.formData['phoneNumber']),
        ),
        const SizedBox(height: 12),
        _BookingDetailCard(
          icon: Icons.directions_car_outlined,
          iconColor: AppTheme.warning,
          label: AppLocalizations.of(context)!.carName,
          value: _detailValue(booking.formData['carName']),
        ),
        const SizedBox(height: 12),
        _BookingDetailCard(
          icon: Icons.build_outlined,
          iconColor: AppTheme.redPrimary,
          label: AppLocalizations.of(context)!.carModel,
          value: _detailValue(booking.formData['carModel']),
        ),
        const SizedBox(height: 12),
        _BookingDetailCard(
          icon: Icons.calendar_today_rounded,
          iconColor: AppTheme.info,
          label: AppLocalizations.of(context)!.preferredDate,
          value: _detailValue(booking.formData['date']),
        ),
        const SizedBox(height: 12),
        _BookingDetailCard(
          icon: Icons.access_time_rounded,
          iconColor: AppTheme.info,
          label: AppLocalizations.of(context)!.preferredTime,
          value: _detailValue(booking.formData['time']),
        ),
        if (_detailValue(booking.formData['description']) != '—') ...[
          const SizedBox(height: 12),
          _BookingDetailCard(
            icon: Icons.description_outlined,
            iconColor: AppTheme.warning,
            label: AppLocalizations.of(context)!.description,
            value: _detailValue(booking.formData['description']),
          ),
        ],
        const SizedBox(height: 12),
        _BookingDetailCard(
          icon: Icons.calendar_month_outlined,
          iconColor: theme.colorScheme.onSurfaceVariant,
          label: AppLocalizations.of(context)!.createdAt,
          value:
              '${booking.createdAt.year}-${booking.createdAt.month.toString().padLeft(2, '0')}-${booking.createdAt.day.toString().padLeft(2, '0')} ${booking.createdAt.hour.toString().padLeft(2, '0')}:${booking.createdAt.minute.toString().padLeft(2, '0')}',
        ),
        if (booking.adminNotes != null && booking.adminNotes!.isNotEmpty) ...[
          const SizedBox(height: 32),
          Divider(color: theme.dividerColor, height: 1),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.warning.withValues(alpha: 0.3), width: 1),
                ),
                child: Icon(Icons.note_alt_outlined,
                    color: AppTheme.warning, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.adminNotes,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.warning.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Text(
              booking.adminNotes!,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 15,
                height: 1.5,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

String _detailValue(dynamic value) {
  if (value == null) return '—';
  final s = value.toString().trim();
  return s.isEmpty ? '—' : s;
}

class _BookingDetailCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _BookingDetailCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withValues(alpha: 0.2),
                  iconColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: iconColor.withValues(alpha: 0.3), width: 1),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _BookingDetailsCloseButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   const _BookingDetailsCloseButton({required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppTheme.redPrimary, AppTheme.redPressed],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: const [0.0, 0.5, 1.0],
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: AppTheme.redPrimary.withValues(alpha: 0.4),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: onPressed,
//             borderRadius: BorderRadius.circular(16),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: AppTheme.textPrimary.withValues(alpha: 0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(Icons.check_rounded,
//                         size: 18, color: AppTheme.textPrimary),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     'Close',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppTheme.textPrimary,
//                       fontFamily: AppTheme.fontFamily,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
