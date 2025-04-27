import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_order_product_detail.dart';
import 'package:spa_mobile/features/product/presentation/bloc/order/order_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/init_dependencies.dart';

class OrderProductServiceDetailScreen extends StatefulWidget {
  const OrderProductServiceDetailScreen({super.key, required this.id});

  final int id;

  @override
  State<OrderProductServiceDetailScreen> createState() => _OrderProductServiceDetailScreenState();
}

class _OrderProductServiceDetailScreenState extends State<OrderProductServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc(createOrder: serviceLocator(), getOrderProductDetail: serviceLocator(), cancelOrdder: serviceLocator())
        ..add(GetOrderEvent(GetOrderProductDetailParams(id: widget.id))),
      child: Scaffold(
        appBar: TAppbar(
          showBackArrow: true,
        ),
        body: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoaded) {
                final order = state.order;

                final branch = order.orderDetails?.isNotEmpty ?? false ? order.orderDetails![0].branch : order.appointments![0].branch;
                return Padding(
                  padding: EdgeInsets.all(TSizes.sm),
                  child: Column(
                    children: [
                      const SizedBox(height: TSizes.md),
                      // TRoundedContainer(
                      //   padding: EdgeInsets.all(TSizes.sm),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Icon(
                      //         Iconsax.building,
                      //         color: TColors.primary,
                      //       ),
                      //       const SizedBox(
                      //         width: TSizes.sm,
                      //       ),
                      //       Expanded(
                      //           child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             branch?.branchName ?? "",
                      //             style: Theme.of(context).textTheme.bodyMedium,
                      //           ),
                      //           Text(
                      //             branch?.branchAddress ?? "",
                      //             style: Theme.of(context).textTheme.bodySmall,
                      //           ),
                      //         ],
                      //       )),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      if (order.orderDetails?.isNotEmpty ?? false)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int indexDetail) {
                            final orderDetail = order.orderDetails![indexDetail];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: THelperFunctions.screenWidth(context),
                                    child: const Divider(
                                      thickness: 0.2,
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TRoundedImage(
                                      imageUrl: orderDetail.product.images!.isNotEmpty ? orderDetail.product.images![0] : TImages.product1,
                                      applyImageRadius: true,
                                      isNetworkImage: orderDetail.product.images!.isNotEmpty,
                                      onPressed: () => {},
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1,
                                      ),
                                      width: THelperFunctions.screenWidth(context) * 0.28,
                                      height: THelperFunctions.screenWidth(context) * 0.28,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: TSizes.sm),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              orderDetail.product.productName,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(orderDetail.product.brand,
                                                maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "x${orderDetail.quantity}",
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  formatMoney(orderDetail.unitPrice.toString()),
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                )
                                              ],
                                            ),
                                            if (orderDetail.status.toLowerCase() == "shipping")
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(AppLocalizations.of(context)!.shipping,
                                                      style: Theme.of(context).textTheme.bodySmall),
                                                ],
                                              ),
                                            if (order.status.toLowerCase() == 'completed')
                                              TextButton(
                                                  onPressed: () {
                                                    goFeedbackProduct(
                                                        order.customer?.userId ?? 0, orderDetail.product.productId, order.orderId);
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(context)!.review,
                                                    style: Theme.of(context).textTheme.bodyLarge,
                                                  ))
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(
                            height: TSizes.spacebtwItems,
                          ),
                          itemCount: order.orderDetails?.length ?? 0,
                        ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      if (order.appointments?.isNotEmpty ?? false)
                        ListView.builder(
                          shrinkWrap: true, // Ensure the ListView takes only as much space as needed
                          physics: NeverScrollableScrollPhysics(), // Disable scrolling if already in a scrollable container
                          itemCount: order.appointments?.length,
                          itemBuilder: (context, index) {
                            final serviceState = order.appointments![index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(serviceState?.service?.name ?? "", style: Theme.of(context).textTheme.bodyMedium),
                                    if (order.status.toLowerCase() != 'cancelled')
                                      TRoundedIcon(
                                        icon: Icons.qr_code_scanner_rounded,
                                        color: TColors.primary,
                                        size: 30,
                                        onPressed: () {
                                          // _showModelQR(context, serviceState.appointmentId)
                                        },
                                      )
                                  ],
                                ),
                                const SizedBox(
                                  height: TSizes.sm,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${serviceState.service.duration} ${AppLocalizations.of(context)!.minutes}",
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.darkerGrey),
                                    ),
                                    TProductPriceText(price: serviceState.service.price.toString()),
                                  ],
                                ),
                                const SizedBox(
                                  height: TSizes.sm,
                                ),
                                // Text('${AppLocalizations.of(context)!.specialist}: ${serviceState.staff?.staffInfo?.fullName ?? ""}',
                                //     style: Theme.of(context).textTheme.bodyMedium),
                                if (serviceState.status.toLowerCase() == 'completed')
                                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    TextButton(
                                        onPressed: () {
                                          goFeedback(order.customer?.userId ?? 0, serviceState.serviceId, order.orderId);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.review,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        )),
                                  ]),
                                Divider(
                                  color: TColors.grey,
                                  thickness: 0.5,
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                );
              } else if (state is OrderLoading) {
                return const TLoader();
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
