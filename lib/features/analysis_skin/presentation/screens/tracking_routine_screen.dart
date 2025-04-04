import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/product_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/service_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_tracking.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine_tracking/routine_tracking_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_list_view.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_list_view.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperTrackingRoutineScreen extends StatefulWidget {
  const WrapperTrackingRoutineScreen({super.key, required this.id, required this.userId});

  final int id;
  final int userId;

  @override
  State<WrapperTrackingRoutineScreen> createState() => _WrapperTrackingRoutineScreenState();
}

class _WrapperTrackingRoutineScreenState extends State<WrapperTrackingRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoutineTrackingBloc>(
        create: (context) => RoutineTrackingBloc(getRoutineTracking: serviceLocator()),
        child: TrackingRoutineScreen(id: widget.id, userId: widget.userId));
  }
}

class TrackingRoutineScreen extends StatefulWidget {
  const TrackingRoutineScreen({super.key, required this.id, required this.userId});

  final int id;
  final int userId;

  @override
  State<TrackingRoutineScreen> createState() => _TrackingRoutineScreenState();
}

class _TrackingRoutineScreenState extends State<TrackingRoutineScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoutineTrackingBloc, RoutineTrackingState>(
      listener: (context, state) {
        if (state is RoutineTrackingError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      child: BlocBuilder<RoutineTrackingBloc, RoutineTrackingState>(
        builder: (context, state) {
          if (state is RoutineTracking) {
            final routineSteps = state.routine.userRoutineSteps;
            _currentStep = routineSteps.indexWhere((element) => element.stepStatus == "InProgress");
            _currentStep = (_currentStep == -1) ? 0 : _currentStep;
            return Scaffold(
              appBar: const TAppbar(
                showBackArrow: true,
                title: Text('Tiến trình theo dõi'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(0),
                child: Stepper(
                  margin: EdgeInsets.all(0),
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  controlsBuilder: (_currentStep, _) {
                    return Container();
                  },
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
                  steps: routineSteps.map((step) {
                    return Step(
                      title: Text(step.name),
                      subtitle: Text(step.stepStatus?.toUpperCase() == "InProgress".toUpperCase()
                          ? "Đang thực hiện"
                          : step.stepStatus?.toUpperCase() == "Completed".toUpperCase()
                              ? "Đã hoàn thành"
                              : "Đang chờ"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Services Section
                          if (step.serviceRoutineSteps.isNotEmpty) _buildServiceSection(step.serviceRoutineSteps),

                          // Products Section
                          if (step.productRoutineSteps.isNotEmpty) _buildProductsSection(step.productRoutineSteps),
                        ],
                      ),
                      state: _getStepState(routineSteps, step),
                      isActive: routineSteps.indexOf(step) == _currentStep,
                    );
                  }).toList(),
                ),
              ),
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

  Widget _buildServiceSection(List<ServiceRoutineModel> services) {
    return Container(
      padding: EdgeInsets.all(0),
      color: TColors.white,
      margin: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: 0),
      child: ServiceListView(services: services.map((x) => x.service).toList()),
    );
  }

  Widget _buildProductsSection(List<ProductRoutineModel> products) {
    return Container(
        color: TColors.white,
        padding: EdgeInsets.all(0),
        margin: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: 0),
        child: ProductListView(products: products.map((x) => x.product).toList()));
  }

  @override
  void initState() {
    super.initState();
    context.read<RoutineTrackingBloc>().add(GetRoutineTrackingEvent(GetRoutineTrackingParams(userId: widget.userId, routineId: widget.id)));
  }
}
