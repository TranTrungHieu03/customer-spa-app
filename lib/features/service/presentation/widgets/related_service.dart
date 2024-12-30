import 'package:flutter/material.dart';

class TRelatedService extends StatelessWidget {
  const TRelatedService({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 260,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(6, (index) {
            return const Padding(
                padding: EdgeInsets.all(8.0), child: SizedBox());
          }),
        ));
  }
}
