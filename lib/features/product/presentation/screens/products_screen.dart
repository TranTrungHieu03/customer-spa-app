import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_product/list_product_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_card_shimmer.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_vertical_card.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
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
                                "Sap xep",
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
                                "Bo loc",
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
                title: const Text('Price: Low to High'),
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
                title: const Text('Price: High to Low'),
                value: SortType.priceDesc,
                activeColor: TColors.primary,
                groupValue: selectedSortType,
                onChanged: (SortType? value) {
                  setState(() {
                    selectedSortType = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: selectedSortType == null
                      ? null // Disable button if no sort type is selected
                      : () {
                          // context.read<ListProductBloc>().add(SortProductsEvent(selectedSortType!));
                          Navigator.pop(context);
                        },
                  child: const Text('Apply'),
                ),
              ),
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
