import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../state/booking_state.dart';

/// Form Field Editor Screen for managing booking form fields
class FormFieldEditorScreen extends StatefulWidget {
  const FormFieldEditorScreen({super.key});

  @override
  State<FormFieldEditorScreen> createState() => _FormFieldEditorScreenState();
}

class _FormFieldEditorScreenState extends State<FormFieldEditorScreen> {
  final BookingState _bookingState = Get.find<BookingState>();
  late List<BookingField> _formFields;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, TextEditingController> _optionControllers = {};

  @override
  void initState() {
    super.initState();
    // Get default form fields template
    _formFields = List.from(
      _bookingState.getFieldsForServiceType('Service Booking'),
    );
    _initializeControllers();
  }

  void _initializeControllers() {
    for (var field in _formFields) {
      _controllers[field.id] = TextEditingController(text: field.label);
      if (field.placeholder != null) {
        _controllers['${field.id}_placeholder'] = TextEditingController(
          text: field.placeholder,
        );
      }
      if (field.options != null && field.options!.isNotEmpty) {
        _optionControllers[field.id] = TextEditingController(
          text: field.options!.join(', '),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var controller in _optionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addField() {
    setState(() {
      final newId = 'field_${DateTime.now().millisecondsSinceEpoch}';
      _formFields.add(
        BookingField(
          id: newId,
          label: 'New Field',
          type: BookingFieldType.text,
          isRequired: false,
        ),
      );
      _controllers[newId] = TextEditingController(text: 'New Field');
      // Initialize placeholder controller for text fields
      _controllers['${newId}_placeholder'] = TextEditingController();
    });
  }

  void _removeField(int index) {
    setState(() {
      final field = _formFields[index];
      _controllers[field.id]?.dispose();
      _controllers.remove(field.id);
      _controllers['${field.id}_placeholder']?.dispose();
      _controllers.remove('${field.id}_placeholder');
      _optionControllers[field.id]?.dispose();
      _optionControllers.remove(field.id);
      _formFields.removeAt(index);
    });
  }

  void _updateField(int index, BookingField updatedField) {
    setState(() {
      _formFields[index] = updatedField;
    });
  }

  void _saveFields() {
    // Update the form fields template in booking state
    // In a real app, this would save to backend
    Get.snackbar(
      'Success',
      'Form fields updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.success,
      colorText: Colors.white,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
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
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Form Fields',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                              fontFamily: AppTheme.fontFamily,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Customize booking form fields',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                        ],
                      ),
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
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _saveFields,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Header Info Card
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.info.withValues(alpha: 0.1),
                    AppTheme.info.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.info.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.info.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.info,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Customize the booking form fields. Users will see these fields when creating a booking.',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                        fontFamily: AppTheme.fontFamily,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Add Field Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
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
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _addField,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Add New Field',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                              fontFamily: AppTheme.fontFamily,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Fields List
            Expanded(
              child: _formFields.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.surface,
                                    theme.colorScheme.surfaceContainerHighest,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.dividerColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.add_circle_outline_rounded,
                                size: 64,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No fields added yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap "Add New Field" to create your first field',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: AppTheme.fontFamily,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _formFields.length,
                      itemBuilder: (context, index) {
                        return _FormFieldItem(
                          field: _formFields[index],
                          labelController: _controllers[_formFields[index].id]!,
                          placeholderController:
                              _controllers['${_formFields[index].id}_placeholder'],
                          optionsController:
                              _optionControllers[_formFields[index].id],
                          onUpdate: (updatedField) =>
                              _updateField(index, updatedField),
                          onDelete: () => _removeField(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Form Field Item Widget
class _FormFieldItem extends StatefulWidget {
  final BookingField field;
  final TextEditingController labelController;
  final TextEditingController? placeholderController;
  final TextEditingController? optionsController;
  final ValueChanged<BookingField> onUpdate;
  final VoidCallback onDelete;

  const _FormFieldItem({
    required this.field,
    required this.labelController,
    this.placeholderController,
    this.optionsController,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_FormFieldItem> createState() => _FormFieldItemState();
}

class _FormFieldItemState extends State<_FormFieldItem> {
  late BookingField _currentField;

  @override
  void initState() {
    super.initState();
    _currentField = widget.field;
    widget.labelController.addListener(_updateField);
    widget.placeholderController?.addListener(_updateField);
    widget.optionsController?.addListener(_updateField);
  }

  @override
  void dispose() {
    widget.labelController.removeListener(_updateField);
    widget.placeholderController?.removeListener(_updateField);
    widget.optionsController?.removeListener(_updateField);
    super.dispose();
  }

  void _updateField() {
    setState(() {
      List<String>? options;
      if (widget.optionsController != null &&
          widget.optionsController!.text.isNotEmpty) {
        options = widget.optionsController!.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      _currentField = _currentField.copyWith(
        label: widget.labelController.text,
        placeholder: widget.placeholderController?.text.isEmpty == true
            ? null
            : widget.placeholderController?.text,
        options: options?.isEmpty == true ? null : options,
      );
      widget.onUpdate(_currentField);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(_currentField.type);

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
            color: typeColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Type Badge
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  typeColor.withValues(alpha: 0.1),
                  typeColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: typeColor.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getTypeIcon(_currentField.type),
                        size: 16,
                        color: typeColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getFieldTypeName(_currentField.type),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: typeColor,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.error,
                        AppTheme.error.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.error.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onDelete,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: theme.colorScheme.onSurface,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label Field
                TextField(
                  controller: widget.labelController,
                  decoration: InputDecoration(
                    labelText: 'Field Label',
                    hintText: 'Enter field label',
                    prefixIcon: Icon(
                      Icons.label_outline_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.redPrimary,
                        width: 2,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    hintStyle: TextStyle(
                      color: theme.colorScheme.outline,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),

                const SizedBox(height: 16),

                // Type Selector
                DropdownButtonFormField<BookingFieldType>(
                  initialValue: _currentField.type,
                  decoration: InputDecoration(
                    labelText: 'Field Type',
                    prefixIcon: Icon(
                      Icons.category_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.redPrimary,
                        width: 2,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  dropdownColor: theme.colorScheme.surface,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  items: BookingFieldType.values.map((type) {
                    final typeColor = _getTypeColor(type);
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(_getTypeIcon(type), size: 18, color: typeColor),
                          const SizedBox(width: 12),
                          Text(_getFieldTypeName(type)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (type) {
                    if (type != null) {
                      setState(() {
                        _currentField = _currentField.copyWith(type: type);
                        // If changing to dropdown and no options controller exists, create one
                        if (type == BookingFieldType.dropdown &&
                            widget.optionsController == null) {
                          // This will be handled by the parent widget
                        }
                        widget.onUpdate(_currentField);
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Placeholder Field (for text, number, textarea)
                if (_currentField.type == BookingFieldType.text ||
                    _currentField.type == BookingFieldType.number ||
                    _currentField.type == BookingFieldType.textarea)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller:
                            widget.placeholderController ??
                            TextEditingController(),
                        decoration: InputDecoration(
                          labelText: 'Placeholder (Optional)',
                          hintText: 'Enter placeholder text',
                          prefixIcon: Icon(
                            Icons.place_outlined,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.redPrimary,
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: AppTheme.fontFamily,
                          ),
                          hintStyle: TextStyle(
                            color: theme.colorScheme.outline,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Options Field (for dropdown)
                if (_currentField.type == BookingFieldType.dropdown)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller:
                            widget.optionsController ?? TextEditingController(),
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Options (comma-separated)',
                          hintText: 'Option 1, Option 2, Option 3',
                          prefixIcon: Icon(
                            Icons.list_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.redPrimary,
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: AppTheme.fontFamily,
                          ),
                          hintStyle: TextStyle(
                            color: theme.colorScheme.outline,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Required Toggle
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _currentField.isRequired
                          ? AppTheme.redPrimary.withValues(alpha: 0.3)
                          : theme.dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: _currentField.isRequired
                              ? AppTheme.redPrimary.withValues(alpha: 0.2)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Checkbox(
                          value: _currentField.isRequired,
                          onChanged: (value) {
                            setState(() {
                              _currentField = _currentField.copyWith(
                                isRequired: value ?? false,
                              );
                              widget.onUpdate(_currentField);
                            });
                          },
                          activeColor: AppTheme.redPrimary,
                          checkColor: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Required Field',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Users must fill this field',
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(BookingFieldType type) {
    switch (type) {
      case BookingFieldType.text:
        return AppTheme.info;
      case BookingFieldType.number:
        return AppTheme.success;
      case BookingFieldType.date:
        return AppTheme.warning;
      case BookingFieldType.time:
        return AppTheme.warning;
      case BookingFieldType.dropdown:
        return AppTheme.redPrimary;
      case BookingFieldType.checkbox:
        return AppTheme.info;
      case BookingFieldType.textarea:
        return AppTheme.success;
    }
  }

  IconData _getTypeIcon(BookingFieldType type) {
    switch (type) {
      case BookingFieldType.text:
        return Icons.text_fields_rounded;
      case BookingFieldType.number:
        return Icons.numbers_rounded;
      case BookingFieldType.date:
        return Icons.calendar_today_rounded;
      case BookingFieldType.time:
        return Icons.access_time_rounded;
      case BookingFieldType.dropdown:
        return Icons.arrow_drop_down_circle_rounded;
      case BookingFieldType.checkbox:
        return Icons.check_box_rounded;
      case BookingFieldType.textarea:
        return Icons.text_snippet_rounded;
    }
  }

  String _getFieldTypeName(BookingFieldType type) {
    switch (type) {
      case BookingFieldType.text:
        return 'Text';
      case BookingFieldType.number:
        return 'Number';
      case BookingFieldType.date:
        return 'Date';
      case BookingFieldType.time:
        return 'Time';
      case BookingFieldType.dropdown:
        return 'Dropdown';
      case BookingFieldType.checkbox:
        return 'Checkbox';
      case BookingFieldType.textarea:
        return 'Textarea';
    }
  }
}
