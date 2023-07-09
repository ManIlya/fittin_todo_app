import 'package:flutter/material.dart';
import 'package:todo_app/empty.dart';

import '../widget/deadline_widget.dart';

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  State<TodoAddPage> createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {

  late DeadlineWidget deadlineWidget;
  TextEditingController controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    deadlineWidget= DeadlineWidget(null);
  }

  void createTodo() {
    if (controller.value.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Вы не ввели задание'),
        ),
      );
    } else {
      var newTodo = TodoEmpty(
          id: UniqueKey().hashCode,
          task: controller.value.text,
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
              Card(
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
                    controller: controller,
                    maxLines: 10,
                    minLines: 1,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              deadlineWidget,
            ],
          ),
        ),
      ),
    );
  }
}
