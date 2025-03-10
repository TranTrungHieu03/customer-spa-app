import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TQrCheckIn extends StatefulWidget {
  const TQrCheckIn({super.key, required this.id, required this.time});

  final String id;
  final DateTime time;

  @override
  State<TQrCheckIn> createState() => _TQrCheckInState();
}

class _TQrCheckInState extends State<TQrCheckIn> {
  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = widget.time;
  }

  void refreshQrCode() {
    setState(() {
      currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> qrData = {
      'id': widget.id,
      'time': currentTime.toIso8601String(),
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Hiển thị mã QR
          QrImageView(
            data: jsonEncode(qrData),
            version: QrVersions.auto,
            gapless: false,
            size: THelperFunctions.screenWidth(context) * 0.7,
          ),

          const SizedBox(
            height: TSizes.sm,
          ),

          Text(
            'Vui lòng đưa mã QR này cho nhân viên để xác nhận',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(
            height: TSizes.lg,
          ),

          ElevatedButton.icon(
            onPressed: refreshQrCode,
            icon: const Icon(Icons.refresh),
            label: Text(
              'Làm mới mã QR',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
            ),
            // style: ElevatedButton.styleFrom(
            //   padding: const EdgeInsets.symmetric(horizontal: TSizes.lg, vertical: TSizes.sm),
            // ),
          ),
        ],
      ),
    );
  }
}
