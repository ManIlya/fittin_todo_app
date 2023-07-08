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
    if(controller.value.text==''){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Вы не ввели задание'),
        ),
      );
    }else{
      var newTodo = TodoEmpty(id: UniqueKey().hashCode, task: controller.value.text, date: dateTime);
      Navigator.pop(context, newTodo);
    }
  }

  Future<void> createDate() async {
    var newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    setState(() {
      dateTime = newDate;
    });
  }
  void deleteDate() {
    setState(() {
      dateTime=null;
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
          icon: Icon(Icons.close),
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
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: controller,
                    maxLines: 10,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(),
              CheckboxListTile(
                value: dateTime!=null,
                onChanged: (_) {
                  if (dateTime==null) {
                    createDate();
                  }else{
                    deleteDate();
                  }
                },
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text('Дедлайн'),
                subtitle: dateTime!=null ? Text(convertDateFormat(dateTime!)) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
