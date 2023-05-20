import 'package:flutter/material.dart';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:scan/scan.dart';
import 'package:images_picker/images_picker.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  QRViewController? controller;
  Barcode? barcode;
  String? Rbarcode;
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");

  /// check platform
  String _platformVersion = "ບໍ່ຮູ້ຈັກ....";

  // function ກວດຊອບ platform
  Future<void> initPlatformSate() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
      // print('Check Platform....');
    } on PlatformException {
      platformVersion = "ບໍ່ສາມາດລະບຸໄດ້...";
    }

    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformSate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(context),
          Positioned(
            top: 10,
            child: Text(
              "Platform: ${_platformVersion}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            top: 30,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  child: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return Text('ເປີດ Flash: ${snapshot.data}');
                      }),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await controller?.flipCamera();
                    setState(() {});
                  },
                  child: FutureBuilder(
                      future: controller?.getCameraInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Text(
                              'ເປີດກ້ອງ: ${describeEnum(snapshot.data!)}');
                        } else {
                          return Text("ກຳລັງໂຫຼດ...");
                        }
                      }),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            child: builResualt(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Media>? res = await ImagesPicker.pick();
          if (res != null) {
            String? str = await Scan.parse(res[0].path);
            if (str != null) {
              setState(() {
                Rbarcode = str;
              });
            }
          }
        },
        child: Icon(Icons.image),
      ),
    );
  }

  Widget buildQRView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: qrViewCreate,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.orange,
          borderRadius: 10,
          borderLength: 50,
          borderWidth: 10,
        ),
      );

  void qrViewCreate(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
        this.Rbarcode = barcode.code;
      });
    });
  }

  Widget builResualt() => InkWell(
        onTap: () async {
          await controller?.resumeCamera();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black26,
          ),
          child: Text(
            Rbarcode != null ? ' BarCode: ${Rbarcode}' : 'ກົດເພື່ອສະແກນ QRCode',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
}
