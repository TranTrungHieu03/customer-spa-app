import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/appointment_data.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
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
import 'package:spa_mobile/features/service/presentation/bloc/branch/branch_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/category/list_category_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_service/list_service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/screens/select_service_screen.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_horizontal_shimmer_card.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_horizotial_card.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperServiceScreen extends StatefulWidget {
  const WrapperServiceScreen({super.key});

  @override
  State<WrapperServiceScreen> createState() => _WrapperServiceScreenState();
}

class _WrapperServiceScreenState extends State<WrapperServiceScreen> {
  final appointmentController = AppointmentDataController();

  @override
  Widget build(BuildContext context) {
    // return BlocProvider<ListServiceBloc>(
    //   create: (context) => ListServiceBloc(
    //     getListService: serviceLocator(),
    //   ),
    //   child: const ServiceScreen(),
    // );
    return MultiBlocProvider(providers: [
      BlocProvider<ListServiceBloc>(
        create: (context) => ListServiceBloc(
          getListService: serviceLocator(),
        ),
      ),
      BlocProvider<BranchBloc>(create: (_) => BranchBloc(getBranchDetail: serviceLocator())),
      BlocProvider<ListCategoryBloc>(create: (context) => ListCategoryBloc(getListCategories: serviceLocator())),
    ], child: AppointmentData(controller: AppointmentDataController(), child: const SelectServiceScreen()));
  }
}

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late ScrollController _scrollController;
  int? selectedBranch;
  int? previousBranch;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeData();
  }

  Future<void> _initializeData() async {
    context.read<ListBranchesBloc>().add(GetListBranchesEvent());

    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    setState(() {
      selectedBranch = branchId != null ? int.parse(branchId) : 0;
      previousBranch = selectedBranch;
    });

    context.read<ListServiceBloc>().add(GetListServicesEvent(1, selectedBranch ?? 0, 10));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListServiceBloc, ListServiceState>(
      listener: (context, state) {
        if (state is ListServiceFailure) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      child: Scaffold(
        appBar: TAppbar(
          title: Text(
            AppLocalizations.of(context)!.service,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            TRoundedIcon(
              icon: Iconsax.search_normal,
              onPressed: () => goSearch(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<ListServiceBloc, ListServiceState>(
                    builder: (context, state) {
                      if (state is ListServiceLoaded) {
                        return Text(
                          "${state.pagination.totalCount.toString()} results",
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      } else if (state is ListServiceLoading) {
                        return const TShimmerEffect(width: TSizes.shimmerMd, height: TSizes.shimmerSx);
                      }
                      return const SizedBox();
                    },
                  ),
                  BlocConsumer<ListBranchesBloc, ListBranchesState>(
                    listener: (context, state) {
                      if (state is ListBranchesError) {
                        TSnackBar.errorSnackBar(context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is ListBranchesLoaded) {
                        return TRoundedContainer(
                          backgroundColor: TColors.primaryBackground,
                          padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                          child: SizedBox(
                            width: THelperFunctions.screenWidth(context) * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Bộ lọc",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TRoundedIcon(
                                  icon: Iconsax.setting_3,
                                  backgroundColor: TColors.primaryBackground,
                                  onPressed: () {
                                    _showFilterModel(context, state.branches);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return TRoundedContainer(
                        backgroundColor: TColors.primaryBackground,
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Bộ lọc",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TRoundedIcon(
                              icon: Iconsax.setting_3,
                              onPressed: () {
                                TSnackBar.warningSnackBar(context, message: "No branch available.");
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: TSizes.md),
              Expanded(
                child: BlocBuilder<ListServiceBloc, ListServiceState>(
                  builder: (context, state) {
                    if (state is ListServiceLoading) {
                      return TGridLayout(
                          crossAxisCount: 1,
                          itemCount: 4,
                          mainAxisExtent: 140,
                          itemBuilder: (context, _) {
                            return const TServiceHorizontalCardShimmer();
                          });
                    } else if (state is ListServiceEmpty) {
                      return const Center(
                        child: Text('No services available.', style: TextStyle(fontSize: 16)),
                      );
                    } else if (state is ListServiceLoaded) {
                      AppLogger.debug("BlocBuilder rebuild with state: $state");
                      return NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (scrollNotification is ScrollEndNotification && _scrollController.position.extentAfter < 200) {
                              final currentState = state;
                              if (!currentState.isLoadingMore && currentState.pagination.page < currentState.pagination.totalPage) {
                                context
                                    .read<ListServiceBloc>()
                                    .add(GetListServicesEvent(currentState.pagination.page + 1, selectedBranch ?? 0, 10));
                              }
                            }
                            return false;
                          },
                          child: RefreshIndicator(
                            onRefresh: () async {
                              context.read<ListServiceBloc>().emit(
                                    ListServiceLoading(
                                      isLoadingMore: false,
                                      services: [],
                                      pagination: PaginationModel.isEmty(),
                                    ),
                                  );
                              context.read<ListServiceBloc>().add(GetListServicesEvent(1, selectedBranch ?? 0, 10));
                            },
                            child: TGridLayout(
                              controller: _scrollController,
                              itemCount: state.services.length + 2,
                              crossAxisCount: 1,
                              mainAxisExtent: 140,
                              itemBuilder: (context, index) {
                                if (index == state.services.length || index == state.services.length + 1) {
                                  return state.isLoadingMore ? const TServiceHorizontalCardShimmer() : const SizedBox.shrink();
                                } else {
                                  final service = state.services[index];
                                  return TServiceHorizontalCard(
                                    service: service,
                                  );
                                }
                              },
                            ),
                          ));
                    } else if (state is ListServiceFailure) {
                      return const TErrorBody();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterModel(BuildContext context, List<BranchModel> branches) {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Branch',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: TSizes.sm),
                Padding(
                  padding: const EdgeInsets.all(TSizes.xs / 4),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: 0,
                        activeColor: TColors.primary,
                        groupValue: selectedBranch,
                        onChanged: (value) {
                          setState(() {
                            selectedBranch = value;
                          });
                        },
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                        ),
                        child: Text(
                          "Tất cả chi nhánh",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
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
                            groupValue: selectedBranch,
                            onChanged: (value) {
                              AppLogger.info('Selected branch: $selectedBranch ${selectedBranch == value}');
                              context.read<BranchBloc>().add(RefreshBranchEvent());
                              setState(() {
                                selectedBranch = value;
                              });
                            },
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                            ),
                            child: Text(
                              branch.branchName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: TSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        AppLogger.debug(selectedBranch);
                        if (selectedBranch != null) {
                          await LocalStorage.saveData(LocalStorageKey.defaultBranch, selectedBranch.toString());
                          if (selectedBranch != 0) {
                            await LocalStorage.saveData(
                                LocalStorageKey.branchInfo, jsonEncode(branches.where((e) => e.branchId == selectedBranch).first));
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                      ),
                      child: Text(
                        "Set as default",
                        style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    ).then((_) {
      if (selectedBranch != previousBranch)
        context.read<ListServiceBloc>().emit(
              ListServiceLoading(
                isLoadingMore: false,
                services: [],
                pagination: PaginationModel.isEmty(),
              ),
            );
      previousBranch = selectedBranch;
      context.read<ListServiceBloc>().add(GetListServicesEvent(1, selectedBranch ?? 0, 10));
    });
  }
}
