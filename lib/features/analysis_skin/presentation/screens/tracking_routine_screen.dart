import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/feedback_step.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_feedback_steps.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_order_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_tracking.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_routine_logger/list_routine_logger_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/order_routine/order_routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine_logger/routine_logger_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine_tracking/routine_tracking_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_order_list_view.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_appointment_list_view.dart';
import 'package:spa_mobile/features/product/data/model/order_detail_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperTrackingRoutineScreen extends StatefulWidget {
  const WrapperTrackingRoutineScreen(
      {super.key, required this.id, required this.userId, required this.orderId, required this.userRoutineId});

  final int id;
  final int userId;
  final int orderId;
  final int userRoutineId;

  @override
  State<WrapperTrackingRoutineScreen> createState() => _WrapperTrackingRoutineScreenState();
}

class _WrapperTrackingRoutineScreenState extends State<WrapperTrackingRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoutineTrackingBloc>(
          create: (context) => RoutineTrackingBloc(getRoutineTracking: serviceLocator()),
        ),
        BlocProvider<ListRoutineLoggerBloc>(
          create: (context) => ListRoutineLoggerBloc(getFeedbackStep: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              OrderRoutineBloc(getOrderRoutine: serviceLocator())..add(GetOrderRoutineDetailEvent(GetOrderRoutineParams(widget.orderId))),
        ),
        // BlocProvider(
        //   create: (context) => ListAppointmentBloc(getListAppointment: serviceLocator(), getAppointmentsByRoutine: serviceLocator())
        //     ..add(GetListAppointmentByRoutineEvent(GetListAppointmentByRoutineParams(id: widget.id.toString()))),
        // ),
      ],
      child: TrackingRoutineScreen(id: widget.id, userId: widget.userId, orderId: widget.orderId, userRoutineId: widget.userRoutineId),
    );
  }
}

class TrackingRoutineScreen extends StatefulWidget {
  const TrackingRoutineScreen({super.key, required this.id, required this.userId, required this.orderId, required this.userRoutineId});

  final int id;
  final int userId;
  final int userRoutineId;
  final int orderId;

  @override
  State<TrackingRoutineScreen> createState() => _TrackingRoutineScreenState();
}

class _TrackingRoutineScreenState extends State<TrackingRoutineScreen> {
  int _currentStep = 0;
  String _lgCode = "vi";

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lgCode = prefs.getString('language_code') ?? "vi";
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoutineTrackingBloc, RoutineTrackingState>(
      listener: (context, state) {
        if (state is RoutineTrackingError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
        if (state is RoutineTracking) {
          final routineSteps = state.routine.userRoutineSteps;
          _currentStep = routineSteps.indexWhere((element) => element.stepStatus == "Pending");
          _currentStep = (_currentStep == -1) ? 0 : _currentStep;
        }
      },
      child: BlocBuilder<RoutineTrackingBloc, RoutineTrackingState>(
        builder: (context, state) {
          if (state is RoutineTracking) {
            return BlocBuilder<OrderRoutineBloc, OrderRoutineState>(
              builder: (context, apptState) {
                if (apptState is OrderRoutineLoaded) {
                  final routineSteps = state.routine.userRoutineSteps;
                  final listAppointments = List<AppointmentModel>.from(apptState.order.appointments);
                  final listOrderDetails = List<OrderDetailModel>.from(apptState.order.orderDetails);

                  for (final step in state.routine.userRoutineSteps) {
                    // for (final serviceStep in step.serviceRoutineSteps) {
                    final appointment = listAppointments
                        .where(
                          (element) => element.step == step.step,
                        )
                        .toList();

                    step.appointments?.addAll(appointment);
                    final orderDetail = listOrderDetails.where((e) => e.step == step.step).toList();
                    step.orderDetails?.addAll(orderDetail);
                    // for (final productStep in step.productRoutineSteps) {
                    //   final matchProduct = listOrderDetails.firstWhere((order) => order.product.productId == productStep.product.productId);
                    //   step.orderDetails?.add(matchProduct);
                    //   listOrderDetails.remove(matchProduct);
                    // }
                  }

                  return Scaffold(
                    appBar: TAppbar(
                      showBackArrow: true,
                      actions: [
                        TRoundedIcon(
                          icon: Iconsax.pet,
                          onPressed: () => goHistoryOrderRoutine(),
                        )
                      ],
                      title: Text(AppLocalizations.of(context)!.progress_tracking,
                          style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black)),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Stepper(
                        type: StepperType.vertical,
                        currentStep: _currentStep,
                        onStepTapped: (step) => setState(() => _currentStep = step),
                        onStepContinue: () {
                          if (_currentStep < routineSteps.length - 1) {
                            setState(() => _currentStep++);
                          }
                        },
                        onStepCancel: () {
                          if (_currentStep > 0) {
                            setState(() => _currentStep--);
                          }
                        },
                        controlsBuilder: (context, details) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (_currentStep < routineSteps.length - 1)
                                OutlinedButton(
                                  onPressed: details.onStepContinue,
                                  child: Text(AppLocalizations.of(context)!.next),
                                ),
                              const SizedBox(
                                width: TSizes.lg,
                              ),
                              if (_currentStep > 0)
                                OutlinedButton(
                                  onPressed: details.onStepCancel,
                                  child: Text(AppLocalizations.of(context)!.back),
                                ),
                            ],
                          );
                        },
                        steps: routineSteps.map((step) {
                          return Step(
                            title: Text(step.name),
                            subtitle: Text(step.stepStatus?.toLowerCase() == "InProgress".toLowerCase()
                                ? AppLocalizations.of(context)!.in_progress
                                : step.stepStatus?.toLowerCase() == "completed".toLowerCase()
                                    ? AppLocalizations.of(context)!.completed
                                    : AppLocalizations.of(context)!.pending),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (step.serviceRoutineSteps.isNotEmpty)
                                  _buildServiceSection(step, _lgCode, widget.orderId, widget.userId, widget.id, widget.userRoutineId),
                                if (step.productRoutineSteps.isNotEmpty) _buildProductsSection(step),
                                // if (step.stepStatus?.toLowerCase() == "completed")
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (step.stepStatus?.toLowerCase() == "completed")
                                      Text(AppLocalizations.of(context)!.feedback, style: Theme.of(context).textTheme.titleLarge),
                                    const SizedBox(
                                      height: TSizes.sm,
                                    ),
                                    BlocBuilder<ListRoutineLoggerBloc, ListRoutineLoggerState>(builder: (context, fbState) {
                                      if (fbState is ListRoutineLoggerLoaded) {
                                        final fbs = fbState.feedbacks;
                                        return Column(
                                          children: [
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: fbState.feedbacks.length,
                                                itemBuilder: (context, index) {
                                                  if (fbs[index].stepId == step.userRoutineStepId) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          fbs[index].userId != 0 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                      children: [
                                                        if (fbs[index].staff != null)
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              fbs[index].staff?.fullName ?? "",
                                                              style: Theme.of(context)!.textTheme.bodyLarge,
                                                            ),
                                                          ),
                                                        if (fbs[index].customer != null)
                                                          Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(fbs[index].customer?.fullName ?? "",
                                                                style: Theme.of(context)!.textTheme.bodyLarge),
                                                          ),
                                                        TRoundedContainer(
                                                          padding: EdgeInsets.all(TSizes.sm),
                                                          margin: EdgeInsets.only(bottom: TSizes.sm),
                                                          child: Column(
                                                            children: [Text(fbs[index].stepLogger)],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return const SizedBox();
                                                }),
                                            const SizedBox(
                                              height: TSizes.sm,
                                            ),
                                          ],
                                        );
                                      }
                                      return SizedBox();
                                    }),
                                    if (step.stepStatus?.toLowerCase() == "completed")
                                      TextButton(
                                          onPressed: () {
                                            _showMessageModal(context, widget.userId, step.userRoutineStepId, widget.orderId, widget.id,
                                                widget.userRoutineId);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Text(AppLocalizations.of(context)!.step_feedback), Icon(Iconsax.arrow_right_1)],
                                          )),
                                  ],
                                )
                              ],
                            ),
                            state: _getStepState(routineSteps, step),
                            isActive: routineSteps.indexOf(step) == _currentStep,
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else if (apptState is OrderRoutineLoading) {
                  const Scaffold(
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
                );
              },
            );
          } else if (state is RoutineTrackingLoading) {
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
      ),
    );
  }

