import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Загружаем задачи из SharedPreferences
  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? taskData = prefs.getString('Задачи');
    if (taskData != null) {
      final List<dynamic> taskList = jsonDecode(taskData);
      setState(() {
        tasks = List<Map<String, dynamic>>.from(taskList);
      });
    }
  }

  // Сохраняем задачи в SharedPreferences
  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String taskData = jsonEncode(tasks);
    await prefs.setString('Задачи', taskData);
  }

  // Открытие диалога для добавления новой задачи
  void _addTaskDialog() {
    String title = '';
    String description = '';

    selectedDate = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить новую задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Название задачи'),
                onChanged: (value) {
                  title = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Описание задачи'),
                onChanged: (value) {
                  description = value;
                },
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(selectedDate == null
                    ? 'Выбор даты'
                    : 'Выбранная дата: ${selectedDate?.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Добавить'),
              onPressed: () {
                if (title.isNotEmpty && selectedDate != null) {
                  setState(() {
                    tasks.add({
                      'Название': title,
                      'Описание': description,
                      'Дата': selectedDate!.toIso8601String(),
                    });
                    _saveTasks();
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задачи'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task['Название']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['Описание']),
                Text(
                  'Дата: ${DateTime.parse(task['Дата']).toLocal().toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
                _saveTasks();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
