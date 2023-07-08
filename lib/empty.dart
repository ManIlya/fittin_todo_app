import 'package:flutter/material.dart';

class TodoEmpty {
  int id;
  String task;
  DateTime? date;
  bool completed;

  TodoEmpty(
      {required this.id,
      required this.task,
      this.date,
      this.completed = false});

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'completed': completed,
      'date': date != null ? date!.toIso8601String() : null,
    };
  }

  factory TodoEmpty.fromJson(Map<String, dynamic> json) {
    return TodoEmpty(
      id: UniqueKey().hashCode,
      task: json['task'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      completed: json['completed'],
    );
  }
}
