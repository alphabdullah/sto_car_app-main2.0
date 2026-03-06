import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/booking_controller.dart';
import '../../../core/utils/responsive.dart';

/// New Booking Form Screen
class NewBookingScreen extends StatelessWidget {
  const NewBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(BookingController());

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
          Column(
            children: [
              // Back Button and Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 24,
                      ),
                      onPressed: () => context.pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Book a Service',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                          fontFamily: AppTheme.fontFamily,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _BookingForm(controller: controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Booking Form Widget
class _BookingForm extends StatelessWidget {
  final BookingController controller;

  const _BookingForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Service Icon Header
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.redPrimary.withValues(alpha: 0.15),
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
              child: Image.asset(
                'assets/images/repair.png',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.build_circle_outlined,
                    size: 64,
                    color: AppTheme.redPrimary,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Name Field
          _FormField(
            label: 'Full Name',
            controller: controller.nameController,
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            hintText: 'Enter your full name',
          ),

          const SizedBox(height: 20),

          // Phone Number Field
          _FormField(
            label: 'Phone Number',
            controller: controller.phoneController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            hintText: 'Enter your phone number',
          ),

          const SizedBox(height: 20),

          // Car Name Field
          _FormField(
            label: 'Car Name',
            controller: controller.carNameController,
            icon: Icons.directions_car_outlined,
            keyboardType: TextInputType.text,
            hintText: 'e.g., BMW, Mercedes',
          ),

          const SizedBox(height: 20),

          // Car Model Field
          _FormField(
            label: 'Car Model',
            controller: controller.carModelController,
            icon: Icons.build_outlined,
            keyboardType: TextInputType.text,
            hintText: 'e.g., 3 Series, C-Class',
          ),

          const SizedBox(height: 20),

          // Description Field
          _DescriptionField(controller: controller.descriptionController),

          const SizedBox(height: 20),

          // Date Picker Field
          _DatePickerField(
            selectedDate: controller.selectedDate.value,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  final t = Theme.of(context);
                  return Theme(
                    data: t.copyWith(
                      colorScheme: t.colorScheme.copyWith(
                        primary: AppTheme.redPrimary,
                        onPrimary: Colors.white,
                        surface: t.colorScheme.surface,
                        onSurface: t.colorScheme.onSurface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                controller.selectedDate.value = date;
              }
            },
          ),

          const SizedBox(height: 20),

          // Time Picker Field
          _TimePickerField(
            selectedTime: controller.selectedTime.value,
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: controller.selectedTime.value ?? TimeOfDay.now(),
                builder: (context, child) {
                  final t = Theme.of(context);
                  return Theme(
                    data: t.copyWith(
                      colorScheme: t.colorScheme.copyWith(
                        primary: AppTheme.redPrimary,
                        onPrimary: Colors.white,
                        surface: t.colorScheme.surface,
                        onSurface: t.colorScheme.onSurface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (time != null) {
                controller.selectedTime.value = time;
              }
            },
          ),

          const SizedBox(height: 32),

          // Submit Button
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.redPrimary, AppTheme.redPressed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.redPrimary.withValues(alpha: 0.6),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppTheme.redPrimary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.isLoading
                    ? null
                    : () => controller.submitBooking(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  alignment: Alignment.center,
                  child: controller.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Submit Booking',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontFamily: AppTheme.fontFamily,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      );
    });
  }
}

/// Form Field Widget
class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final String hintText;

  const _FormField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.keyboardType,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontFamily: AppTheme.fontFamily,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.redPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.redPrimary, size: 22),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.redPrimary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }
}

/// Description Field Widget
class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const _DescriptionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Enter service description or additional notes',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontFamily: AppTheme.fontFamily,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.redPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: AppTheme.redPrimary,
                  size: 22,
                ),
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.redPrimary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }
}

/// Date Picker Field Widget
class _DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const _DatePickerField({required this.selectedDate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Date',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.redPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: AppTheme.redPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                        : 'Select preferred date',
                    style: TextStyle(
                      color: selectedDate != null
                          ? AppTheme.textPrimary
                          : AppTheme.textMuted,
                      fontSize: 16,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Time Picker Field Widget
class _TimePickerField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onTap;

  const _TimePickerField({required this.selectedTime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Time',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: AppTheme.fontFamily,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.redPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: AppTheme.redPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selectedTime != null
                        ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                        : 'Select preferred time',
                    style: TextStyle(
                      color: selectedTime != null
                          ? AppTheme.textPrimary
                          : AppTheme.textMuted,
                      fontSize: 16,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
