import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_order/list_order_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
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
    _scrollController = ScrollController();
    context.read<ListOrderBloc>().add(GetListOrderEvent(page: 1, title: widget.status));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ListOrderBloc>(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.lg),
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
                return Center(child: Text(AppLocalizations.of(context)!.no_order));
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
                  child: Column(
                    children: [
                      Expanded(
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
                                if (order.orderType.toLowerCase() == "product") {
                                  return GestureDetector(
                                    onTap: () => goOrderProductDetail(order.orderId),
                                    child: TRoundedContainer(
                                      padding: EdgeInsets.all(TSizes.sm),
                                      child: Column(
                                        children: [
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context, int indexDetail) {
                                              final orderDetail = order.orderDetails![indexDetail];
                                              if (indexDetail == 0) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.9),
                                                          child: Row(
                                                            children: [
                                                              const Icon(Iconsax.shop),
                                                              const SizedBox(
                                                                width: TSizes.spacebtwItems / 2,
                                                              ),
                                                              Text(
                                                                orderDetail.branch?.branchName ?? "",
                                                                style: Theme.of(context).textTheme.bodyLarge,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   "Đang xử lý",
                                                        //   style: Theme.of(context).textTheme.bodyLarge,
                                                        // )
                                                      ],
                                                    ),
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
                                                          imageUrl: orderDetail.product.images!.isNotEmpty
                                                              ? orderDetail.product.images![0]
                                                              : TImages.product1,
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
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: Theme.of(context).textTheme.bodySmall),
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
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                final quantityOfHide = order.orderDetails!.fold(0, (x, y) => x + y.quantity) -
                                                    (order.orderDetails?[0].quantity ?? 0);
                                                return indexDetail == 1 && (order.orderDetails?.length ?? 0) > 1
                                                    ? ExpansionTile(
                                                        title: Text(AppLocalizations.of(context)!.view_more),
                                                        tilePadding: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.md),
                                                        childrenPadding: EdgeInsets.zero,
                                                        collapsedBackgroundColor: Colors.transparent,
                                                        backgroundColor: Colors.transparent,
                                                        subtitle: Text(
                                                          "$quantityOfHide ${AppLocalizations.of(context)!.other_products}",
                                                          style: Theme.of(context).textTheme.bodySmall,
                                                        ),
                                                        children: order.orderDetails!
                                                            .asMap()
                                                            .entries
                                                            .where((entry) => entry.key != 0) // chỉ lấy từ sản phẩm thứ 2 trở đi
                                                            .map((entry) {
                                                          final orderDetail = entry.value;
                                                          return Column(
                                                            children: [
                                                              const Divider(thickness: 0.2),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  TRoundedImage(
                                                                    imageUrl: orderDetail.product.images!.isNotEmpty
                                                                        ? orderDetail.product.images![0]
                                                                        : TImages.product1,
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
                                                                        children: [
                                                                          Text(
                                                                            orderDetail.product.productName,
                                                                            style: Theme.of(context).textTheme.bodyMedium,
                                                                            maxLines: 2,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                          Text(
                                                                            orderDetail.product.brand,
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: Theme.of(context).textTheme.bodySmall,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                            children: [
                                                                              Text("x${orderDetail.quantity}",
                                                                                  style: Theme.of(context).textTheme.bodySmall),
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
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: TSizes.sm),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      )
                                                    : const SizedBox.shrink();
                                              }
                                            },
                                            separatorBuilder: (BuildContext context, int index) => const SizedBox(
                                              height: TSizes.spacebtwItems,
                                            ),
                                            itemCount: order.orderDetails?.length ?? order.appointments?.length ?? 1,
                                          ),
                                          const SizedBox(
                                            height: TSizes.sm,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${AppLocalizations.of(context)!.total_payment}: ",
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                              TProductPriceText(
                                                  price: (order.totalAmount - (order.voucher?.discountAmount ?? 0)).toString())
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (order.orderType.toLowerCase() == "appointment") {
                                  var totalTime = order.appointments!.fold(0, (sum, x) => sum + int.parse(x.service?.duration ?? "0"));
                                  if (order.appointments!.length > 1) {
                                    totalTime = totalTime + (order.appointments!.length - 1) * 5;
                                  }
                                  return TRoundedContainer(
                                    padding: const EdgeInsets.all(TSizes.sm),
                                    child: GestureDetector(
                                      onTap: () => goBookingDetail(orders[index].orderId, isBack: true),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.9),
                                                child: Row(
                                                  children: [
                                                    const Icon(Iconsax.shop),
                                                    const SizedBox(
                                                      width: TSizes.spacebtwItems / 2,
                                                    ),
                                                    Text(
                                                      order.appointments![0].branch?.branchName ?? "",
                                                      style: Theme.of(context).textTheme.bodyLarge,
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // Text(
                                              //   "Đang xử lý",
                                              //   style: Theme.of(context).textTheme.bodyLarge,
                                              // )
                                            ],
                                          ),
                                          SizedBox(
                                              width: THelperFunctions.screenWidth(context),
                                              child: const Divider(
                                                thickness: 0.2,
                                              )),
                                          Row(
                                            children: [
                                              Icon(
                                                Iconsax.calendar_1,
                                              ),
                                              const SizedBox(
                                                width: TSizes.sm,
                                              ),
                                              Text(
                                                DateFormat('EEEE, dd MMMM yyyy', lgCode)
                                                    .format(order.appointments!
                                                        .reduce((a, b) => a.appointmentsTime.isBefore(b.appointmentsTime) ? a : b)
                                                        .appointmentsTime)
                                                    .toString(),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: TSizes.sm,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Iconsax.clock,
                                              ),
                                              const SizedBox(
                                                width: TSizes.sm,
                                              ),
                                              Text(DateFormat('HH:mm', lgCode)
                                                      .format(order.appointments!
                                                          .reduce((a, b) => a.appointmentsTime.isBefore(b.appointmentsTime) ? a : b)
                                                          .appointmentsTime)
                                                      .toString()
                                                  // "${DateFormat('HH:mm', lgCode).format(order.appointments![0].appointmentsTime.add(Duration(minutes: totalTime))).toString()}",
                                                  )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: TSizes.sm,
                                          ),
                                          TGridLayout(
                                              itemCount: orders[index].appointments!.length,
                                              mainAxisExtent: 50,
                                              crossAxisCount: 1,
                                              itemBuilder: (context, indexItem) {
                                                final appointment = order.appointments![indexItem];

                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: TSizes.sm),
                                                      child: ConstrainedBox(
                                                        constraints: BoxConstraints(
                                                          maxWidth: THelperFunctions.screenWidth(context) * 0.8,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: TProductTitleText(
                                                                    title: appointment.service.name,
                                                                    smallSize: true,
                                                                    maxLines: 2,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  AppLocalizations.of(context)!.duration + ": ",
                                                                  style: Theme.of(context).textTheme.labelLarge,
                                                                ),
                                                                Text(appointment.service.duration),
                                                                Text(AppLocalizations.of(context)!.minutes)
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              Text(AppLocalizations.of(context)!.total_payment),
                                              const SizedBox(
                                                width: TSizes.sm,
                                              ),
                                              TProductPriceText(
                                                  price: (order.totalAmount - (order.voucher?.discountAmount ?? 0)).toString())
                                            ],
                                          ),
                                          const SizedBox(
                                            height: TSizes.sm,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (order.orderType.toLowerCase() == 'routine') {
                                  // final routine = orders[index];
                                  return
                                      // onTap: () => goTrackingRoutineDetail(order.routine!.skincareRoutineId, order.customerId),
                                      TRoundedContainer(
                                    padding: EdgeInsets.all(TSizes.sm),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.9),
                                              child: Row(
                                                children: [
                                                  const Icon(Iconsax.shop),
                                                  const SizedBox(
                                                    width: TSizes.spacebtwItems / 2,
                                                  ),
                                                  Text(
                                                    order.orderDetails![0].branch?.branchName ?? "",
                                                    style: Theme.of(context).textTheme.bodyLarge,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                ],
                                              ),
                                            ),
                                            // Text(
                                            //   "Đang xử lý",
                                            //   style: Theme.of(context).textTheme.bodyLarge,
                                            // )
                                          ],
                                        ),
                                        SizedBox(
                                            width: THelperFunctions.screenWidth(context),
                                            child: const Divider(
                                              thickness: 0.2,
                                            )),
                                        ListTile(
                                          title: Row(
                                            children: [
                                              Text("Goi lieu trinh: ", style: Theme.of(context).textTheme.bodyLarge),
                                              Text(order.routine!.name, style: Theme.of(context).textTheme.bodyLarge),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(order.routine!.description),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  Text(AppLocalizations.of(context)!.total_payment),
                                                  const SizedBox(
                                                    width: TSizes.sm,
                                                  ),
                                                  TProductPriceText(
                                                      price: (order.totalAmount - (order.voucher?.discountAmount ?? 0)).toString())
                                                ],
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            goOrderRoutineDetail(order.orderId);
                                          },
                                        ),
                                        const SizedBox(
                                          height: TSizes.md,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () => goOrderMixDetail(order.orderId),
                                    child: TRoundedContainer(
                                      padding: const EdgeInsets.all(TSizes.sm),
                                      child: Column(
                                        children: [
                                          if (orders[index].orderDetails?.isNotEmpty ?? false)
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (BuildContext context, int indexDetail) {
                                                final orderDetail = order.orderDetails![indexDetail];
                                                if (indexDetail == 0) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.9),
                                                            child: Row(
                                                              children: [
                                                                const Icon(Iconsax.shop),
                                                                const SizedBox(
                                                                  width: TSizes.spacebtwItems / 2,
                                                                ),
                                                                Text(
                                                                  orderDetail.branch?.branchName ?? "",
                                                                  style: Theme.of(context).textTheme.bodyLarge,
                                                                  overflow: TextOverflow.ellipsis,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          // Text(
                                                          //   "Đang xử lý",
                                                          //   style: Theme.of(context).textTheme.bodyLarge,
                                                          // )
                                                        ],
                                                      ),
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
                                                            imageUrl: orderDetail.product.images!.isNotEmpty
                                                                ? orderDetail.product.images![0]
                                                                : TImages.product1,
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
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: Theme.of(context).textTheme.bodySmall),
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
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  final quantityOfHide = order.orderDetails!.fold(0, (x, y) => x + y.quantity) -
                                                      (order.orderDetails?[0].quantity ?? 0);
                                                  return indexDetail == 1 && (order.orderDetails?.length ?? 0) > 1
                                                      ? ExpansionTile(
                                                          title: Text(AppLocalizations.of(context)!.view_more),
                                                          tilePadding:
                                                              const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.md),
                                                          childrenPadding: EdgeInsets.zero,
                                                          collapsedBackgroundColor: Colors.transparent,
                                                          backgroundColor: Colors.transparent,
                                                          subtitle: Text(
                                                            "$quantityOfHide ${AppLocalizations.of(context)!.other_products}",
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                          children: order.orderDetails!
                                                              .asMap()
                                                              .entries
                                                              .where((entry) => entry.key != 0) // chỉ lấy từ sản phẩm thứ 2 trở đi
                                                              .map((entry) {
                                                            final orderDetail = entry.value;
                                                            return Column(
                                                              children: [
                                                                const Divider(thickness: 0.2),
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    TRoundedImage(
                                                                      imageUrl: orderDetail.product.images!.isNotEmpty
                                                                          ? orderDetail.product.images![0]
                                                                          : TImages.product1,
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
                                                                          children: [
                                                                            Text(
                                                                              orderDetail.product.productName,
                                                                              style: Theme.of(context).textTheme.bodyMedium,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            Text(
                                                                              orderDetail.product.brand,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: Theme.of(context).textTheme.bodySmall,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                Text("x${orderDetail.quantity}",
                                                                                    style: Theme.of(context).textTheme.bodySmall),
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
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: TSizes.sm),
                                                              ],
                                                            );
                                                          }).toList(),
                                                        )
                                                      : const SizedBox.shrink();
                                                }
                                              },
                                              separatorBuilder: (BuildContext context, int index) => const SizedBox(
                                                height: TSizes.sm,
                                              ),
                                              itemCount: order.orderDetails?.length ?? order.appointments?.length ?? 1,
                                            ),
                                          if (orders[index].appointments?.isNotEmpty ?? false)
                                            TGridLayout(
                                                itemCount: orders[index].appointments!.length,
                                                mainAxisExtent: 50,
                                                crossAxisCount: 1,
                                                itemBuilder: (context, indexItem) {
                                                  final appointment = order.appointments![indexItem];

                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: TSizes.sm),
                                                        child: ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                            maxWidth: THelperFunctions.screenWidth(context) * 0.8,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: TProductTitleText(
                                                                      title: appointment.service.name,
                                                                      smallSize: true,
                                                                      maxLines: 2,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    AppLocalizations.of(context)!.duration + ": ",
                                                                    style: Theme.of(context).textTheme.labelLarge,
                                                                  ),
                                                                  Text(appointment.service.duration),
                                                                  Text(AppLocalizations.of(context)!.minutes)
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          const SizedBox(
                                            height: TSizes.sm,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${AppLocalizations.of(context)!.total_payment}: ",
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                              TProductPriceText(
                                                  price: (order.totalAmount - (order.voucher?.discountAmount ?? 0)).toString())
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                            }),
                      ),
                    ],
                  ));
            } else if (state is ListOrderLoading) {
              return TGridLayout(
                  itemCount: 4,
                  mainAxisExtent: 150,
                  itemBuilder: (_, __) {
                    return const TServiceHorizontalCardShimmer();
                  });
            }
            return Center(child: Text(AppLocalizations.of(context)!.no_order));
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
