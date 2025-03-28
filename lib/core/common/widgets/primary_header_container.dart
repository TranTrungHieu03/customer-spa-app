import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/curved_edges_widget.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: TColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          // height: 200,
          child: Stack(
            children: [
              // Positioned(
              //   top: -150,
              //   right: -250,
              //   child: TCircularContainer(
              //     backgroundColor: TColors.textWhite.withOpacity(0.1),
              //   ),
              // ),
              // Positioned(
              //   top: 100,
              //   right: -300,
              //   child: TCircularContainer(
              //     backgroundColor: TColors.textWhite.withOpacity(0.1),
              //   ),
              // ),
              child
            ],
          ),
        ),
      ),
    );
  }
}
