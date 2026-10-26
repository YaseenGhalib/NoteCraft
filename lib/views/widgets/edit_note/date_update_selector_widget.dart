// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateUpdateMode { original, current, manual }

class DateUpdateSelectorWidget extends StatefulWidget {
  final DateTime originalDate;
  final Function(DateTime) onDateChanged;

  const DateUpdateSelectorWidget({
    super.key,
    required this.originalDate,
    required this.onDateChanged,
  });

  @override
  State<DateUpdateSelectorWidget> createState() =>
      DateUpdateSelectorWidgetState();
}

class DateUpdateSelectorWidgetState extends State<DateUpdateSelectorWidget> {
  DateUpdateMode selectedMode = DateUpdateMode.original;
  late DateTime chosenDate;

  @override
  void initState() {
    super.initState();
    chosenDate = widget.originalDate;
  }

  Future<void> _pickManualDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: chosenDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(chosenDate),
      );

      if (pickedTime != null) {
        setState(() {
          chosenDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          selectedMode = DateUpdateMode.manual;
        });
        widget.onDateChanged(chosenDate);
      }
    }
  }

  void updateMode(DateUpdateMode mode) {
    setState(() {
      selectedMode = mode;
      if (mode == DateUpdateMode.original) {
        chosenDate = widget.originalDate;
      } else if (mode == DateUpdateMode.current) {
        chosenDate = DateTime.now();
      }
    });
    widget.onDateChanged(chosenDate);
  }

  @override
  Widget build(BuildContext context) {
    final originalString = DateFormat('yyyy-MM-dd hh:mm a')
        .format(widget.originalDate);
    final manualString = DateFormat('yyyy-MM-dd hh:mm a').format(chosenDate);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Material(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip
            .antiAlias, // يضمن قص حواف الـ ListTile لتتناسب مع انحناء الحاوية
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تاريخ ووقت الملاحظة:',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              ListTile(
                title: Text(
                  'تاريخ الإدخال الأول ($originalString)',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                leading: Radio<DateUpdateMode>(
                  value: DateUpdateMode.original,
                  groupValue: selectedMode,
                  activeColor: Colors.amberAccent,
                  onChanged: (val) => updateMode(val!),
                ),
                onTap: () => updateMode(DateUpdateMode.original),
              ),

              ListTile(
                title: const Text(
                  'تحديث بالوقت الحالي الآن',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                leading: Radio<DateUpdateMode>(
                  value: DateUpdateMode.current,
                  groupValue: selectedMode,
                  activeColor: Colors.amberAccent,
                  onChanged: (val) => updateMode(val!),
                ),
                onTap: () => updateMode(DateUpdateMode.current),
              ),

              ListTile(
                title: Row(
                  children: [
                    const Text(
                      'إدخال تاريخ مخصص يدوياً ',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    if (selectedMode == DateUpdateMode.manual)
                      Expanded(
                        child: Text(
                          '($manualString)',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                leading: Radio<DateUpdateMode>(
                  value: DateUpdateMode.manual,
                  groupValue: selectedMode,
                  activeColor: Colors.amberAccent,
                  onChanged: (val) => _pickManualDate(),
                ),
                onTap: _pickManualDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
