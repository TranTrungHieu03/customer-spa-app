import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class CancelServiceScreen extends StatefulWidget {
  const CancelServiceScreen({super.key});

  @override
  State<CancelServiceScreen> createState() => _CancelServiceScreenState();
}

class _CancelServiceScreenState extends State<CancelServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(),
      body: Padding(
        padding: EdgeInsets.all(TSizes.sm),
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
