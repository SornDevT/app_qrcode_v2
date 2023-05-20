import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenQR extends StatefulWidget {
  const GenQR({super.key});

  @override
  State<GenQR> createState() => _GenQRState();
}

class _GenQRState extends State<GenQR> {
  final qr_text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QrImage(
              data: qr_text.text,
              size: 300,
            ),
            TextField(
              controller: qr_text,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.check),
              )),
            )
          ],
        ),
      ),
    );
  }
}
