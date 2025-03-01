import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(TSizes.sm),
        child: Column(
          children: [Text("Payment page")],
        ),
      ),
    );
  }
}
