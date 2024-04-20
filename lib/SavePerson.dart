import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SavePerson extends StatelessWidget {
  const SavePerson({super.key});

  @override
  Widget build(BuildContext context) {
    return Person();
  }
}

class Person extends StatefulWidget {
  const Person({super.key});
  @override
  State<Person> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<Person> {
  // Fonksiyon, QR kodunu oluşturur ve bir Image widget'ı döndürür.

  Widget generateQRCode(String data) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      backgroundColor: Colors.transparent,
      // ignore: deprecated_member_use
      foregroundColor: Colors.black,
      size: 300,
      padding: EdgeInsets.all(10),
      gapless: true,
      errorStateBuilder: (context, error) => Text("Hata"),
      errorCorrectionLevel: QrErrorCorrectLevel.L,
      constrainErrorBounds: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 16.0),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
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
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
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
                ? 'Tarih Seç'
                : 'Seçilen Tarih: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
          ),
          SizedBox(height: 24.0),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              // Kullanıcının girdiği verileri al
              String data = "Name: ${nameController.text}\n"
                  "Email: ${emailController.text}\n"
                  "Password: ${passwordController.text}\n"
                  "Dropdown: $dropdownValue\n"
                  "Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}\n";

              // QR kodunu oluştur
              Widget qrCode = generateQRCode(data);
              // QR kodunu göster

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: qrCode,
                  );
                },
              );
            },
            child: Text('Kayıt ve QR Kodu Oluştur'),
          ),
        ],
      ),
    );
  }
}

// Örnek bir controller tanımı
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

List<String> list = <String>['One', 'Two', 'Three', 'Four'];
String dropdownValue = list.first;
DateTime? selectedDate;
