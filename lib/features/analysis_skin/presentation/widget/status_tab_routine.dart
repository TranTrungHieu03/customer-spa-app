import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_history.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_routine/list_routine_bloc.dart';

class TStatusBarRoutine extends StatefulWidget {
  const TStatusBarRoutine({super.key, required this.status, required this.userId});

  final String status;
  final int userId;

  @override
  State<TStatusBarRoutine> createState() => _TStatusBarRoutineState();
}

class _TStatusBarRoutineState extends State<TStatusBarRoutine> with AutomaticKeepAliveClientMixin {
  List<RoutineModel> routines = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ListRoutineBloc>().add(GetHistoryRoutineEvent(GetRoutineHistoryParams(userId: widget.userId, status: widget.status)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              if (state is ListRoutineHistoryLoaded) {
                if (widget.status == 'active') {
                  routines = state.active;
                } else if (widget.status == 'completed') {
                  routines = state.completed;
                } else if (widget.status == 'cancelled') {
                  routines = state.cancelled;
                }
                if (routines.isEmpty) {
                  return Center(
                    child: Text('Chua co goi lieu trinh nao'),
                  );
                }
                return ListView.separated(
                    itemBuilder: (context, index) {
                      final routine = routines[index];
                      final List<String> listSteps = routine.steps.split(", ");
                      return GestureDetector(
                        // onTap: () => goTrackingRoutineDetail(routine.skincareRoutineId, widget.userId),
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
                                  goTrackingRoutineDetail(routine.skincareRoutineId, widget.userId);
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
