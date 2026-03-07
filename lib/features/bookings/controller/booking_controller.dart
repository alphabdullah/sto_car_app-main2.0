import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/booking_state.dart';
import '../../../services/booking_service.dart';
import '../../../core/api/api_client.dart' as api;
import '../widgets/booking_details_dialog.dart';

/// Unified booking controller for authenticated users
class BookingController extends GetxController {
  final BookingState _bookingState = BookingState();

  // Form fields - made public for form screen
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final carModelController = TextEditingController();
  final carNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedTime = Rxn<TimeOfDay>();
  final selectedDate = Rxn<DateTime>();
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    carModelController.dispose();
    carNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void showBookingForm(BuildContext context) {
    // Clear form
    nameController.clear();
    phoneController.clear();
    carModelController.clear();
    carNameController.clear();
    descriptionController.clear();
    selectedTime.value = null;
    selectedDate.value = null;

    // Navigate to new booking screen
    context.push(AppConstants.routeNewBooking);
  }

  Future<void> submitBooking(BuildContext context) async {
    // Validate form
    final l10n = AppLocalizations.of(context)!;
    if (nameController.text.trim().isEmpty) {
      _showError(context, l10n.pleaseEnterName);
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      _showError(context, l10n.pleaseEnterPhone);
      return;
    }
    if (carModelController.text.trim().isEmpty) {
      _showError(context, l10n.pleaseEnterCarModel);
      return;
    }
    if (carNameController.text.trim().isEmpty) {
      _showError(context, l10n.pleaseEnterCarName);
      return;
    }
    if (selectedDate.value == null) {
      _showError(context, l10n.pleaseSelectDate);
      return;
    }
    if (selectedTime.value == null) {
      _showError(context, l10n.pleaseSelectTime);
      return;
    }

    _isLoading.value = true;

    try {
      // Format date as YYYY-MM-DD
      final date = selectedDate.value!;
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Format time as HH:mm
      final time = selectedTime.value!;
      final formattedTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      // Call the API
      final bookingService = BookingService();
      await bookingService.createServiceBooking(
        fullName: nameController.text.trim(),
        carName: carNameController.text.trim(),
        carModel: carModelController.text.trim(),
        description: descriptionController.text.trim(),
        preferedTime: formattedTime,
        preferedDate: formattedDate,
        phoneNumber: phoneController.text.trim(),
      );

      _isLoading.value = false;

      if (context.mounted) {
        // Clear form
        nameController.clear();
        phoneController.clear();
        carModelController.clear();
        carNameController.clear();
        descriptionController.clear();
        selectedTime.value = null;
        selectedDate.value = null;

        // Navigate back
        context.pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.bookingSubmittedSuccess),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } on api.ApiException catch (e) {
      _isLoading.value = false;
      if (context.mounted) {
        _showError(context, e.message);
      }
    } catch (e) {
      _isLoading.value = false;
      if (context.mounted) {
        _showError(
          context,
          AppLocalizations.of(context)!.failedToSubmitBooking(e.toString()),
        );
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void showBookingDetails(BuildContext context, String bookingId) {
    _bookingState.selectBooking(bookingId);
    final booking = _bookingState.selectedBooking;

    if (booking == null) return;

    BookingDetailsDialog.show(context, booking);
  }
}
