import 'package:flutter/material.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
class TLoader extends StatelessWidget {
  const TLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Center(
      child: CircularProgressIndicator(
        color: TColors.primary,
      ),
    );
  }
}