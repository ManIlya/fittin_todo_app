import 'package:flutter/material.dart';

class TodoTextFieldWidget extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  TodoTextFieldWidget(String? task, {super.key}){
    controller.text = task ?? '';
  }

  @override
  State<TodoTextFieldWidget> createState() => _TodoTextFieldWidgetState();
}

class _TodoTextFieldWidgetState extends State<TodoTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 5,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
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
    );
  }
}
