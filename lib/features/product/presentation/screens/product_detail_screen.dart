import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/banners.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/product_detail.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:spa_mobile/features/product/presentation/screens/product_detail_shimmer.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late CarouselSliderController _carouselController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    context.read<ProductBloc>().add(GetProductDetailEvent(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductFailure) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            final product = state.product;
            return Scaffold(
              appBar: TAppbar(
                showBackArrow: true,
                actions: [
                  TRoundedIcon(
                    icon: Iconsax.shopping_bag,
                    size: 30,
                    onPressed: () => goCart(true),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                                pageSnapping: true,
                                viewportFraction: 1.0,
                                enableInfiniteScroll: false,
                                scrollPhysics: const BouncingScrollPhysics(),
                                onPageChanged: (index, _) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                aspectRatio: 3 / 2),
                            items: product.images!
                                .map((banner) => TRoundedImage(
                                      imageUrl: banner,
                                      applyImageRadius: false,
                                      isNetworkImage: true,
                                      fit: BoxFit.cover,
                                      onPressed: () => {},
                                      width: THelperFunctions.screenWidth(context),
                                    ))
                                .toList()),
                        if (_currentIndex > 0)
                          Positioned(
                            left: 0,
                            child: TRoundedIcon(
                              icon: Iconsax.arrow_left_2,
                              onPressed: () {
                                _carouselController.previousPage();
                              },
                            ),
                          ),
                        if (_currentIndex < banners.length - 1)
                          Positioned(
                            right: 0,
                            child: TRoundedIcon(
                              icon: Iconsax.arrow_right_34,
                              onPressed: () {
                                _carouselController.nextPage();
                              },
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(TSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.category.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              TRoundedContainer(
                                radius: 20,
                                child: Padding(
                                  padding: const EdgeInsets.all(TSizes.sm),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Iconsax.star,
                                        color: Colors.yellow,
                                      ),
                                      const SizedBox(
                                        width: TSizes.sm,
                                      ),
                                      Text(TProductDetail.rate)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          TProductTitleText(
                            title: product.productName,
                            maxLines: 4,
                          ),
                          const SizedBox(
                            height: TSizes.spacebtwItems / 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TProductPriceText(price: product.price.toString()),
                              Text(
                                product.dimension,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: TSizes.spacebtwItems / 2,
                          ),
                          Text(product.productDescription),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.all(TSizes.sm / 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.bag_tick,
                                color: TColors.primary,
                              ),
                              Text(
                                AppLocalizations.of(context)!.addToCart,
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        goCheckout();
                      },
                      child: Container(
                        height: 55,
                        decoration: const BoxDecoration(
                          color: TColors.primary,
                        ),
                        padding: const EdgeInsets.all(TSizes.sm / 2),
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)!.buyNow,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductLoading) {
            return const TProductDetailShimmer();
          } else if (state is ProductFailure) {
            return const ErrorScreen();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
