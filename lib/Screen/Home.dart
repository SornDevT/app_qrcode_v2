import 'package:flutter/material.dart';

import 'ScanQR.dart';
import 'GenQR.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectIndex = 0;

  static const List _tabPages = [ScanQR(), GenQR()];

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App QR Code V2"),
      ),
      body: _tabPages[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: "ສະແກນ QR Code"),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code), label: "ສ້າງ QR Code"),
        ],
      ),
    );
  }
}
