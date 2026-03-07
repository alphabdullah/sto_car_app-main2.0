import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../models/booking_model.dart';

/// Dynamic form field widget for booking forms
class DynamicFormField extends StatefulWidget {
  final BookingField field;
  final ValueChanged<dynamic> onChanged;

  const DynamicFormField({
    super.key,
    required this.field,
    required this.onChanged,
  });

  @override
  State<DynamicFormField> createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<DynamicFormField> {
  @override
  Widget build(BuildContext context) {
    switch (widget.field.type) {
      case BookingFieldType.text:
        return TextField(
                  decoration: InputDecoration(
                    labelText: widget.field.label + (widget.field.isRequired ? ' *' : ''),
                    hintText: widget.field.placeholder,
                  ),
          onChanged: (value) => widget.onChanged(value),
        );

      case BookingFieldType.number:
        return TextField(
                  decoration: InputDecoration(
                    labelText: widget.field.label + (widget.field.isRequired ? ' *' : ''),
                    hintText: widget.field.placeholder,
                  ),
          keyboardType: TextInputType.number,
          onChanged: (value) => widget.onChanged(value),
        );

      case BookingFieldType.date:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              widget.onChanged(date.toIso8601String().split('T')[0]);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.field.label + (widget.field.isRequired ? ' *' : ''),
              hintText: widget.field.placeholder ?? AppLocalizations.of(context)!.selectDate,
            ),
            child: Text(widget.field.value?.toString() ?? ''),
          ),
        );

      case BookingFieldType.time:
        return InkWell(
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              widget.onChanged('${time.hour}:${time.minute.toString().padLeft(2, '0')}');
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.field.label + (widget.field.isRequired ? ' *' : ''),
              hintText: widget.field.placeholder ?? AppLocalizations.of(context)!.selectTime,
            ),
            child: Text(widget.field.value?.toString() ?? ''),
          ),
        );

      case BookingFieldType.dropdown:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: widget.field.label + (widget.field.isRequired ? ' *' : ''),
          ),
          items: widget.field.options
                  ?.map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList() ??
              [],
          onChanged: (value) => widget.onChanged(value),
        );

      case BookingFieldType.checkbox:
        return CheckboxListTile(
          title: Text(widget.field.label),
          value: widget.field.value as bool? ?? false,
          onChanged: (value) => widget.onChanged(value),
        );

      case BookingFieldType.textarea:
        return TextField(
                  decoration: InputDecoration(
                    labelText: widget.field.label + (widget.field.isRequired ? ' *' : ''),
                    hintText: widget.field.placeholder,
                  ),
          maxLines: 4,
          onChanged: (value) => widget.onChanged(value),
        );
    }
  }
}

