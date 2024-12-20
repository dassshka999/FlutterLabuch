import 'package:flutter/material.dart';
import 'screens/contacts_screen.dart';
import 'screens/meetings_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/tasks_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  List<Map<String, dynamic>> buttonList = [
    {'text': 'Встречи', 'screen': MeetingsScreen()},
    {'text': 'Контакты', 'screen': ContactsScreen()},
    {'text': 'Заметки', 'screen': NotesScreen()},
    {'text': 'Задачи', 'screen': TasksScreen()},
  ];

  void _addNewButton(String buttonName) {
    setState(() {
      buttonList.add({
        'text': buttonName,
        'screen': NewButtonScreen(buttonName: buttonName),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Персональный помощник',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF2E6FF),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        toggleTheme: _toggleTheme,
        buttonList: buttonList,
        addNewButton: _addNewButton,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final List<Map<String, dynamic>> buttonList;
  final Function(String) addNewButton;

  HomeScreen({
    required this.toggleTheme,
    required this.buttonList,
    required this.addNewButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Персональный помощник'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.blueAccent,
            onPressed: () {
              _showAddButtonDialog(context);
            },
          ),
        ],
      ),
     body: Center(
      child: SingleChildScrollView(
      child: Wrap(
       spacing: 16.0, // Расстояние между кнопками по горизонтали
       runSpacing: 16.0, // Расстояние между кнопками по вертикали
       alignment: WrapAlignment.center,
       children: buttonList.map((button) {
        return ElevatedButton(
         onPressed: () {
          Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => button['screen']),
         );
        },
         style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: Size(150, 60), // Устанавливаем минимальный размер кнопки
          textStyle: TextStyle(fontSize: 18), // Увеличиваем шрифт текста
        ),
        child: Text(button['text']),
        );
       }).toList(),
       ),
      ),
    ),
    );
  }

  void _showAddButtonDialog(BuildContext context) {
    String newButtonName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить новую кнопку'),
          content: TextField(
            onChanged: (value) {
              newButtonName = value;
            },
            decoration: InputDecoration(hintText: "Введите имя кнопки"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Добавить'),
              onPressed: () {
                if (newButtonName.isNotEmpty) {
                  addNewButton(newButtonName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class NewButtonScreen extends StatefulWidget {
  final String buttonName;

  NewButtonScreen({required this.buttonName});

  @override
  _NewButtonScreenState createState() => _NewButtonScreenState();
}

class _NewButtonScreenState extends State<NewButtonScreen> {
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buttonName),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddItemDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    String newItemName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить новый элемент'),
          content: TextField(
            onChanged: (value) {
              newItemName = value;
            },
            decoration: InputDecoration(hintText: "Введите имя элемента"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Добавить'),
              onPressed: () {
                if (newItemName.isNotEmpty) {
                  setState(() {
                    items.add(newItemName);
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
}