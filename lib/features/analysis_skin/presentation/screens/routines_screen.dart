import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_history.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_routine/list_routine_bloc.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
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
  UserModel? user;

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
                  final suitable = state.suitable;
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final routine = routines[index];
                        // final List<String> listSteps = routine.steps.split(", ");
                        return GestureDetector(
                          onTap: () => goRoutineDetail(routine.skincareRoutineId.toString()),
                          child: Stack(
                            children: [
                              TRoundedContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        routine.name,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(routine.description),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              formatMoney(routine.totalPrice.toString()),
                                              style: const TextStyle(
                                                color: Colors.teal,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        goRoutineDetail(routine.skincareRoutineId.toString());
                                      },
                                    ),
                                    const SizedBox(height: TSizes.md),
                                  ],
                                ),
                              ),
                              if (suitable.any((s) => s.skincareRoutineId == routine.skincareRoutineId))
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Transform.rotate(
                                    angle: 0.185398, // 45 degrees in radians
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      color: Colors.red,
                                      child: Text(
                                        AppLocalizations.of(context)!.match,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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

  void _loadData() async {
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (userJson != null) {
      user = UserModel.fromJson(jsonDecode(userJson));
      if (user?.userId != null && user!.userId != 0) {
        final bloc = context.read<ListRoutineBloc>();
        bloc.stream.firstWhere((state) => state is ListRoutineLoaded).then((state) {
          bloc.add(GetSuitableRoutineEvent(GetRoutineHistoryParams(
            userId: user!.userId,
            status: "Suitable",
          )));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ListRoutineBloc>().add(GetListRoutineEvent());
    _loadData();
  }
}
