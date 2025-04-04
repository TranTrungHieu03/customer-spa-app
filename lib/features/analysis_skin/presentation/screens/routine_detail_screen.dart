import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_list_view.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_list_view.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';

class RoutineDetailScreen extends StatefulWidget {
  const RoutineDetailScreen({super.key, required this.id, this.onlyShown = false});

  final String id;
  final bool onlyShown;

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
    return BlocConsumer<RoutineBloc, RoutineState>(
      listener: (context, state) {
        if (state is RoutineError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is RoutineLoaded) {
          final routine = state.routineModel;
          final List<String> steps = routine.steps.split(", ");
          return Scaffold(
            appBar: TAppbar(
              showBackArrow: true,
              actions: [
                TRoundedIcon(
                  icon: Iconsax.home_2,
                  onPressed: () => goHome(),
                )
              ],
              title: Text(routine.name, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(routine.description, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: TSizes.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Các bước của liệu trình", overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                        GestureDetector(
                          onTap: () => goRoutineStep(routine.skincareRoutineId),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Xem chi tiết", style: Theme.of(context).textTheme.bodySmall),
                              const Icon(
                                Iconsax.arrow_right_3,
                                size: 17,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: TSizes.sm),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, indexStep) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.teal,
                                  child: Text(
                                    '${indexStep + 1}',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.white),
                                  ),
                                ),
                                if (indexStep != steps.length - 1)
                                  Container(
                                    height: 20,
                                    width: 2,
                                    color: Colors.teal,
                                  ),
                              ],
                            ),
                            const SizedBox(width: TSizes.md),
                            Expanded(
                              child: Text(
                                steps[indexStep],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: steps.length,
                    ),
                    const SizedBox(height: TSizes.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Chi phí: ", style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(width: TSizes.sm),
                        TProductPriceText(price: routine.totalPrice.toString()),
                      ],
                    ),
                    const SizedBox(height: TSizes.lg),
                    ProductListView(products: routine.productRoutines),
                    const SizedBox(height: TSizes.lg),
                    ServiceListView(services: routine.serviceRoutines),
                    const SizedBox(height: TSizes.lg),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: !widget.onlyShown
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          goSelectRoutineTime(routine);
                        },
                        child: const Text("Book")))
                : null,
          );
        } else if (state is RoutineLoading) {
          return const Scaffold(
            appBar: TAppbar(
              showBackArrow: true,
            ),
            body: TLoader(),
          );
        }
        return const Scaffold(
          appBar: TAppbar(
            showBackArrow: true,
          ),
          body: TErrorBody(),
        );
      },
    );
  }
}
