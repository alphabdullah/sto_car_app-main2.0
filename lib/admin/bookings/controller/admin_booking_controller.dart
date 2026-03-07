import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/booking_model.dart';
import '../../../services/admin_service.dart';

/// Admin booking controller (MVC pattern - Controller layer)
class AdminBookingController extends GetxController {
  // final BookingState _bookingState = BookingState(); // Removed dependency on BookingState
  final AdminService _adminService = AdminService();
  final _rejectNotesController = TextEditingController();
  final _bookings = <BookingModel>[].obs;
  final _isLoading = false.obs;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading.value;
  List<BookingModel> get pendingBookings => _bookings.where((b) => b.isPending).toList();

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  @override
  void onClose() {
    _rejectNotesController.dispose();
    super.onClose();
  }

  /// Load bookings from Admin API
  Future<void> loadBookings() async {
    _isLoading.value = true;
    try {
      final data = await _adminService.getServiceBookings();
      _bookings.value = data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      final ctx = Get.context;
      Get.snackbar(
        ctx != null ? AppLocalizations.of(ctx)!.error : 'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> approveBooking(String bookingId) async {
    try {
      await _adminService.approveBooking(bookingId);
      
      // Update local state
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(status: BookingStatus.approved);
         _bookings.refresh();
      }

      final ctx = Get.context;
      Get.snackbar(
        ctx != null ? AppLocalizations.of(ctx)!.success : 'Success',
        ctx != null ? AppLocalizations.of(ctx)!.bookingApprovedSuccessfully : 'Booking approved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
       final ctx = Get.context;
       Get.snackbar(
        ctx != null ? AppLocalizations.of(ctx)!.error : 'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> rejectBooking(BuildContext context, String bookingId) async {
    _rejectNotesController.clear();
    final reasonController = TextEditingController();

    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.rejectBookingTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.rejectBookingConfirmMessage),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: l.rejectionReasonLabel,
                hintText: l.rejectionReasonHint,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rejectNotesController,
              decoration: InputDecoration(
                labelText: l.additionalNotesLabel,
                hintText: l.additionalNotesHint,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                Get.snackbar(l.error, l.rejectionReasonRequired);
                return;
              }
              Navigator.pop(dialogContext, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l.reject),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _adminService.rejectBooking(
          bookingId,
          reason: reasonController.text,
          notes: _rejectNotesController.text,
        );
        
        // Update local state
        final index = _bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          _bookings[index] = _bookings[index].copyWith(
            status: BookingStatus.rejected,
            adminNotes: '${reasonController.text} - ${_rejectNotesController.text}',
          );
          _bookings.refresh();
        }

        final ctx = Get.context;
        Get.snackbar(
          ctx != null ? AppLocalizations.of(ctx)!.success : 'Success',
          ctx != null ? AppLocalizations.of(ctx)!.bookingRejected : 'Booking rejected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        final ctx = Get.context;
        Get.snackbar(
          ctx != null ? AppLocalizations.of(ctx)!.error : 'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void showBookingDetails(BuildContext context, String bookingId) {
    final booking = _bookings.firstWhereOrNull((b) => b.id == bookingId);

    if (booking == null) return;

    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${booking.serviceType} ${l.details}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: l.bookingIdLabel, value: booking.formData['bookingNumber'] ?? booking.id),
              _DetailRow(label: l.userLabel, value: booking.userName),
              _DetailRow(label: l.statusLabel, value: _getStatusText(context, booking.status)),
              _DetailRow(label: l.dateLabel, value: booking.scheduledDate?.toString().split(' ')[0] ?? 'N/A'),
              _DetailRow(label: l.timeLabel, value: booking.formData['time']?.toString() ?? 'N/A'),
              const Divider(height: 24),
              Text(l.vehicleDetails, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _DetailRow(label: l.carLabel, value: booking.formData['carName']?.toString() ?? 'N/A'),
              _DetailRow(label: l.modelLabel, value: booking.formData['carModel']?.toString() ?? 'N/A'),
              const Divider(height: 24),
              Text(l.contactInfo, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _DetailRow(label: l.phoneLabel, value: booking.formData['phoneNumber']?.toString() ?? 'N/A'),
              if (booking.notes != null) ...[
                const Divider(height: 24),
                Text(l.descriptionNotes, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(booking.notes!),
              ],
              if (booking.adminNotes != null) ...[
                const Divider(height: 24),
                Text(l.adminNotes, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 4),
                Text(booking.adminNotes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.close),
          ),
        ],
      ),
    );
  }

  String _getStatusText(BuildContext context, BookingStatus status) {
    final l = AppLocalizations.of(context)!;
    switch (status) {
      case BookingStatus.pending:
        return l.pending;
      case BookingStatus.approved:
        return l.approved;
      case BookingStatus.rejected:
        return l.rejected;
      case BookingStatus.completed:
        return l.completed;
      case BookingStatus.cancelled:
        return l.cancelled;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

