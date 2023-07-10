import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/empty.dart';
import 'package:todo_app/page/todo_edit_page.dart';

import '../services.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoEmpty> _todos = [];
  int ids = 1;
  bool visibility = false;
  late final _todosLoading;

  @override
  void initState() {
    super.initState();
    _todosLoading = loadTodos();
  }

  Future<List<TodoEmpty>?> loadTodos() async {
    try {
      final file = await getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonList = json.decode(content) as List<dynamic>;
        final loadedTodos = jsonList.map((e) => TodoEmpty.fromJson(e)).toList();
        setState(() {
          _todos = loadedTodos;
        });
        return loadedTodos;
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
    if (newTodo != null) {
      setState(() {
        _todos.add(newTodo as TodoEmpty);
      });
      saveTodos();
    }
  }

  Future<void> editTodo(TodoEmpty editingTodo) async {
    final newTodo = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TodoEditPage(editingTodo: editingTodo)));
    if (newTodo != null) {
      setState(() {
        var newTodoEmpt = newTodo as TodoEmpty;
        _todos.removeWhere((element) => element.id == editingTodo.id);
        if (newTodoEmpt.id != -1) {
          _todos.add(newTodo);
        }
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
        child: FutureBuilder<List<TodoEmpty>?>(
          future: _todosLoading,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Ошибка: ${snapshot.error}'),
              );
            } else {
              return CustomScrollView(
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
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: todos.length, (context, index) {
                    var todo = todos[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 0,
                      ),
                      child: Dismissible(
                        key: Key('${todo.id}'),
                        direction: todo.completed
                            ? DismissDirection.endToStart
                            : DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            updateStatusTodo(todo.id);
                            return !visibility;
                          } else if (direction == DismissDirection.endToStart) {
                            return true;
                          }
                          return false;
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            updateStatusTodo(todo.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Задача выполнена'),
                              ),
                            );
                          } else if (direction == DismissDirection.endToStart) {
                            deleteTodo(todo.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Задача удалена'),
                              ),
                            );
                          }
                        },
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16.0),
                          child: const Icon(Icons.done),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                          child: const Icon(Icons.delete),
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.surface,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(index == 0 ? 20 : 0),
                              bottom: Radius.circular(
                                  index == todos.length - 1 ? 20 : 0),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              editTodo(todo);
                            },
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              //fillColor: MaterialStateProperty.all(Colors.green),//заливка всего объема
                              value: todo.completed,
                              onChanged: (_) {
                                updateStatusTodo(todo.id);
                              },
                              title: GestureDetector(
                                onTap: () {
                                  editTodo(todo);
                                },
                                child: Text(
                                  todo.task,
                                  style: todo.completed
                                      ? TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: themeData.disabledColor,
                                        )
                                      : null,
                                ),
                              ),
                              subtitle: todo.date != null
                                  ? GestureDetector(
                                      onTap: () {
                                        editTodo(todo);
                                      },
                                      child: Text(
                                        convertDateFormat(todo.date!),
                                        style: todo.completed
                                            ? TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: themeData.disabledColor,
                                              )
                                            : null,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeData.primaryColor,
        shape: const CircleBorder(),
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
