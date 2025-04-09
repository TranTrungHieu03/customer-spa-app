import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:iconsax/iconsax.dart";
import 'package:spa_mobile/core/common/inherited/appointment_data.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/sliver_delegate.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_distance.dart';
import 'package:spa_mobile/features/home/presentation/blocs/nearest_branch/nearest_branch_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_branch_detail.dart';
import 'package:spa_mobile/features/service/presentation/bloc/branch/branch_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_service/list_service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/screens/service_detail_screen.dart';

class SelectServiceScreen extends StatefulWidget {
  const SelectServiceScreen({super.key});

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> with TickerProviderStateMixin {
  // Controllers
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  UserModel user = UserModel.empty();

  // UI State
  bool _isScrolled = false;
  bool _isTabHandlerActive = false;

  // Data structures
  final List<GlobalKey> _serviceSectionKeys = [];
  final Set<int> _selectedServiceIds = {};
  double totalAmount = 0;
  int totalTime = 0;

  //branch
  int? selectedBranch;
  int? previousBranch;
  BranchModel? branchInfo;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadLocalData();
    context.read<ListBranchesBloc>().add(GetListBranchesEvent());
    // Initial data loading
  }

  Future<void> _loadLocalData() async {
    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    AppLogger.debug(branchId);
    if (mounted) {
      if (branchId == "") {
        setState(() {
          selectedBranch = 1;
          previousBranch = selectedBranch;
        });
        context.read<BranchBloc>().add(GetBranchDetailEvent(GetBranchDetailParams(1)));
      } else {
        branchInfo = BranchModel.fromJson(json.decode(await LocalStorage.getData(LocalStorageKey.branchInfo)));
        AppLogger.debug(branchInfo);
        setState(() {
          selectedBranch = int.parse(branchId);
          previousBranch = selectedBranch;
        });
      }

      final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
      AppLogger.info(userJson);
      if (jsonDecode(userJson) != null) {
        user = UserModel.fromJson(jsonDecode(userJson));
      } else {
        goLoginNotBack();
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListServiceBloc>().add(
            GetListServicesForSelectionEvent(1, selectedBranch ?? 1, 100),
          );
    });
  }

  void _initTabController(int tabCount) {
    if (_tabController == null || _tabController!.length != tabCount) {
      _tabController?.dispose();
      _tabController = TabController(
        length: tabCount,
        vsync: this,
      );
      _tabController!.addListener(_handleTabSelection);
    }
  }

