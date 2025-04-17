import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';

class TServiceRoutine extends StatelessWidget {
  const TServiceRoutine({
    super.key,
    required this.routineModel,
  });

  final RoutineModel routineModel;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      shadow: true,
      borderColor: TColors.primary,
      backgroundColor: TColors.lightGrey,
      radius: TSizes.md,
      width: THelperFunctions.screenWidth(context) * 0.7,
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            routineModel.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
          ),
          const SizedBox(height: TSizes.sm),


          Text(
            routineModel.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TColors.darkGrey,
                ),
          ),
        ],
      ),
    );
  }
}
