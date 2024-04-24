import 'package:flutter/material.dart';

class EditDataPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditDataPage({Key? key, required this.data}) : super(key: key);

  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  late TextEditingController nameController;
  late TextEditingController levelController;
  late TextEditingController imgController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.data['name']);
    levelController = TextEditingController(text: widget.data['level']);
    imgController = TextEditingController(text: widget.data['img']);
  }

  @override
  void dispose() {
    nameController.dispose();
    levelController.dispose();
    imgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Güncelleme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update data
                setState(() {
                  widget.data['name'] = nameController.text;
                  widget.data['level'] = levelController.text;
                  widget.data['img'] = imgController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Güncelle'),
            ),
            ElevatedButton(
              onPressed: () {
                // Delete data
                Navigator.pop(context, true); // Pass true to indicate deletion
              },
              child: Text('Sil'),
            ),
          ],
        ),
      ),
    );
  }
}
