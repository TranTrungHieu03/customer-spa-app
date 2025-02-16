import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TOptionItem extends StatefulWidget {
  const TOptionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isChoose,
    required this.value,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final bool isChoose;
  final dynamic value;
  final VoidCallback onPressed;

  @override
  _TOptionItemState createState() => _TOptionItemState();
}

class _TOptionItemState extends State<TOptionItem> {
  bool _isChoose = false;

  @override
  void initState() {
    super.initState();
    _isChoose = widget.isChoose;
  }

  @override
  void didUpdateWidget(TOptionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChoose != widget.isChoose) {
      setState(() {
        _isChoose = widget.isChoose;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChoose = !_isChoose;
        });
        widget.onPressed();
      },
      child: TRoundedContainer(
        backgroundColor: _isChoose ? TColors.primaryBackground : Colors.white,
        padding: const EdgeInsets.all(TSizes.sm),
        margin: const EdgeInsets.symmetric(vertical: TSizes.sm / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TRoundedIcon(
                  icon: widget.icon,
                  backgroundColor: _isChoose ? TColors.white : TColors.primaryBackground,
                ),
                const SizedBox(width: TSizes.sm),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.7),
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            _isChoose
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: TColors.black,
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
