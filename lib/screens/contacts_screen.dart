import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Map<String, String>> contacts = []; // Список контактов

  // Метод для отображения диалога добавления контакта
  void _showAddContactDialog(BuildContext context) {
    String fullName = ''; // Поле для полного имени
    String phoneNumber = ''; // Поле для номера телефона
    String note = ''; // Поле для заметки

    // Показываем диалог для добавления контакта
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить контакт'), // Заголовок диалога
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Поле для ввода полного имени
                TextField(
                  onChanged: (value) => fullName = value,
                  decoration: InputDecoration(labelText: 'Имя'),
                ),
                // Поле для ввода номера телефона
                TextField(
                  onChanged: (value) => phoneNumber = value,
                  decoration: InputDecoration(labelText: 'Номер телефона'),
                  keyboardType: TextInputType.phone, // Тип клавиатуры для ввода телефона
                ),
                // Поле для ввода заметки
                TextField(
                  onChanged: (value) => note = value,
                  decoration: InputDecoration(labelText: 'Примечание'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Кнопка для отмены добавления
            TextButton(
              child: Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // Кнопка для добавления контакта
            TextButton(
              child: Text('Добавить'),
              onPressed: () {
                // Проверяем, что поля имени и номера телефона не пустые
                if (fullName.isNotEmpty && phoneNumber.isNotEmpty) {
                  setState(() {
                    contacts.add({
                      'Имя': fullName,
                      'Номер телефона': phoneNumber,
                      'Примечание': note,
                    });
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

  // Метод для удаления контакта
  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index); // Удаляем контакт по индексу
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Контакты'), // Заголовок экрана
        actions: [
          // Кнопка добавления контакта
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddContactDialog(context),
          ),
        ],
      ),
      body: contacts.isEmpty
          ? Center(
        child: Text(
          'Контактов пока нет( Быстренько исправляем ситуацию!!!', // Сообщение, если контакты пусты
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: contacts.length, // Количество элементов в списке
        itemBuilder: (context, index) {
          final contact = contacts[index]; // Получаем контакт по индексу
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text(contact['Имя']!), // Имя контакта
              subtitle: Text('${contact['Номер телефона']}\n${contact['Примечание']}'), // Телефон и заметка
              isThreeLine: true, // Многострочный текст
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.blue), // Кнопка для удаления
                onPressed: () => _confirmDeleteContact(context, index),
              ),
            ),
          );
        },
      ),
    );
  }

  // Метод для подтверждения удаления контакта
  void _confirmDeleteContact(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удалить контакт'), // Заголовок диалога подтверждения
          content: Text('Вы точно хотите удалить контакт? Хорошо подумайте...'), // Текст запроса
          actions: <Widget>[
            // Кнопка для отмены удаления
            TextButton(
              child: Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // Кнопка для подтверждения удаления
            TextButton(
              child: Text('Удалить'),
              onPressed: () {
                _deleteContact(index); // Удаляем контакт
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
