import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key, required this.id, required this.time});

  final String id;
  final DateTime time;

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> qrData = {
      'id': widget.id,
      'time': widget.time.toIso8601String(),
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImageView(
              data: qrData.toString(),
              version: QrVersions.auto,
              size: THelperFunctions.screenWidth(context) * 0.7,
            ),
            const Text(
              'Vui lòng đưa mã QR này cho nhân viên để xác nhận',
            ),
          ],
        ),
      ),
    );
  }
}
