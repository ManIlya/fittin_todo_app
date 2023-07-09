import 'package:flutter/material.dart';
import 'package:todo_app/empty.dart';
import 'package:todo_app/services.dart';
import 'package:todo_app/widget/deadline_widget.dart';
import 'package:todo_app/widget/todo_editing_text_widget.dart';

class TodoEditPage extends StatefulWidget {
  TodoEmpty editingTodo;
  TodoEditPage(this.editingTodo, {super.key});

  @override
  State<TodoEditPage> createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  late DeadlineWidget deadlineWidget;
  late TodoTextFieldWidget todoTextFieldWidget;


  @override
  void initState() {
    super.initState();
    todoTextFieldWidget = TodoTextFieldWidget(widget.editingTodo.task);
    deadlineWidget = DeadlineWidget(widget.editingTodo.date);
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
  void deleteTodo() {
    var newTodo = TodoEmpty(
        id: -1,
        task: '',);
    Navigator.pop(context, newTodo);
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
              const Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: deleteTodo,
                  icon: Icon(Icons.delete_outline),
                  label: Text('Удалить'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
