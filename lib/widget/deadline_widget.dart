import 'package:flutter/material.dart';

import '../services.dart';

class DeadlineWidget extends StatefulWidget {
  final DateTime? dateTime;
  final ValueChanged<DateTime?> onDateChanged;

  const DeadlineWidget({this.dateTime, required this.onDateChanged,  super.key});

  @override
  State<DeadlineWidget> createState() => _DeadlineWidgetState();
}

class _DeadlineWidgetState extends State<DeadlineWidget> {
  DateTime? _date;
  Future<void> createDate() async {
    var newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    setState(() {
      _date = newDate;
      widget.onDateChanged(newDate);
    });
  }

  void deleteDate() {
    setState(() {
      widget.onDateChanged(null);
    });
  }
  @override
  void initState() {
    _date = widget.dateTime;
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _date != null,
      onChanged: (_) {
        if (_date == null) {
          createDate();
        } else {
          deleteDate();
        }
      },
      //fillColor: MaterialStateProperty.all(Colors.green),
      controlAffinity: ListTileControlAffinity.trailing,
      title: const Text('Дедлайн'),
      subtitle: _date != null
          ? Text(convertDateFormat(_date!))
          : null,
    );
  }
}
