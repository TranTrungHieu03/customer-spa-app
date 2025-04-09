import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class TLeaveBooking extends StatelessWidget {
  const TLeaveBooking({super.key, required this.clearFn});

  final Function clearFn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bạn có chắc muốn rời khỏi lịch đặt này?",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            "Tất cả dữ liệu đã chọn sẽ mất.",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    clearFn();
                    goHome();
                  },
                  child: Text('Đồng ý'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