  StepState _getStepState(List<dynamic> routineSteps, dynamic currentStep) {
    int currentIndex = routineSteps.indexOf(currentStep);

    if (currentIndex < _currentStep) {
      return StepState.complete;
    } else if (currentIndex == _currentStep) {
      return StepState.editing;
    }
    return StepState.indexed;
  }

  Widget _buildServiceSection(RoutineStepModel step, String lgCode, int orderId, int useId, int routineId, int userRoutineId) {
    return Container(
      padding: const EdgeInsets.all(0),
      color: TColors.white,
      margin: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: 0),
      child: ServiceAppointmentListView(
        data: step,
        lgCode: lgCode,
        orderId: orderId,
        userId: useId,
        routineId: routineId,
        userRoutineId: userRoutineId,
      ),
    );
  }

  Widget _buildProductsSection(RoutineStepModel products) {
    return Container(
        color: TColors.white,
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: 0),
        child: ProductOrderListView(data: products));
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    context.read<RoutineTrackingBloc>().add(GetRoutineTrackingEvent(GetRoutineTrackingParams(userRoutineId: widget.userRoutineId)));
    context.read<ListRoutineLoggerBloc>().add(GetListRoutineLoggerEvent(GetFeedbackStepParams(widget.userRoutineId)));
  }
}

void _showMessageModal(BuildContext context, int userId, int stepId, int orderId, int routineId, int userRoutineId) {
  TextEditingController messageController = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => RoutineLoggerBloc(feedbackStep: serviceLocator()),
        child: Padding(
          padding: EdgeInsets.only(
            left: TSizes.md,
            right: TSizes.md,
            top: TSizes.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.feedback,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enter_your_message,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocListener<RoutineLoggerBloc, RoutineLoggerState>(
                listener: (context, state) {
                  if (state is RoutineLoggerCreated) {
                    Navigator.pop(context);
                    goTrackingRoutineDetail(routineId, userId, orderId, userRoutineId);
                  } else if (state is RoutineLoggerError) {
                    TSnackBar.errorSnackBar(context, message: state.message);
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<RoutineLoggerBloc, RoutineLoggerState>(
                        builder: (context, state) {
                          if (state is RoutineLoggerLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: TColors.primary,
                              ),
                            );
                          }
                          return ElevatedButton(
                            onPressed: () {
                              if (messageController.text.trim().isEmpty) {
                                TSnackBar.warningSnackBar(context, message: AppLocalizations.of(context)!.enter_your_feedback);
                                return;
                              }
                              context.read<RoutineLoggerBloc>().add(CreateRoutineLoggerEvent(FeedbackStepParams(
                                  stepId: stepId,
                                  userId: userId,
                                  actionDate: DateTime.now(),
                                  stepLogger: messageController.text.trim(),
                                  notes: "")));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.submit,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: TSizes.md,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
