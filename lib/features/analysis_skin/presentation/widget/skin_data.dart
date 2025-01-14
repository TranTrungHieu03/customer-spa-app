import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TSkinData extends StatelessWidget {
  const TSkinData({
    super.key,
    required this.title,
    required this.value,
    required this.iconData,
    required this.iconColor,
    required this.backgroundIconColor,
  });

  final String title, value;
  final IconData iconData;
  final Color iconColor, backgroundIconColor;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      backgroundColor: Colors.white.withOpacity(0.85),
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      borderColor: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TRoundedIcon(icon: iconData, color: iconColor, size: 25, backgroundColor: backgroundIconColor),
                const SizedBox(
                  width: TSizes.sm,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.4),
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
