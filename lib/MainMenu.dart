// ignore_for_file: file_names

import 'package:my_app/Home.dart';
import 'package:my_app/Notifications.dart';
import 'package:my_app/SavePerson.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Import the QR code scanner package
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  // Add a QRViewController variable to manage the QR scanner
  QRViewController? qrViewController;

  // Add a GlobalKey for the QR scanner
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Anasayfa',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Bildirimler',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QRScan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Kayıt',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Home(),

        /// Notifications page

        Notifications(),

        // QR Scanner page
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),

        /// Messages page

        SavePerson(),
      ][currentPageIndex],
    );
  }

  // Method to handle QR view creation
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrViewController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // Do something with the scanned data here
    });
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }
}
