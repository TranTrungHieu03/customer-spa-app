import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_product/list_product_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/categories.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_banner.dart';
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
      appBar: TAppbar(
        title: Text(
          'Product',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
        ),
        actions: const [
          TRoundedIcon(
            icon: Iconsax.shopping_bag,
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
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Luxury of Skincare",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Curated for You",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: TSizes.sm,
                ),
                const SizedBox(height: 40, child: TCategories()),
                const SizedBox(
                  height: TSizes.spacebtwItems,
                ),
                const TProductBanner(),
                const SizedBox(
                  height: TSizes.spacebtwSections,
                ),
                Text(
                  "Popular",
                  style: Theme.of(context).textTheme.headlineSmall,
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
      ),
    );
  }
}
