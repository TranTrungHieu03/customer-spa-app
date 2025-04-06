import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_order/list_order_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_horizontal_shimmer_card.dart';

class TStatusBarProduct extends StatefulWidget {
  const TStatusBarProduct({super.key, required this.status});

  final String status;

  @override
  State<TStatusBarProduct> createState() => _TStatusBarProductState();
}

class _TStatusBarProductState extends State<TStatusBarProduct> with AutomaticKeepAliveClientMixin {
  List<OrderProductModel> orders = [];
  PaginationModel pagination = PaginationModel.isEmty();
  bool isLoading = false;
  late ScrollController _scrollController;

  String lgCode = 'vi';

  Future<void> _loadLanguageAndInit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lgCode = prefs.getString('language_code') ?? "vi";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguageAndInit();
    context.read<ListOrderBloc>().add(GetListOrderEvent(page: 1, title: widget.status));
  }

  @override
  Widget build(BuildContext context) {
    // if (items.isEmpty) {
    //   return const Center(child: Text('Do not have any order here!!'));
    // }
    return BlocProvider.value(
      value: context.read<ListOrderBloc>(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.lg),
        child: Expanded(
          child: BlocBuilder<ListOrderBloc, ListOrderState>(
            builder: (context, state) {
              if (state is ListOrderLoaded) {
                if (widget.status == "pending") {
                  orders = state.pending;
                  pagination = state.paginationPending;
                  isLoading = state.isLoadingMorePending;
                } else if (widget.status == "completed") {
                  orders = state.completed;
                  pagination = state.paginationCompleted;
                  isLoading = state.isLoadingMoreCompleted;
                } else if (widget.status == "shipping") {
                  orders = state.shipping;
                  pagination = state.paginationShipping;
                  isLoading = state.isLoadingMoreShipping;
                } else {
                  orders = state.cancelled;
                  pagination = state.paginationCancelled;
                  isLoading = state.isLoadingMoreCancelled;
                }

                if (orders.isEmpty) {
                  return const Center(child: Text('Do not have any order here!'));
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification && _scrollController.position.extentAfter < 100) {
                      if (!isLoading && pagination.page < pagination.totalPage) {
                        context.read<ListOrderBloc>().add(GetListOrderEvent(page: pagination.page + 1, title: widget.status));
                      }
                    }
                    return false;
                  },
                  child: ListView.separated(
                      controller: _scrollController,
                      itemCount: orders.length + 1,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: TSizes.md,
                        );
                      },
                      itemBuilder: (context, index) {
                        if (index == orders.length) {
                          return isLoading ? const SizedBox() : const SizedBox.shrink();
                        } else {
                          final order = orders[index];
                          // var totalTime = order.appointments.fold(0, (sum, x) => sum + int.parse(x.service?.duration ?? "0"));
                          // if (order.appointments.length > 1) {
                          //   totalTime = totalTime + (order.appointments.length - 1) * 5;
                          // }

                          // return ListView.separated(
                          //   shrinkWrap: true,
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   itemBuilder: (BuildContext context, int index) {
                          //     return TRoundedContainer(
                          //       padding: const EdgeInsets.all(TSizes.sm),
                          //       child: Column(
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               ConstrainedBox(
                          //                 constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.6),
                          //                 child: Row(
                          //                   children: [
                          //                     Icon(Iconsax.shop),
                          //                     const SizedBox(
                          //                       width: TSizes.spacebtwItems / 2,
                          //                     ),
                          //                     Text(
                          //                       "Innisfree",
                          //                       style: Theme.of(context).textTheme.titleLarge,
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //               Text(
                          //                 "Đang xử lý",
                          //                 style: Theme.of(context).textTheme.bodyLarge,
                          //               )
                          //             ],
                          //           ),
                          //           SizedBox(
                          //               width: THelperFunctions.screenWidth(context),
                          //               child: const Divider(
                          //                 thickness: 0.2,
                          //               )),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             crossAxisAlignment: CrossAxisAlignment.center,
                          //             children: [
                          //               TRoundedImage(
                          //                 // imageUrl: TImages.product3,
                          //                 applyImageRadius: true,
                          //                 isNetworkImage: true,
                          //                 onPressed: () => {},
                          //                 border: Border.all(
                          //                   color: Colors.grey.withOpacity(0.5),
                          //                   width: 1,
                          //                 ),
                          //                 width: THelperFunctions.screenWidth(context) * 0.28,
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.only(left: TSizes.sm),
                          //                 child: ConstrainedBox(
                          //                   constraints: BoxConstraints(
                          //                     maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                          //                   ),
                          //                   child: Column(
                          //                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                     children: [
                          //                       TProductTitleText(
                          //                         title: TProductDetail.name,
                          //                         maxLines: 2,
                          //                         smallSize: true,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                         children: [
                          //                           TProductPriceText(
                          //                             price: TProductDetail.price,
                          //                             currencySign: '₫',
                          //                           ),
                          //                           Text(
                          //                             "x1",
                          //                             style: Theme.of(context).textTheme.bodySmall,
                          //                           )
                          //                         ],
                          //                       )
                          //                     ],
                          //                   ),
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     );
                          //   },
                          //   separatorBuilder: (BuildContext context, int index) => const SizedBox(
                          //     height: TSizes.spacebtwItems,
                          //   ),
                          //   itemCount: 5,
                          // );
                        }
                        return const SizedBox();
                      }),
                );
              } else if (state is ListOrderLoading) {
                return TGridLayout(
                    itemCount: 4,
                    mainAxisExtent: 150,
                    itemBuilder: (_, __) {
                      return const TServiceHorizontalCardShimmer();
                    });
              }
              return const Center(child: Text('Do not have any order here!'));
            },
          ),
        ),
      ),
    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
