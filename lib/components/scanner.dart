import 'package:body_sch/components/user_details.dart';
import 'package:body_sch/data/UserDetailsArguments.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {


  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
        ),
        Center(
          child: Container(
          width: 200,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent,
              width: 3,
            )
          ),
        )),
      ]
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print(scanData.code);
      Navigator.pushNamed(
        context,
        UserDetails.routeName,
        arguments: UserDetailsArguments(
        scanData.code
        ),
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}