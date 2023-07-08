import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<String> _todos = [];
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: themeData.colorScheme.background,
        title: Text(
            'Мои дела',
          style: themeData.textTheme.headlineSmall,
        ),

      ),
      body: SafeArea(
        child: Card(
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
          child: ListView.builder(
            itemCount: _todos.length,
              itemBuilder: (context, index){
                return SingleTodoWidget(_todos[index]);
              },

          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              _todos.add('data');
            });
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SingleTodoWidget extends StatefulWidget {
  String todo;
  SingleTodoWidget(this.todo, {Key? key}) : super(key: key);

  @override
  State<SingleTodoWidget> createState() => _SingleTodoWidgetState();
}

class _SingleTodoWidgetState extends State<SingleTodoWidget> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: _checked,
      onChanged: (_){
        setState(() {
          _checked=!_checked;
        });
      },
      title: Text(widget.todo),
    );
  }
}

