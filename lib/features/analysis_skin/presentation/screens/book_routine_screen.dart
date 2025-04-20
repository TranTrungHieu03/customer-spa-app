import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/product_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/service_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_step.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_routine_step/list_routine_step_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_list_view.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_list_view.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperBookRoutineScreen extends StatefulWidget {
  const WrapperBookRoutineScreen({super.key, required this.id});

  final int id;

  @override
  State<WrapperBookRoutineScreen> createState() => _WrapperBookRoutineScreenState();
}

class _WrapperBookRoutineScreenState extends State<WrapperBookRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListRoutineStepBloc>(
      create: (context) => ListRoutineStepBloc(getRoutineStep: serviceLocator()),
      child: BookRoutineScreen(id: widget.id),
    );
  }
}

class BookRoutineScreen extends StatefulWidget {
  final int id;

  const BookRoutineScreen({super.key, required this.id});

  @override
  State<BookRoutineScreen> createState() => _BookRoutineScreenState();
}

class _BookRoutineScreenState extends State<BookRoutineScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListRoutineStepBloc, ListRoutineStepState>(
      listener: (context, state) {
        if (state is ListRoutineStepError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      child: BlocBuilder<ListRoutineStepBloc, ListRoutineStepState>(
        builder: (context, state) {
          if (state is ListRoutineStepLoaded) {
            final routineSteps = state.routines;
            return Scaffold(
              appBar: TAppbar(
                showBackArrow: true,
                title: Text(AppLocalizations.of(context)!.step_details),
              ),
              body: Padding(
                padding: const EdgeInsets.all(0),
                child: Stepper(
                  margin: EdgeInsets.all(0),
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
                        if (_currentStep > 0)
                          OutlinedButton(
                            onPressed: details.onStepCancel,
                            child: Text(AppLocalizations.of(context)!.back),
                          ),
                        const SizedBox(
                          width: TSizes.lg,
                        ),
                        if (_currentStep < routineSteps.length - 1)
                          OutlinedButton(onPressed: details.onStepContinue, child: Text(AppLocalizations.of(context)!.next)),
                      ],
                    );
                  },
                  steps: routineSteps.map((step) {
                    return Step(
                      title: Text(step.name),
                      subtitle: Text('${AppLocalizations.of(context)!.steps} ${step.step}'),
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
          } else if (state is ListRoutineStepLoading) {
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
    context.read<ListRoutineStepBloc>().add(GetRoutineStepEvent(GetRoutineStepParams(widget.id)));
  }
}
