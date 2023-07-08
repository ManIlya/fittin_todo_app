import 'package:flutter/material.dart';
import 'package:todo_app/empty.dart';
import 'package:todo_app/services.dart';

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  State<TodoAddPage> createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  DateTime? dateTime;
  TextEditingController controller = TextEditingController();

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
          date: dateTime);
      Navigator.pop(context, newTodo);
    }
  }

  Future<void> createDate() async {
    var newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    setState(() {
      dateTime = newDate;
    });
  }

  void deleteDate() {
    setState(() {
      dateTime = null;
    });
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
              CheckboxListTile(
                value: dateTime != null,
                onChanged: (_) {
                  if (dateTime == null) {
                    createDate();
                  } else {
                    deleteDate();
                  }
                },
                controlAffinity: ListTileControlAffinity.trailing,
                title: const Text('Дедлайн'),
                subtitle: dateTime != null
                    ? Text(convertDateFormat(dateTime!))
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
