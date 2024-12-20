import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding and decoding JSON

class MeetingsScreen extends StatefulWidget {
  @override
  _MeetingsScreenState createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  List<Map<String, String>> meetings = [];

  @override
  void initState() {
    super.initState();
    _loadMeetings();  // Load saved meetings when the screen initializes
  }

  // Load meetings from SharedPreferences
  _loadMeetings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? meetingsData = prefs.getString('Встречи');
    if (meetingsData != null) {
      setState(() {
        meetings = List<Map<String, String>>.from(
            json.decode(meetingsData).map((meeting) => Map<String, String>.from(meeting))
        );
      });
    }
  }

  // Save meetings to SharedPreferences
  _saveMeetings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Встречи', json.encode(meetings));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Встречи'),
      ),
      body: ListView.builder(
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          return ListTile(
            title: Text(meeting['Название']!),
            subtitle: Text('${meeting['Дата']} at ${meeting['Время']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  meetings.removeAt(index);
                  _saveMeetings();  // Save updated meetings list
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeetingDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addMeetingDialog() {
    final _formKey = GlobalKey<FormState>();
    String topic = '';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить новую встречу'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Название встречи'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите тему';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      topic = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        selectedDate == null
                            ? 'Вы забыли выбрать дату'
                            : 'Дата: ${selectedDate!.toLocal()}'.split(' ')[0],
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text('Выбрать дату'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        selectedTime == null
                            ? 'Вы забыли выбрать время'
                            : 'Время: ${selectedTime!.format(context)}',
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = pickedTime;
                            });
                          }
                        },
                        child: Text('Выберите время'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Добавить'),
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    selectedDate != null &&
                    selectedTime != null) {
                  _formKey.currentState!.save();
                  setState(() {
                    meetings.add({
                      'Название': topic,
                      'Дата': '${selectedDate!.toLocal()}'.split(' ')[0],
                      'Время': selectedTime!.format(context),
                    });
                    _saveMeetings();  // Save meetings list after adding a new one
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Выберите дату и время, ПОЖАЛУЙСТА')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
