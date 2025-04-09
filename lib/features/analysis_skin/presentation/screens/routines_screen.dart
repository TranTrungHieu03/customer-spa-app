import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_routine/list_routine_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperRoutineScreen extends StatefulWidget {
  const WrapperRoutineScreen({super.key});

  @override
  State<WrapperRoutineScreen> createState() => _WrapperRoutineScreenState();
}

class _WrapperRoutineScreenState extends State<WrapperRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListRoutineBloc>(
      create: (context) => ListRoutineBloc(getListRoutine: serviceLocator(), getHistoryRoutine: serviceLocator()),
      child: RoutinesScreen(),
    );
  }
}

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
        title: Text("Gói liệu trình"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Container(
          margin: EdgeInsets.all(TSizes.sm),
          child: BlocListener<ListRoutineBloc, ListRoutineState>(
            listener: (context, state) {
              if (state is ListRoutineError) {
                TSnackBar.errorSnackBar(context, message: state.message);
              }
            },
            child: BlocBuilder<ListRoutineBloc, ListRoutineState>(
              builder: (context, state) {
                if (state is ListRoutineLoaded) {
                  final routines = state.routines;
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final routine = routines[index];
                        final List<String> listSteps = routine.steps.split(", ");
                        return GestureDetector(
                          onTap: () => goRoutineDetail(routine.skincareRoutineId.toString()),
                          child: TRoundedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(routine.name, style: Theme.of(context).textTheme.titleLarge),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(routine.description),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          formatMoney(routine.totalPrice.toString()),
                                          style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    goRoutineDetail(routine.skincareRoutineId.toString());
                                  },
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                                //   child: Text("Các bước thực hiện:", style: Theme.of(context).textTheme.bodyMedium),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                                //   child: ListView.builder(
                                //     shrinkWrap: true,
                                //     physics: const NeverScrollableScrollPhysics(),
                                //     itemBuilder: (context, indexStep) {
                                //       return Text('${indexStep + 1}. ${listSteps[indexStep]}');
                                //     },
                                //     itemCount: listSteps.length,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: TSizes.md,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: TSizes.sm,
                        );
                      },
                      itemCount: routines.length);
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ListRoutineBloc>().add(GetListRoutineEvent());
  }
}
