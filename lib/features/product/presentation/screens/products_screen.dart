import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
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
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_distance.dart';
import 'package:spa_mobile/features/home/presentation/blocs/nearest_branch/nearest_branch_bloc.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_product/list_product_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_card_shimmer.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_vertical_card.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_branch_detail.dart';
import 'package:spa_mobile/features/service/presentation/bloc/branch/branch_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperProductsScreen extends StatefulWidget {
  const WrapperProductsScreen({super.key});

  @override
  State<WrapperProductsScreen> createState() => _WrapperProductsScreenState();
}

class _WrapperProductsScreenState extends State<WrapperProductsScreen> {
  final PurchasingDataController controller = PurchasingDataController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ListProductBloc>(
          create: (context) => ListProductBloc(getListProducts: serviceLocator()),
        ),
        BlocProvider<BranchBloc>(create: (_) => BranchBloc(getBranchDetail: serviceLocator())),
      ],
      child: PurchasingData(
        controller: controller,
        child: const ProductsScreen(),
      ),
    );
  }
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ScrollController _scrollController;
  late GetListProductParams params;
  late PurchasingDataController controller;

//branch
  int? selectedBranch;
  int? previousBranch;
  BranchModel? branchInfo;
  UserModel? userId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadLocalData();
    context.read<ListBranchesBloc>().add(GetListBranchesEvent());
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      final currentState = context.read<ListProductBloc>().state;
      if (currentState is ListProductLoaded &&
          !currentState.isLoadingMore &&
          currentState.pagination.page < currentState.pagination.totalPage) {
        context.read<ListProductBloc>().add(GetListProductsEvent(GetListProductParams(
            brand: "",
            page: currentState.pagination.page + 1,
            branchId: selectedBranch ?? 1,
            categoryId: [],
            minPrice: -1,
            maxPrice: -1,
            sortBy: "")));
      }
    }
  }

  void _onFilter() {
    AppLogger.info(params.branchId);
    context.read<ListProductBloc>().add(RefreshListProductEvent());
    context.read<ListProductBloc>().add(GetListProductsEvent(params));
  }

  Future<void> _loadLocalData() async {
    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    AppLogger.debug(branchId);
    if (mounted) {
      if (branchId == "") {
        // TSnackBar.warningSnackBar(context, message: "Vui lòng chọn chi nhánh để tiếp tục.");
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
    }
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    AppLogger.info(userJson);
    if (jsonDecode(userJson) != null) {
      userId = UserModel.fromJson(jsonDecode(userJson));
    } else {
      goLoginNotBack();
    }

    if (userId?.district == 0 || userId?.wardCode == 0) {
      TSnackBar.infoSnackBar(context, message: AppLocalizations.of(context)!.update_address_to_purchase);
    }
    params = GetListProductParams.empty(selectedBranch ?? 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListProductBloc>().add(GetListProductsEvent(
          GetListProductParams(brand: "", page: 1, branchId: selectedBranch ?? 1, categoryId: [], minPrice: -1, maxPrice: -1, sortBy: "")));
      controller = PurchasingData.of(context)
        ..updateBranchId(selectedBranch ?? 1)
        ..updateUser(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      appBar: TAppbar(
        title: Text(
          AppLocalizations.of(context)!.products,
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
        ),
        actions: [
          TRoundedIcon(
            icon: Iconsax.shopping_cart,
            onPressed: () => goCart(controller),
            size: 30,
          )
        ],
      ),
      body: BlocListener<ListProductBloc, ListProductState>(
        listener: (context, state) {
          if (state is ListProductFailure) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
        child: BlocListener<CartBloc, CartState>(
          listener: (context, cartState) {
            if (cartState is CartSuccess) {
              TSnackBar.successSnackBar(context, message: cartState.message);
            } else if (cartState is CartError) {
              TSnackBar.errorSnackBar(context, message: cartState.message);
            }
          },
          child: Stack(children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: TSizes.spacebtwSections,
                    ),
                    const SizedBox(
                      height: TSizes.spacebtwSections,
                    ),
                    BlocBuilder<ListProductBloc, ListProductState>(builder: (context, state) {
                      if (state is ListProductLoading) {
                        return TGridLayout(
                          itemCount: 4,
                          crossAxisCount: 2,
                          isScroll: false,
                          itemBuilder: (context, index) {
                            return const TProductCardShimmer();
                          },
                        );
                      } else if (state is ListProductEmpty) {
                        return Center(
                          child: Text(AppLocalizations.of(context)!.no_product_available, style: TextStyle(fontSize: 16)),
                        );
                      } else if (state is ListProductLoaded) {
                        return TGridLayout(
                          crossAxisCount: 2,
                          itemCount: state.products.length + 2,
                          mainAxisExtent: 290,
                          isScroll: false,
                          itemBuilder: (context, index) {
                            if (index == state.products.length || index == state.products.length + 1) {
                              return state.isLoadingMore ? const TProductCardShimmer() : const SizedBox();
                            }
                            return TProductCardVertical(
                              productModel: state.products[index],
                              width: THelperFunctions.screenWidth(context) * 0.4,
                            );
                          },
                        );
                      } else if (state is ListProductFailure) {
                        return const TErrorBody();
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(TSizes.sm),
                color: TColors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _showSortBottomSheet(context),
                      child: TRoundedContainer(
                        padding: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.md),
                        backgroundColor: TColors.primaryBackground,
                        radius: 20,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.sort,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(
                              width: TSizes.xs,
                            ),
                            const Icon(
                              Iconsax.arrow_down_1,
                              size: 16,
                              weight: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: TSizes.sm,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     final state = context.read<ListBranchesBloc>().state;
                    //     if (state is ListBranchesLoaded) {
                    //       context.read<NearestBranchBloc>().add(GetNearestBranchEvent(params: GetDistanceParams(state.branches)));
                    //       _showFilterBottomSheet(context);
                    //       // _showFilterModel(context, state.branches);
                    //     }
                    //   },
                    //   child: TRoundedContainer(
                    //     padding: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.md),
                    //     backgroundColor: TColors.primaryBackground,
                    //     radius: 20,
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       crossAxisAlignment: CrossAxisAlignment.end,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           AppLocalizations.of(context)!.filter,
                    //           style: Theme.of(context).textTheme.labelLarge,
                    //         ),
                    //         const SizedBox(
                    //           width: TSizes.xs,
                    //         ),
                    //         const Icon(
                    //           Iconsax.arrow_down_1,
                    //           size: 16,
                    //           weight: 20,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        final state = context.read<ListBranchesBloc>().state;
                        if (state is ListBranchesLoaded) {
                          context.read<NearestBranchBloc>().add(GetNearestBranchEvent(params: GetDistanceParams(state.branches)));
                          _showFilterModel(context, state.branches);
                        }
                      },
                      child: TRoundedContainer(
                        padding: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.md),
                        backgroundColor: TColors.primaryBackground,
                        radius: 20,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.branch,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(
                              width: TSizes.xs,
                            ),
                            const Icon(
                              Iconsax.arrow_down_1,
                              size: 16,
                              weight: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (context.read<CartBloc>().state is CartLoading) const TLoader()
          ]),
        ),
      ),
    );
  }

  void _showFilterModel(BuildContext context, List<BranchModel> branchesState) {
    List<BranchModel> listBranches = branchesState;
    void updateProducts() {
      context.read<ListProductBloc>().add(RefreshListProductEvent());
      previousBranch = selectedBranch;
      setState(() {
        branchInfo = listBranches.where((e) => e.branchId == selectedBranch).first;
      });
      // _selectedServiceIds.clear();
      // context.read<ListServiceBloc>().add(GetListServicesForSelectionEvent(1, selectedBranch ?? 0, 100));
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
                  context.read<NearestBranchBloc>().add(GetNearestBranchEvent(params: GetDistanceParams(state.branches)));
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
                                  groupValue: selectedBranch,
                                  onChanged: (value) {
                                    AppLogger.info('Selected branch: $value');
                                    params = params.copyWith(branchId: value);

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
                                      const SizedBox(
                                        width: TSizes.xs,
                                      ),
                                      BlocBuilder<NearestBranchBloc, NearestBranchState>(builder: (context, distanceState) {
                                        if (distanceState is NearestBranchLoaded) {
                                          return Text('(${distanceState.branches[index].distance.text})');
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
                              AppLocalizations.of(context)!.set_as_default,
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
        updateProducts();
        _onFilter();
      }
    });
  }

  void _showSortBottomSheet(BuildContext context) {
    String previousSortType = params.sortBy == SortBy.priceDesc.value ? "1" : (params.sortBy == SortBy.priceAsc.value ? "0" : "");
    String selectedSortType = previousSortType;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<String>(
                  title: Text(AppLocalizations.of(context)!.price_descending),
                  value: "1",
                  activeColor: TColors.primary,
                  groupValue: selectedSortType,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedSortType = value;
                        params = params.copyWith(sortBy: value);
                      });
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(AppLocalizations.of(context)!.price_ascending),
                  value: "0",
                  activeColor: TColors.primary,
                  groupValue: selectedSortType,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedSortType = value;
                        params = params.copyWith(sortBy: value);
                      });
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(TSizes.sm),
                      child: TextButton(
                        onPressed: () {
                          if (selectedSortType != "") {
                            selectedSortType = "";
                            params = params.copyWith(sortBy: "");
                            _onFilter();
                          }

                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(color: TColors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(TSizes.sm),
                      child: TextButton(
                        onPressed: selectedSortType == ""
                            ? null
                            : () {
                                _onFilter();
                                Navigator.pop(context);
                              },
                        child: Text(AppLocalizations.of(context)!.apply),
                      ),
                    ),
                    const SizedBox(
                      width: TSizes.md,
                    )
                  ],
                )
              ],
            );
          },
        );
      },
    ).then((_) {
      if (previousSortType != selectedSortType) {
        _onFilter();
      }
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: FilterBottomSheet(),
        );
      },
    );
  }
}

