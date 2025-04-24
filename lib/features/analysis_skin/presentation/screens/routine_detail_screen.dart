import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/routine_data.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/add_to_routine_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_list_view.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_list_view.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';

class WrapperRoutineDetail extends StatelessWidget {
  const WrapperRoutineDetail({super.key, required this.id, this.onlyShown = false});

  final String id;
  final bool onlyShown;

  @override
  Widget build(BuildContext context) {
    return RoutineData(
        controller: RoutineDataController(),
        child: RoutineDetailScreen(
          id: id,
          onlyShown: onlyShown,
        ));
  }
}

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
    final controller = RoutineData.of(context);
    return BlocConsumer<RoutineBloc, RoutineState>(
      listener: (context, state) {
        if (state is RoutineError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is RoutineLoaded) {
          final routine = state.routineModel;
          // final List<String> steps = routine.steps.split(", ");
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
                        Text(AppLocalizations.of(context)!.treatment_steps,
                            overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                        GestureDetector(
                          onTap: () => goRoutineStep(routine.skincareRoutineId),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.view_more, style: Theme.of(context).textTheme.bodySmall),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.products_and_services,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (!widget.onlyShown)
                          IconButton(
                            icon: const Icon(Iconsax.arrow_right_1),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WrapperAddToRoutine(
                                    routineId: routine.skincareRoutineId.toString(),
                                    routine: routine,
                                  ),
                                ),
                              );

                              // Refresh the routine if items were added
                              if (result == true) {
                                context.read<RoutineBloc>().add(GetRoutineDetailEvent(GetRoutineDetailParams(widget.id)));
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: TSizes.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(AppLocalizations.of(context)!.total, style: Theme.of(context).textTheme.bodyLarge),
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
                          controller.updateRoutine(routine);
                          goSelectRoutineTime(controller);
                        },
                        child: Text(AppLocalizations.of(context)!.book_now)))
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
