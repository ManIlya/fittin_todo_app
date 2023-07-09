import 'package:flutter/material.dart';
import 'package:todo_app/empty.dart';
import 'package:todo_app/widget/todo_editing_text_widget.dart';

import '../widget/deadline_widget.dart';

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  State<TodoAddPage> createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {

  late DeadlineWidget deadlineWidget;
  late TodoTextFieldWidget todoTextFieldWidget;


  @override
  void initState() {
    super.initState();
    deadlineWidget= DeadlineWidget(null);
    todoTextFieldWidget = TodoTextFieldWidget(null);
  }

  void createTodo() {
    if (todoTextFieldWidget.controller.value.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Вы не ввели задание'),
        ),
      );
    } else {
      var newTodo = TodoEmpty(
          id: UniqueKey().hashCode,
          task: todoTextFieldWidget.controller.value.text,
          date: deadlineWidget.dateTime);
      Navigator.pop(context, newTodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.background,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: createTodo,
            child: Text('Сохранить',
                style: themeData.textTheme.titleSmall
                    ?.copyWith(color: themeData.primaryColor)),
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              todoTextFieldWidget,
              deadlineWidget,
            ],
          ),
        ),
      ),
    );
  }
}