// Enum for sorting types
// enum SortType { priceAsc, priceDesc }

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(0, 10000);
  List<int> _ratings = [];
  List<String> _selectedBrands = [];
  String? _selectedBrand;
  List<BranchModel> listBranches = [];

  //branch
  int? selectedBranch;
  int? previousBranch;
  BranchModel? branchInfo;

  // Sample brand list - replace with your actual brands
  final List<String> _availableBrands = ['Nike', 'Adidas', 'Puma', 'Reebok', 'New Balance', 'Under Armour'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(AppLocalizations.of(context)!.product_filter, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: TSizes.lg),

            // Price Range Slider
            Text(AppLocalizations.of(context)!.price_range, style: Theme.of(context).textTheme.bodyLarge),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 10000,
              divisions: 100,
              labels: RangeLabels(formatMoney(_priceRange.start.round().toString()), formatMoney(_priceRange.end.round().toString())),
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),

            // Ratings Selection
            // SizedBox(height: 16),
            // Text(
            //   'Ratings',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // Wrap(
            //   spacing: 8,
            //   children: List.generate(5, (index) {
            //     int rating = index + 1;
            //     return ChoiceChip(
            //       label: Text('$rating ★'),
            //       selected: _ratings.contains(rating),
            //       onSelected: (bool selected) {
            //         setState(() {
            //           if (selected) {
            //             _ratings.add(rating);
            //           } else {
            //             _ratings.remove(rating);
            //           }
            //         });
            //       },
            //       selectedColor: Colors.amber[100],
            //       backgroundColor: Colors.grey[200],
            //     );
            //   }),
            // ),

            // Brand Selection
            const SizedBox(height: TSizes.lg),
            // ExpansionTile(
            //   title: Text(AppLocalizations.of(context)!.brand, style: Theme.of(context).textTheme.bodyLarge),
            //   children: [
            //     Container(
            //       height: 400,
            //       child: ListView(
            //         children: _availableBrands.map((brand) {
            //           return CheckboxListTile(
            //             title: Text(brand),
            //             value: _selectedBrands.contains(brand),
            //             onChanged: (bool? selected) {
            //               setState(() {
            //                 if (selected == true) {
            //                   _selectedBrands.add(brand);
            //                 } else {
            //                   _selectedBrands.remove(brand);
            //                 }
            //               });
            //             },
            //             controlAffinity: ListTileControlAffinity.leading,
            //           );
            //         }).toList(),
            //       ),
            //     ),
            //   ],
            // ),

            ExpansionTile(title: Text(AppLocalizations.of(context)!.branch, style: Theme.of(context).textTheme.bodyLarge), children: [
              BlocBuilder<ListBranchesBloc, ListBranchesState>(
                builder: (context, state) {
                  if (state is ListBranchesLoaded) {
                    context.read<NearestBranchBloc>().add(GetNearestBranchEvent(params: GetDistanceParams(state.branches)));
                    final branches = state.branches;
                    listBranches = branches;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     ElevatedButton(
                        //       onPressed: () async {
                        //         AppLogger.debug(selectedBranch);
                        //         if (selectedBranch != null) {
                        //           await LocalStorage.saveData(LocalStorageKey.defaultBranch, selectedBranch.toString());
                        //           if (selectedBranch != 0) {
                        //             await LocalStorage.saveData(
                        //                 LocalStorageKey.branchInfo, jsonEncode(branches.where((e) => e.branchId == selectedBranch).first));
                        //           }
                        //           Navigator.of(context).pop();
                        //         }
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //         padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                        //       ),
                        //       child: Text(
                        //         "Set as default",
                        //         style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    );
                  } else if (state is ListBranchesLoading) {
                    return const TLoader();
                  }
                  return const SizedBox();
                },
              ),
            ]),

            // Apply Filters Button
            const SizedBox(height: TSizes.lg),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.read<ListProductBloc>().add(GetListProductsEvent(GetListProductParams(
                      brand: "",
                      page: 1,
                      branchId: selectedBranch ?? 1,
                      categoryId: [],
                      minPrice: _priceRange.start,
                      maxPrice: _priceRange.end,
                      sortBy: "")));
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.apply,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
