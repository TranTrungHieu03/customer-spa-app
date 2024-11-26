import 'dart:math';

import 'package:flutter/material.dart';

class TProductBanner extends StatefulWidget {
  const TProductBanner({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.index = 0,
  });

  final Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final int index;

  @override
  _TProductBannerState createState() => _TProductBannerState();
}

class _TProductBannerState extends State<TProductBanner> {
  Offset getOffset(int stackIndex) {
    return {
          0: Offset(-70, 30),
          1: Offset(70, 30),
        }[stackIndex] ??
        Offset(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: List.generate(4, (stackIndex) {
      return Transform.translate(
        offset: getOffset(stackIndex),
        child: Transform.scale(
          scale: 0.6,
          child: Transform.rotate(
            angle: -pi * 0.1,
            child: widget.itemBuilder(context, stackIndex),
          ),
        ),
      );
    }));
  }
}
