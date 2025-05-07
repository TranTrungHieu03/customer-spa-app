import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/mix_data.dart';
import 'package:spa_mobile/core/common/inherited/routine_data.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/add_to_routine_screen.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/product_list_view.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/service_list_view.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/presentation/blocs/nearest_branch/nearest_branch_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_branches_by_routine.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';

class WrapperRoutineDetail extends StatelessWidget {
  const WrapperRoutineDetail({super.key, required this.id, this.onlyShown = false});

  final String id;
  final bool onlyShown;

  @override
  Widget build(BuildContext context) {
    MixDataController mixDataController = MixDataController();
    return MixData(
        controller: mixDataController,
        child: RoutineData(
            controller: RoutineDataController(),
            child: RoutineDetailScreen(
              id: id,
              onlyShown: onlyShown,
            )));
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
  int? selectedBranchId;
  BranchModel? branchInfo;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    context.read<RoutineBloc>().add(GetRoutineDetailEvent(GetRoutineDetailParams(widget.id)));
    context.read<ListBranchesBloc>().add(GetListBranchesByRoutineEvent(GetBranchesByRoutineParams(widget.id)));
    loadLocalData();
  }

  void loadLocalData() async {
    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    if (branchId != "") {
      setState(() {
        selectedBranchId = int.parse(branchId);
      });
    }
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (jsonDecode(userJson) != null) {
      user = UserModel.fromJson(jsonDecode(userJson));
    } else {
      goLoginNotBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = RoutineData.of(context);
    final mixDataController = MixData.of(context);
    return BlocListener<ListBranchesBloc, ListBranchesState>(
      listener: (context, state) {
        if (state is ListBranchesError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
        if (state is ListBranchesLoaded) {
          final branches = state.branches;
          if (branches.isNotEmpty) {
            setState(() {
              branchInfo = branches.firstWhere((element) => element.branchId == selectedBranchId, orElse: () => branches.first);
              selectedBranchId = branchInfo?.branchId;
            });
          } else {
            TSnackBar.warningSnackBar(context,
                message: "Rất tiếc, hiện tại chưa có chi nhánh nào khả dụng cho gói này. Bạn vui lòng kiểm tra lại sau!");
          }
        }
      },
      child: BlocConsumer<RoutineBloc, RoutineState>(
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
                // leadingIcon: Iconsax.arrow_left,
                // leadingOnPressed: () {
                //   goRoutines();
                // },
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
                                mixDataController.updateUser(user ?? UserModel.empty());
                                _changeElement(context, mixDataController, routine);
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
                      Row(
                        children: [
                          Text("Chi nhánh có sẵn cho gói này", style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                      const SizedBox(height: TSizes.sm),
                      BlocBuilder<ListBranchesBloc, ListBranchesState>(
                        builder: (context, state) {
                          if (state is ListBranchesLoaded) {
                            return TRoundedContainer(
                              padding: const EdgeInsets.only(left: TSizes.md),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(state.branches
                                      .firstWhere((e) => e.branchId == selectedBranchId, orElse: () => state.branches.first)
                                      .branchName),
                                  TRoundedIcon(
                                      icon: Iconsax.edit_2,
                                      onPressed: () {
                                        _showFilterModel(context, state.branches);
                                      })
                                ],
                              ),
                            );
                          } else if (state is ListBranchesLoading) {
                            return const TLoader();
                          }
                          return const SizedBox();
                        },
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
              bottomNavigationBar: !widget.onlyShown || (branchInfo == null)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            controller.updateRoutine(routine);
                            AppLogger.info(branchInfo);
                            controller.updateBranch(branchInfo ?? BranchModel.empty());
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
      ),
    );
  }

  void _showFilterModel(BuildContext context, List<BranchModel> branchesState) {
    List<BranchModel> listBranches = branchesState;
    void update() {
      setState(() {
        branchInfo = listBranches.where((e) => e.branchId == selectedBranchId).first;
        selectedBranchId = branchInfo?.branchId;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.md)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: TSizes.md,
              right: TSizes.md,
              top: TSizes.sm,
              bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
            ),
            child: BlocBuilder<ListBranchesBloc, ListBranchesState>(
              builder: (context, state) {
                if (state is ListBranchesLoaded) {
                  final branches = state.branches;
                  listBranches = branches;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.branch,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: TSizes.sm),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: branches.length,
                        itemBuilder: (context, index) {
                          final branch = branches[index];
                          return Padding(
                            padding: const EdgeInsets.all(TSizes.xs / 4),
                            child: Row(
                              children: [
                                Radio<int>(
                                  value: branch.branchId,
                                  activeColor: TColors.primary,
                                  groupValue: selectedBranchId,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBranchId = value;
                                      branchInfo = branch;
                                    });
                                  },
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: THelperFunctions.screenWidth(context) * 0.7,
                                  ),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        branch.branchName,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      BlocBuilder<NearestBranchBloc, NearestBranchState>(builder: (context, distanceState) {
                                        if (distanceState is NearestBranchLoaded) {
                                          return Text(' (${distanceState.branches[index].distance.text})');
                                        } else if (distanceState is NearestBranchLoading) {
                                          return const TShimmerEffect(width: TSizes.shimmerSm, height: TSizes.shimmerSx);
                                        }
                                        return const SizedBox();
                                      })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: TSizes.md),
                    ],
                  );
                } else if (state is ListBranchesLoading) {
                  return const TLoader();
                }
                return const SizedBox();
              },
            ),
          );
        });
      },
    ).then((_) {
      // if (selectedBranchId != previousBranch) {
      update();
      // }
    });
  }

  void _changeElement(BuildContext context, MixDataController mixDataController, RoutineModel routine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(AppLocalizations.of(context)!.products_and_services),
          content: Text("Ở bước này, giá ưu đãi của gói liệu trình sẽ không còn áp dụng, và các dịch vụ, sản phẩm sẽ tính theo giá gốc."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                mixDataController.updateBranch(branchInfo);
                mixDataController.updateBranchId(selectedBranchId ?? 1);
                AppLogger.info(branchInfo);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WrapperAddToRoutine(
                        routineId: routine.skincareRoutineId.toString(),
                        routine: routine,
                        branchId: selectedBranchId ?? 1,
                        controller: mixDataController),
                  ),
                );

                // Refresh the routine if items were added
                if (result == true) {
                  context.read<RoutineBloc>().add(GetRoutineDetailEvent(GetRoutineDetailParams(widget.id)));
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.red),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(AppLocalizations.of(context)!.next),
              ),
            ),
          ],
        );
      },
    );
  }
}
