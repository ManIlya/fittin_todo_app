import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/empty.dart';

import '../services.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoEmpty> _todos = [];
  int ids = 1;
  bool visibility = false;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final file = await getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonList = json.decode(content) as List<dynamic>;
        final loadedTodos = jsonList.map((e) => TodoEmpty.fromJson(e)).toList();
        setState(() {
          _todos = loadedTodos;
        });
      }
    } catch (e) {
      print('Failed to load todos: $e');
    }
  }

  Future<void> saveTodos() async {
    try {
      final file = await getFile();
      final jsonList = _todos.map((todo) => todo.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Failed to save todos: $e');
    }
  }

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todos.json');
  }

  Future<void> addTodo() async {
    final newTodo = await Navigator.of(context).pushNamed('/add');
    if(newTodo!=null){
      setState(() {
        _todos.add(newTodo as TodoEmpty);
      });
      saveTodos();
    }
  }

  void updateVisibility() {
    setState(() {
      visibility = !visibility;
    });
  }

  void deleteTodo(int id) {
    setState(() {
      _todos.removeWhere((element) => element.id == id);
    });
    saveTodos();
  }

  void updateStatusTodo(int id) {
    setState(() {
      _todos.firstWhere((element) => element.id == id).completed =
          !_todos.firstWhere((element) => element.id == id).completed;
    });
    saveTodos();
  }


  @override
  Widget build(BuildContext context) {
    List<TodoEmpty> todos = visibility
        ? _todos
        : _todos.where((element) => !element.completed).toList();
    var countComplete = _todos.where((element) => element.completed).length;
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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: themeData.colorScheme.background,
              title: Text('Выполнено-$countComplete'),
              actions: [
                IconButton(
                  onPressed: updateVisibility,
                  icon: Icon(
                    visibility ? Icons.visibility : Icons.visibility_off,
                    color: themeData.primaryColor,
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    var todo = todos[index];
                    return Dismissible(
                        key: Key('${todo.id}'),
                        direction: todo.completed
                            ? DismissDirection.endToStart
                            : DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            updateStatusTodo(todo.id);
                            return !visibility;
                          }else if (direction == DismissDirection.endToStart){
                            return true;
                          }
                          return false;
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            updateStatusTodo(todo.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Задача выполнена'),
                              ),
                            );
                          } else if (direction == DismissDirection.endToStart) {
                            deleteTodo(todo.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Задача удалена'),
                              ),
                            );
                          }
                        },
                        background: Container(
                          color: Colors.green,
                          child: Icon(Icons.done),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.0),
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: todo.completed,
                          onChanged: (_) {
                            updateStatusTodo(todo.id);
                          },
                          title: Text(
                            todo.task,
                            style: todo.completed
                                ? TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: themeData.disabledColor,
                                  )
                                : null,
                          ),
                          subtitle: todo.date != null
                              ? Text(
                                  convertDateFormat(todo.date!),
                                  style: todo.completed
                                      ? TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: themeData.disabledColor,
                                        )
                                      : null,
                                )
                              : null,
                        ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

}
