import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:spa_mobile/features/home/domain/usecases/get_distance.dart';
import 'package:spa_mobile/features/home/presentation/blocs/nearest_branch/nearest_branch_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_product/list_product_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_card_shimmer.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_vertical_card.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_service/list_service_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperProductsScreen extends StatefulWidget {
  const WrapperProductsScreen({super.key});

  @override
  State<WrapperProductsScreen> createState() => _WrapperProductsScreenState();
}

class _WrapperProductsScreenState extends State<WrapperProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListProductBloc>(
      create: (context) => ListProductBloc(serviceLocator()),
      child: const ProductsScreen(),
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

//branch
  int? selectedBranch;
  int? previousBranch;
  BranchModel? branchInfo;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadLocalData();
    context.read<ListProductBloc>().add(GetListProductsEvent(1));
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      final currentState = context.read<ListProductBloc>().state;
      if (currentState is ListProductLoaded &&
          !currentState.isLoadingMore &&
          currentState.pagination.page < currentState.pagination.totalPage) {
        context.read<ListProductBloc>().add(GetListProductsEvent(currentState.pagination.page + 1));
      }
    }
  }

  Future<void> _loadLocalData() async {
    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    AppLogger.debug(branchId);
    if (mounted) {
      if (int.parse(branchId) == 0) {
        TSnackBar.warningSnackBar(context, message: "Vui lòng chọn chi nhánh để tiếp tục.");
      } else {
        branchInfo = BranchModel.fromJson(json.decode(await LocalStorage.getData(LocalStorageKey.branchInfo)));
        AppLogger.debug(branchInfo);
        setState(() {
          selectedBranch = int.parse(branchId);
          previousBranch = selectedBranch;
        });
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListServiceBloc>().add(
            GetListServicesForSelectionEvent(1, selectedBranch ?? 1, 100),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      appBar: TAppbar(
        title: Text(
          'Product',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
        ),
        actions: [
          TRoundedIcon(
            icon: Iconsax.shopping_cart,
            onPressed: () => goCart(),
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
          listener: (context, state) {
            if (state is CartSuccess) {
              TSnackBar.successSnackBar(context, message: state.message);
            } else if (state is CartError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          child: Stack(
            children: [
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
                          return const Center(
                            child: Text('No product available.', style: TextStyle(fontSize: 16)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                "Sắp xếp",
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
                      GestureDetector(
                        onTap: () => _showFilterBottomSheet(context),
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
                                "Bộ lọc",
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
                      GestureDetector(
                        onTap: () => _showFilterModel(context),
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
                                "Chi nhánh",
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterModel(BuildContext context) {
    List<BranchModel> listBranches = [];
    void updateServices() {
      context.read<ListServiceBloc>().add(RefreshListServiceEvent());
      previousBranch = selectedBranch;
      setState(() {
        branchInfo = listBranches.where((e) => e.branchId == selectedBranch).first;
      });
      // _selectedServiceIds.clear();
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
                  context.read<NearestBranchBloc>().add(GetNearestBranchEvent(params: GetDistanceParams(state.branches)));
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

void _showSortBottomSheet(BuildContext context) {
  SortType? selectedSortType; // Biến để lưu trữ loại sắp xếp được chọn

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // Sử dụng StatefulBuilder để cập nhật UI khi chọn radio
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<SortType>(
                title: const Text('Giá giảm dần'),
                value: SortType.priceAsc,
                activeColor: TColors.primary,
                groupValue: selectedSortType,
                onChanged: (SortType? value) {
                  setState(() {
                    selectedSortType = value;
                  });
                },
              ),
              RadioListTile<SortType>(
                title: const Text('Giá tăng dần'),
                value: SortType.priceDesc,
                activeColor: TColors.primary,
                groupValue: selectedSortType,
                onChanged: (SortType? value) {
                  setState(() {
                    selectedSortType = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(TSizes.sm),
                    child: TextButton(
                      onPressed: selectedSortType == null
                          ? null // Disable button if no sort type is selected
                          : () {
                              // context.read<ListProductBloc>().add(SortProductsEvent(selectedSortType!));
                              Navigator.pop(context);
                            },
                      child: const Text('Apply'),
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
  );
}

void _showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FilterBottomSheet();
    },
  );
}

// Enum for sorting types
enum SortType { priceAsc, priceDesc }

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double? _minPrice;
  double? _maxPrice;
  List<int> _ratings = [];
  List<String> _brands = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // ... Price Range Selection ...
          TextField(
            decoration: InputDecoration(labelText: 'Min Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) => _minPrice = double.tryParse(value),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Max Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) => _maxPrice = double.tryParse(value),
          ),
          // ... Rating Selection ...
          Wrap(
            children: List.generate(5, (index) => index + 1).map((rating) {
              return ChoiceChip(
                label: Text('$rating'),
                selected: _ratings.contains(rating),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _ratings.add(rating);
                    } else {
                      _ratings.remove(rating);
                    }
                  });
                },
              );
            }).toList(),
          ),
          // ... Brand Selection (assuming you have a list of brands) ...
          Wrap(
            children: ['Brand A', 'Brand B', 'Brand C'].map((brand) {
              return ChoiceChip(
                label: Text(brand),
                selected: _brands.contains(brand),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _brands.add(brand);
                    } else {
                      _brands.remove(brand);
                    }
                  });
                },
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              // context.read<ListProductBloc>().add(FilterProductsEvent(
              //   minPrice: _minPrice,
              //   maxPrice: _maxPrice,
              //   ratings: _ratings,
              //   brands: _brands,
              // ));
              Navigator.pop(context);
            },
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
