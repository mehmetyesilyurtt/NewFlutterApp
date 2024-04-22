import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SavePerson extends StatelessWidget {
  const SavePerson({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Person();
  }
}

class Person extends StatefulWidget {
  const Person({Key? key});
  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  String dropdownValue = 'One';
  DateTime? selectedDate;

  Widget generateQRCode(String data) {
    return SizedBox(
      width: 300, // Genişliği belirleyin
      height: 300, // Yüksekliği belirleyin
      child: Container(
        color: Colors.white, // İsteğe bağlı olarak arka plan rengi
        child: QrImageView(
          data: data,
          version: QrVersions.auto,
          backgroundColor: Colors.white,
          // ignore: deprecated_member_use
          foregroundColor: Colors.black,
          size: 300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formFields = [
    SizedBox(height: 16.0),
      TextFormField(
        controller: nameController,
        decoration: InputDecoration(labelText: 'Name'),
      ),
      TextFormField(
        controller: emailController,
        decoration: InputDecoration(labelText: 'Email'),
      ),
      TextFormField(
        controller: passwordController,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
      ),
      SizedBox(height: 16.0),
      // DropdownButton widget'ını Expanded ile sarmalama
      Expanded(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && pickedDate != selectedDate) {
            setState(() {
              selectedDate = pickedDate;
            });
          }
        },
        child: Text(selectedDate == null
            ? 'Select Date'
            : 'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
      ),
    ];

    List<Widget> buttons = [
      ElevatedButton(
        onPressed: () {
          String data = "Name: ${nameController.text}\n"
              "Email: ${emailController.text}\n"
              "Password: ${passwordController.text}\n"
              "Dropdown: $dropdownValue\n"
              "Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}\n";

          Widget qrCode = generateQRCode(data);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: qrCode,
              );
            },
          );
        },
        child: Text('Kaydet and QR Code Oluştur'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...formFields
              .map((field) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: field,
                  ))
              .toList(),
          SizedBox(height: 24.0),
          ...buttons
              .map((button) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: button,
                  ))
              .toList(),
        ],
      ),
    );
  }
}
