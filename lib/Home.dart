// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    _getDataFromAPI();
  }

  Future<void> _getDataFromAPI() async {
    final response = await http.get(Uri.parse(
        'https://api.thecatapi.com/v1/images/search?limit=10&breed_ids=beng&api_key=REPLACE_ME'));
    if (response.statusCode == 200) {
      setState(() {
        dataList = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<void> _deleteData(int index) async {
    setState(() {
      dataList.removeAt(index);
    });
  }

  Future<void> _editData(int index) async {
    final TextEditingController idController = TextEditingController();
    final TextEditingController urlController = TextEditingController();

    idController.text = dataList[index]['id'];
    urlController.text = dataList[index]['url'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'ID'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  dataList[index]['id'] = idController.text;
                  dataList[index]['url'] = urlController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Kaydet'),
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
        title: Text('Anasayfa'),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          return ListTile(
            title: Text(item['id']),
            subtitle: Text(item['url']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editData(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Uyarı'),
                          content:
                              Text('Bu Kaydı silmek istediğinize emin misiniz'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('İptal'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteData(index);
                                Navigator.of(context).pop();
                              },
                              child: Text('Sil'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
