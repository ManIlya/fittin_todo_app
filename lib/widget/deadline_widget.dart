import 'package:flutter/material.dart';

import '../services.dart';

class DeadlineWidget extends StatefulWidget {
  DateTime? dateTime;

  DeadlineWidget({this.dateTime, super.key});

  @override
  State<DeadlineWidget> createState() => _DeadlineWidgetState();
}

class _DeadlineWidgetState extends State<DeadlineWidget> {
  Future<void> createDate() async {
    var newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    setState(() {
      widget.dateTime = newDate;
    });
  }

  void deleteDate() {
    setState(() {
      widget.dateTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: widget.dateTime != null,
      onChanged: (_) {
        if (widget.dateTime == null) {
          createDate();
        } else {
          deleteDate();
        }
      },
      //fillColor: MaterialStateProperty.all(Colors.green),
      controlAffinity: ListTileControlAffinity.trailing,
      title: const Text('Дедлайн'),
      subtitle: widget.dateTime != null
          ? Text(convertDateFormat(widget.dateTime!))
          : null,
    );
  }
}
