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
  List<Map<String, dynamic>> filteredList = [];
  String filterLevel = '';

  @override
  void initState() {
    super.initState();
    _getDataFromAPI();
  }

  Future<void> _getDataFromAPI() async {
    final response =
        await http.get(Uri.parse('https://digimon-api.vercel.app/api/digimon'));
    if (response.statusCode == 200) {
      setState(() {
        dataList = List<Map<String, dynamic>>.from(json.decode(response.body));
        filteredList = dataList;
      });
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<void> _deleteData(int index) async {
    setState(() {
      dataList.removeAt(index);
      filteredList.removeAt(index);
    });
  }

  Future<void> _editData(int index) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController levelController = TextEditingController();
    final TextEditingController imgController = TextEditingController();

    nameController.text = dataList[index]['name'];
    levelController.text = dataList[index]['level'];
    imgController.text = dataList[index]['img'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'NAME'),
              ),
              TextField(
                controller: levelController,
                decoration: InputDecoration(labelText: 'LEVEL'),
              ),
              TextField(
                controller: imgController,
                decoration: InputDecoration(labelText: 'IMG'),
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
                  dataList[index]['name'] = nameController.text;
                  dataList[index]['level'] = levelController.text;
                  dataList[index]['img'] = imgController.text;
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

  void _filterDataByLevel(String level) {
    setState(() {
      filterLevel = level;
      filteredList = dataList
          .where((item) =>
              item['level'].toLowerCase() == filterLevel.toLowerCase())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anasayfa'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(filteredList));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _filterDataByLevel('rookie');
                },
                child: Text('Rookie'),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _filterDataByLevel('champion');
                },
                child: Text('Champion'),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _filterDataByLevel('ultimate');
                },
                child: Text('Ultimate'),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return ListTile(
                  leading: Image.network(item['img']),
                  title: Text(item['name']),
                  subtitle: Text(item['level']),
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
                                content: Text(
                                    'Kaydı silmek istediğinize emin misiniz?'),
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
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<Map<String, dynamic>> dataList;

  DataSearch(this.dataList);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some result based on the selection
    return Text('Build result: $query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    final suggestionList = query.isEmpty
        ? dataList
        : dataList
            .where((item) =>
                item['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();

    final filteredListByLevel = suggestionList
        .where(
            (item) => item['level'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredListByLevel.length,
      itemBuilder: (context, index) {
        final item = filteredListByLevel[index];
        return ListTile(
          title: Text(item['name']),
          leading: Image.network(item['img']),
          onTap: () {
            // Close the search and pass back the selected result
            close(context, item['name']);
            close(context, item['img']);
          },
        );
      },
    );
  }
}
