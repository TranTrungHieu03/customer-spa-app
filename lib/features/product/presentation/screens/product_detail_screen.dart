import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/banners.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/list_feedback_product.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_product_feedback/list_product_feedback_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:spa_mobile/features/product/presentation/screens/product_detail_shimmer.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/init_dependencies.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId, required this.controller});

  final PurchasingDataController controller;
  final int productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late CarouselSliderController _carouselController;
  UserModel user = UserModel.empty();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    context.read<ProductBloc>().add(GetProductDetailEvent(widget.productId));
    _loadData();
  }

  void _loadData() async {
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (jsonDecode(userJson) != null) {
      user = UserModel.fromJson(jsonDecode(userJson));
    } else {
      goLoginNotBack();
    }

    if (user.district == 0 || user.wardCode == 0) {
      TSnackBar.infoSnackBar(context, message: AppLocalizations.of(context)!.update_address_to_purchase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductFailure) {
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
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoaded) {
              final product = state.product;
              return BlocProvider(
                create: (context) => ListProductFeedbackBloc(getListProductFeedback: serviceLocator())
                  ..add(GetListFeedbackProductEvent(ListProductFeedbackParams(product.productId))),
                child: Scaffold(
                  appBar: TAppbar(
                    showBackArrow: true,
                    actions: [
                      TRoundedIcon(
                        icon: Iconsax.shopping_cart,
                        size: 30,
                        onPressed: () => goCart(widget.controller),
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
                                    product.category?.name ?? "",
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
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
                        ),
                        //Comment
                        BlocBuilder<ListProductFeedbackBloc, ListProductFeedbackState>(
                          builder: (context, state) {
                            if (state is ListProductFeedbackLoaded) {
                              return Padding(
                                padding: const EdgeInsets.all(TSizes.sm),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.feedback,
                                          style: Theme.of(context)!.textTheme.titleLarge,
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
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(
                                                  width: TSizes.sm,
                                                ),
                                                Text(state.average.toString() ?? '5.0')
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: TSizes.sm,
                                    ),
                                    SizedBox(
                                      height: 400,
                                      child: ListView.separated(
                                          itemBuilder: (context, index) {
                                            final comment = state.feedbacks[index];
                                            if (state.feedbacks.isEmpty) {
                                              return Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text(AppLocalizations.of(context)!.no_feedback_for_product));
                                            }
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(comment.customer?.fullName ?? "User"),
                                                    RatingBar.builder(
                                                      initialRating: comment.rating?.toDouble() ?? 5,
                                                      minRating: 1,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: false,
                                                      itemCount: 5,
                                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder: (context, _) => const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      itemSize: 21,
                                                      onRatingUpdate: (_) {},
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: TSizes.sm,
                                                ),
                                                TRoundedContainer(
                                                  width: THelperFunctions.screenWidth(context),
                                                  padding: const EdgeInsets.all(TSizes.sm),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [Text(comment.comment ?? "")],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: TSizes.sm / 2,
                                                ),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    DateFormat("HH:mm, dd/MM/yyyy").format(
                                                        DateTime.parse(comment.createdAt).toUtc().toLocal().add(Duration(hours: 7))),
                                                    style: Theme.of(context)!.textTheme.labelMedium,
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: TSizes.md,
                                            );
                                          },
                                          itemCount: state.feedbacks.length),
                                    ),
                                  ],
                                ),
                              );
                            } else if (state is ListProductFeedbackLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: TColors.primary,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
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
                            onTap: context.read<CartBloc>().state is CartLoading
                                ? null
                                : () {
                                    context.read<CartBloc>().add(AddProductToCartEvent(
                                        params: AddProductCartParams(
                                            productId: product.productBranchId, quantity: 1, operation: 0, userId: 0)));
                                  },
                            child: Container(
                              height: 55,
                              padding: const EdgeInsets.all(TSizes.sm / 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Iconsax.shopping_cart4,
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
                            widget.controller.updateBranch(product.branch ?? BranchModel.empty());
                            widget.controller
                                .updateProducts([ProductQuantity(quantity: 1, productBranchId: product.productBranchId, product: product)]);
                            widget.controller.updateTotalPrice(product.price);

                            if (user.wardCode == 0) {
                              goProfile();
                              return;
                            }
                            widget.controller.updateUser(user);
                            goCheckout(widget.controller);
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
      ),
    );
  }
}
