import 'package:flutter/material.dart';

class TodoTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const TodoTextFieldWidget({required this.controller, super.key});

  @override
  State<TodoTextFieldWidget> createState() => _TodoTextFieldWidgetState();
}

class _TodoTextFieldWidgetState extends State<TodoTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 5,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: widget.controller,
            maxLines: 10,
            minLines: 1,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