  // Handle tab selection changes (from user tapping tabs)
  void _handleTabSelection() {
    if (!_isTabHandlerActive && _tabController!.indexIsChanging) {
      final state = context.read<ListServiceBloc>().state;
      if (state is! ListServiceLoadedForSelection) return;

      final selectedCategoryId = state.categories[_tabController!.index].categoryId;
      context.read<ListServiceBloc>().add(SelectCategoryEvent(selectedCategoryId));

      // Set flag to prevent recursive actions
      _isTabHandlerActive = true;

      // Smooth scroll to the corresponding section
      _scrollToCategory(selectedCategoryId);
      AppLogger.debug('Selected category: $selectedCategoryId');

      // Reset flag after scrolling completes
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isTabHandlerActive = false;
          });
        }
      });
    }
  }

  void _toggleServiceSelection(int serviceId) {
    setState(() {
      if (_selectedServiceIds.contains(serviceId)) {
        _selectedServiceIds.remove(serviceId);
      } else {
        _selectedServiceIds.add(serviceId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  // Optimized scroll handler with throttling
  void _onScroll() {
    // Update app bar appearance based on scroll position
    final isScrolledNow = _scrollController.offset > 30;
    if (_isScrolled != isScrolledNow) {
      setState(() {
        _isScrolled = isScrolledNow;
      });
    }

    // Skip the category check if tab handler is already active
    if (_isTabHandlerActive) return;

    // Throttle scroll events to reduce performance impact
    _updateTabBasedOnScroll();
  }

  void _updateTabBasedOnScroll() {
    final state = context.read<ListServiceBloc>().state;
    if (state is! ListServiceLoadedForSelection || _tabController == null) return;

    // Đặt cờ để ngăn chặn các hành động đệ quy
    _isTabHandlerActive = true;

    // Lấy kích thước viewport
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final viewportHeight = renderBox?.size.height ?? 600;
    final viewportTop = 180.0; // Vị trí gần đúng nơi nội dung bắt đầu dưới các tab

    // Tìm danh mục hiện tại dựa trên vị trí tiêu đề
    int? visibleIndex;

    // Danh sách các danh mục có thể nhìn thấy và vị trí của chúng
    final List<MapEntry<int, double>> visibleSections = [];

    for (int i = 0; i < _serviceSectionKeys.length; i++) {
      final key = _serviceSectionKeys[i];
      final renderContext = key.currentContext;
      if (renderContext == null) continue;

      final box = renderContext.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero).dy;

      // Kiểm tra xem phần tử này có nằm trong viewport không
      if (position >= viewportTop - 100 && position <= viewportTop + viewportHeight + 100) {
        visibleSections.add(MapEntry(i, position));
      }
    }

    if (visibleSections.isNotEmpty) {
      // Sắp xếp các phần hiển thị theo vị trí từ trên xuống
      visibleSections.sort((a, b) => a.value.compareTo(b.value));

      // Logic quyết định tab nào được chọn
      // Chọn phần tử đầu tiên nằm hoàn toàn trong viewport hoặc gần nhất với đỉnh viewport
      for (final section in visibleSections) {
        if (section.value <= viewportTop + 50) {
          visibleIndex = section.key;
          break;
        }
      }

      // Nếu không tìm thấy phần tử nào phù hợp, sử dụng phần tử đầu tiên trong danh sách
      visibleIndex ??= visibleSections.first.key;
    }

    // Cập nhật lựa chọn tab nếu cần
    if (visibleIndex != null && _tabController!.index != visibleIndex) {
      _tabController!.animateTo(visibleIndex, duration: Duration.zero);
      setState(() {
        _tabController!.index = visibleIndex!;
      });
    }

    // Đặt lại cờ sau một khoảng thời gian ngắn
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _isTabHandlerActive = false;
      }
    });
  }

  void _scrollToCategory(int categoryId) {
    final state = context.read<ListServiceBloc>().state;
    if (state is! ListServiceLoadedForSelection) return;

    final index = state.categories.indexWhere((cat) => cat.categoryId == categoryId);
    AppLogger.info(_serviceSectionKeys[index]);
    if (index < 0 || index >= _serviceSectionKeys.length) return;

    final key = _serviceSectionKeys[index];
    final contextBox = key.currentContext;
    if (contextBox == null) return;
    AppLogger.info(_serviceSectionKeys[index]);
    // Use smoother scrolling with better positioning
    Scrollable.ensureVisible(
      contextBox,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = AppointmentData.of(context);
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            expandedHeight: 120.0,
            leading: const SizedBox(
              width: 0,
            ),
            flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(
                  left: 15,
                  bottom: 16.0,
                ),
                collapseMode: CollapseMode.pin,
                title: DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleLarge!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: BlocBuilder<BranchBloc, BranchState>(
                          builder: (context, state) {
                            if (state is BranchLoaded) {
                              final branch = state.branchModel;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    branch.branchName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (!_isScrolled)
                                    Text(
                                      branch.branchAddress,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                ],
                              );
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  branchInfo?.branchName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (!_isScrolled)
                                  Text(
                                    branchInfo?.branchAddress ?? "",
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      if (!_isScrolled)
                        TRoundedIcon(
                          width: 30,
                          height: 30,
                          icon: Iconsax.filter,
                          size: 16,
                          onPressed: () {
                            final state = context.read<ListBranchesBloc>().state;
                            if (state is ListBranchesLoaded) {
                              context.read<NearestBranchBloc>().add(GetNearestBranchEvent(params: GetDistanceParams(state.branches)));
                              _showFilterModel(context, state.branches);
                            }
                          },
                        ),
                      const SizedBox(width: TSizes.xs),
                    ],
                  ),
                )),
            actions: [
              TRoundedIcon(
                icon: Iconsax.search_normal,
                onPressed: () => goSearch(),
              ),
              const SizedBox(width: TSizes.md),
            ],
            bottom: _isScrolled
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: TColors.darkGrey.withOpacity(0.3),
                            blurRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: TSliverPersistentHeaderDelegate(
              maxHeight: 75,
              minHeight: 75,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.sm),
                child: BlocBuilder<ListServiceBloc, ListServiceState>(
                  builder: (context, state) {
                    if (state is ListServiceLoadedForSelection) {
                      _initTabController(state.categories.length);

                      return SizedBox(
                        height: 70,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicator: const BoxDecoration(),
                          indicatorWeight: 0,
                          labelPadding: const EdgeInsets.only(right: TSizes.sm, bottom: TSizes.sm),
                          tabs: state.categories.map((category) {
                            return Tab(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                                decoration: BoxDecoration(
                                  color: _tabController!.index == state.categories.indexOf(category)
                                      ? TColors.primary
                                      : TColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(TSizes.lg),
                                ),
                                child: Center(
                                  child: Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                          color: _tabController!.index == state.categories.indexOf(category) ? TColors.white : TColors.dark,
                                        ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: GestureDetector(
                  onTap: () => goRoutines(),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Xem các gói liệu trình", style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(width: TSizes.sm),
                        const Icon(Iconsax.arrow_right_1)
                      ],
                    ),
                  )),
            ),
          ),
          BlocBuilder<ListServiceBloc, ListServiceState>(
            builder: (context, state) {
              if (state is ListServiceLoadingForSelection) {
                return const SliverToBoxAdapter(child: TLoader());
              } else if (state is ListServiceLoadedForSelection) {
                // Initialize keys if needed
                if (_serviceSectionKeys.length != state.categories.length) {
                  _serviceSectionKeys
                    ..clear()
                    ..addAll(List.generate(state.categories.length, (_) => GlobalKey()));
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = state.categories[index];
                      final services = state.groupedServices[category.categoryId] ?? [];

                      return Column(
                        key: _serviceSectionKeys[index],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: TSizes.md, right: TSizes.md, top: TSizes.xl),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: TSizes.sm,
                                ),
                                Text(category.description, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: services.length,
                            itemBuilder: (context, i) {
                              final service = services[i];
                              return GestureDetector(
                                onTap: () {
                                  controller.updateBranch(branchInfo);
                                  controller.updateBranchId(selectedBranch ?? 0);
                                  controller.updateUser(user);
                                  _showServiceDetail(context, service.serviceId, selectedBranch ?? 0, controller);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TProductTitleText(title: service.name, smallSize: true),
                                                const SizedBox(height: TSizes.xs),
                                                Text(
                                                  "${service.duration} ${AppLocalizations.of(context)?.minutes ?? 'minutes'}",
                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.darkerGrey),
                                                ),
                                                const SizedBox(height: TSizes.xs),
                                                Text(
                                                  formatMoney(service.price.toString()),
                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TRoundedIcon(
                                            icon: _selectedServiceIds.contains(service.serviceId) ? Icons.check : Iconsax.add,
                                            width: 40,
                                            height: 40,
                                            size: 24,
                                            backgroundColor: _selectedServiceIds.contains(service.serviceId)
                                                ? TColors.primary
                                                : TColors.primaryBackground,
                                            color: _selectedServiceIds.contains(service.serviceId) ? Colors.white : TColors.primary,
                                            onPressed: () {
                                              _toggleServiceSelection(service.serviceId);
                                              setState(() {
                                                if (_selectedServiceIds.contains(service.serviceId)) {
                                                  totalAmount += service.price;
                                                  totalTime += int.parse(service.duration);
                                                } else {
                                                  totalAmount -= service.price;
                                                  totalTime -= int.parse(service.duration);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: TSizes.sm),
                                      Divider(
                                        color: dark ? TColors.darkGrey : TColors.grey,
                                        thickness: 0.5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                    childCount: state.categories.length,
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 200,
          ))
        ],
      ),
      bottomNavigationBar: BlocBuilder<ListServiceBloc, ListServiceState>(
        builder: (context, state) {
          if (state is ListServiceLoadedForSelection && _selectedServiceIds.isNotEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: TColors.darkGrey.withOpacity(0.3),
                    blurRadius: 1,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatMoney(totalAmount.toString()),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${_selectedServiceIds.length} services'),
                        const SizedBox(
                          width: TSizes.xs,
                        ),
                        const Text('•'),
                        const SizedBox(
                          width: TSizes.xs,
                        ),
                        Text(formatDuration(totalTime))
                      ],
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    controller.updateServiceIds(_selectedServiceIds.toList()..sort());
                    controller.updateServices((_selectedServiceIds.toList()..sort())
                        .map((id) => state.services.firstWhere((service) => service.serviceId == id))
                        .toList());
                    controller.updateTime(totalTime);
                    controller.updateTotalPrice(totalAmount);
                    controller.updateBranchId(selectedBranch ?? 0);
                    controller.updateBranch(branchInfo);
                    controller.updateUser(user);
                    goSelectSpecialist(selectedBranch ?? 0, controller);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.continue_book,
                  ),
                )
              ]),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showServiceDetail(BuildContext context, int serviceId, int branchId, AppointmentDataController controller) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .95,
          child: ServiceDetailScreen(serviceId: serviceId, branchId: branchId, controller: controller),
        );
      },
    );
  }

  void _showFilterModel(BuildContext context, List<BranchModel> branchesState) {
    List<BranchModel> listBranches = branchesState;
    void updateServices() {
      context.read<ListServiceBloc>().add(RefreshListServiceEvent());
      previousBranch = selectedBranch;
      setState(() {
        branchInfo = listBranches.where((e) => e.branchId == selectedBranch).first;
      });
      _selectedServiceIds.clear();
      context.read<ListServiceBloc>().add(GetListServicesForSelectionEvent(1, selectedBranch ?? 0, 100));
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
                        'Branch',
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
                                  groupValue: selectedBranch,
                                  onChanged: (value) {
                                    AppLogger.info('Selected branch: $branch');

                                    setState(() {
                                      selectedBranch = value;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              AppLogger.debug(selectedBranch);
                              if (selectedBranch != null) {
                                await LocalStorage.saveData(LocalStorageKey.defaultBranch, selectedBranch.toString());
                                if (selectedBranch != 0) {
                                  AppLogger.info(jsonEncode(branches.where((e) => e.branchId == selectedBranch).first));
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
      if (selectedBranch != previousBranch) {
        updateServices();
      }
    });
  }
}
