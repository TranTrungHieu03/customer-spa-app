import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TProfileItem extends StatefulWidget {
  const TProfileItem({super.key, required this.label, required this.icon, required this.controller, this.isEdit = true});

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isEdit;

  @override
  State<TProfileItem> createState() => _TProfileItemState();
}

class _TProfileItemState extends State<TProfileItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    // Trigger rebuild when controller value changes
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(
          height: TSizes.sm / 2,
        ),
        TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.label,
              contentPadding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              prefixIcon: TRoundedIcon(icon: widget.icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            enabled: widget.isEdit,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
