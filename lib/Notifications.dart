import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bildirimler',
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> records = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.thecatapi.com/v1/images/'));
    if (response.statusCode == 200) {
      setState(() {
        records = jsonDecode(response.body);
      });
      showNotifications();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void showNotifications() {
    // Tarihi aşan kayıtları bul ve bildirimleri göster
    DateTime now = DateTime.now();
    for (var record in records) {
      DateTime recordDate = DateTime.parse(
          record['date']); // API'den gelen tarih formatına göre ayarla
      if (recordDate.isAfter(now)) {
        showNotification(record['title'], record['message']);
      }
    }
  }

  void showNotification(String title, String message) {
    // Bildirim gösterme kodu buraya gelecek
    // Örnek olarak flutter_local_notifications paketini kullanabilirsiniz
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirim'),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(records[index]['title']),
            subtitle: Text(records[index]['message']),
            onTap: () {
              // Kaydın detaylarını gösterme işlemi buraya gelecek
            },
          );
        },
      ),
    );
  }
}
