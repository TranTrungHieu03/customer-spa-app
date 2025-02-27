import 'package:flutter/material.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';

class TProductPriceText extends StatelessWidget {
  const TProductPriceText({
    super.key,
    this.currencySign = '₫',
    required this.price,
    this.maxLine = 1,
    this.isLarge = true,
    this.lineThrough = false,
    this.color,
  });

  final String currencySign, price;
  final int maxLine;
  final bool isLarge;
  final bool lineThrough;
  final Color? color; // Thêm màu tuỳ chọn

  @override
  Widget build(BuildContext context) {
    return Text(
      formatMoney(price),
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.titleLarge!.apply(
                decoration: lineThrough ? TextDecoration.lineThrough : null,
                color: color, // Áp dụng màu sắc
              )
          : Theme.of(context).textTheme.bodySmall!.apply(
                decoration: lineThrough ? TextDecoration.lineThrough : null,
                color: color, // Áp dụng màu sắc
              ),
    );
  }
}
