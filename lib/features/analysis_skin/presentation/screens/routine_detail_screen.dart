import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_list_view.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_list_view.dart';

class RoutineDetailScreen extends StatefulWidget {
  const RoutineDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoutineBloc>().add(GetRoutineDetailEvent(GetRoutineDetailParams(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
      ),
      body: BlocConsumer<RoutineBloc, RoutineState>(
        listener: (context, state) {
          if (state is RoutineError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is RoutineLoaded) {
            final routine = state.routineModel;
            return Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                children: [
                  Text(
                    routine.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                  ),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    routine.frequency,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: TColors.darkGrey,
                        ),
                  ),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    routine.description,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.darkGrey,
                        ),
                  ),
                  const SizedBox(height: TSizes.lg),
                  ProductListView(products: routine.productRoutines),
                  const SizedBox(height: TSizes.lg),
                  ServiceListView(services: routine.serviceRoutines),
                ],
              ),
            );
          }
          return const TErrorBody();
        },
      ),
    );
  }
}
