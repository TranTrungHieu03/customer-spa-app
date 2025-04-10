import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/model/request_payos_model.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/payment_method.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/enum.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/product/domain/usecases/cancel_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_order_product_detail.dart';
import 'package:spa_mobile/features/product/presentation/bloc/order/order_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_deposit.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';
import 'package:spa_mobile/features/service/presentation/bloc/payment/payment_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  PaymentOption _selectedPaymentOption = PaymentOption.full;

  void handlePaymentOptionChange(PaymentOption option) {
    setState(() {
      _selectedPaymentOption = option;
    });
  }

  double totalAmount = 0;
  bool isPaid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: Text('Đơn hàng chi tiet'),
        showBackArrow: true,
        actions: [
          TRoundedIcon(
            icon: Iconsax.home_2,
            onPressed: () => goHome(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: BlocProvider(
            create: (context) =>
                OrderBloc(getOrderProductDetail: serviceLocator(), createOrder: serviceLocator(), cancelOrdder: serviceLocator())
                  ..add(GetOrderEvent(GetOrderProductDetailParams(id: widget.orderId))),
            child: BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderLoaded) {
                  setState(() {
                    isPaid = state.order.statusPayment == "Paid" || state.order.statusPayment == "PaidDeposit";
                  });
                }
              },
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrderLoaded) {
                    final order = state.order;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (order.statusPayment != 'Cash')
                          Text(
                              'Trạng thái thanh toán: ${order.statusPayment == 'PaidDeposit' ? 'Đã thanh toán ${(order.totalAmount - (order.voucher?.discountAmount ?? 0)) * 0.3}' : order.statusPayment == 'Paid' ? 'Đã thanh toán đủ' : 'Chưa thanh toán'}'),
                        const SizedBox(
                          height: TSizes.xs,
                        ),
                        if (order.status != 'Cancelled' && order.status != 'Completed')
                          TRoundedContainer(
                            backgroundColor: Colors.teal.shade100,
                            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
                            radius: 100,
                            child: Text(
                              'Dự kiến giao hàng vào: ${DateFormat('EEEE, dd MMMM yyyy', "vi").format(DateTime.parse(order.shipment?.expectedDeliveryTime ?? ""))}',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        const SizedBox(
                          height: TSizes.xs,
                        ),
                        Text(
                          'Thông tin người nhận',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: TSizes.xs,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.md * 2 / 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 0.2,
                                spreadRadius: 0.5,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: THelperFunctions.screenWidth(context) * 0.5,
                                        ),
                                        child: Text(
                                          state.order.shipment?.name ?? "",
                                          style: Theme.of(context).textTheme.bodyLarge,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      SizedBox(
                                        width: THelperFunctions.screenWidth(context) * 0.3,
                                        child: Text(
                                          state.order.shipment?.phone ?? "",
                                          style: Theme.of(context).textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: THelperFunctions.screenWidth(context) * 0.8,
                                    child: Text(
                                      state.order.shipment?.address ?? "",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.md,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int indexDetail) {
                            final orderDetail = order.orderDetails[indexDetail];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (indexDetail == 0)
                                      ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.8),
                                        child: Row(
                                          children: [
                                            const Icon(Iconsax.shop),
                                            const SizedBox(
                                              width: TSizes.spacebtwItems / 2,
                                            ),
                                            Text(
                                              orderDetail.product.branch?.branchName ?? "",
                                              style: Theme.of(context).textTheme.titleLarge,
                                            )
                                          ],
                                        ),
                                      ),
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
                                            if (order.status.toLowerCase() == 'completed')
                                              TextButton(
                                                  onPressed: () {
                                                    goFeedbackProduct(order.customer?.userId ?? 0, orderDetail.productId, widget.orderId);
                                                  },
                                                  child: Text(
                                                    'Đánh giá',
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
                          itemCount: order.orderDetails.length,
                        ),
                        const SizedBox(
                          height: TSizes.md,
                        ),
                        const Divider(
                          thickness: 0.2,
                        ),
                        if ((order.statusPayment == "Pending" || order.statusPayment == "PendingDeposit") &&
                            order.status.toLowerCase() != "cancelled")
                          Text(
                            "Payment Methods",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        const SizedBox(
                          height: TSizes.sm,
                        ),
                        if ((order.statusPayment == "Pending" || order.statusPayment == "PendingDeposit") &&
                            order.status.toLowerCase() != "cancelled")
                          TPaymentSelection(
                            total: (order.totalAmount - (order.voucher?.discountAmount ?? 0)),
                            onOptionChanged: handlePaymentOptionChange,
                            selectedOption: _selectedPaymentOption,
                          ),
                        Divider(
                          color: TColors.darkGrey,
                          thickness: 0.5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.payment_details, style: Theme.of(context).textTheme.titleLarge),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.total_order_amount, style: Theme.of(context).textTheme.bodyMedium),
                                TProductPriceText(
                                  price: (order.totalAmount - (order.shipment?.cost ?? 0)).toString(),
                                  isLarge: false,
                                )
                              ],
                            ),
                            if (order.shipment?.cost != 0.0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.shipping_fee, style: Theme.of(context).textTheme.bodyMedium),
                                  TProductPriceText(
                                    price: order.shipment?.cost.toString() ?? "0",
                                    isLarge: false,
                                  )
                                ],
                              ),
                            if (order.voucher != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Phí giảm giá', style: Theme.of(context).textTheme.bodyMedium),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('- '),
                                      TProductPriceText(
                                        price: (order.voucher?.discountAmount ?? 0).toString(),
                                        isLarge: false,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tổng tiền",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                TProductPriceText(
                                  price: (order.totalAmount).toString(),
                                  isLarge: true,
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: TSizes.md,
                        ),
                        const Divider(
                          thickness: 0.2,
                        ),
                        const SizedBox(
                          height: TSizes.md,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Phương thức thanh toán",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  order.paymentMethod.toLowerCase() == 'cash' ? 'Thanh toán khi nhận hàng' : 'Chuyển khoản',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: TColors.darkerGrey),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ngày đặt hàng',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                                DateFormat('HH:mm, dd/MM/yyyy').format(
                                  DateTime.parse(order.shipment?.orderTime ?? "").toUtc().toLocal().add(Duration(hours: 7)),
                                ),
                                style: Theme.of(context).textTheme.bodySmall)
                          ],
                        ),
                        if (order.status == 'Completed')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ngày nhận hàng',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                  DateFormat('HH:mm, dd/MM/yyyy').format(
                                    DateTime.parse(order.updatedDate ?? "").toUtc().toLocal().add(Duration(hours: 7)),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall)
                            ],
                          ),
                        if (order.status == 'Cancelled')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ngày huỷ đơn',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                  DateFormat('HH:mm, dd/MM/yyyy').format(
                                    DateTime.parse(order.updatedDate).toUtc().toLocal().add(Duration(hours: 7)),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall)
                            ],
                          ),
                        if (order.status == 'Cancelled')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lý do: ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.7),
                                  child: Text(
                                    order.note ?? "",
                                    style: Theme.of(context).textTheme.bodySmall,
                                    maxLines: 3,
                                  ))
                            ],
                          ),
                        const SizedBox(
                          height: TSizes.md,
                        ),
                        if (order.status == "Pending")
                          TextButton(
                              onPressed: () {
                                _showModalCancel(context, order.orderId);
                              },
                              child: Text(
                                'Hủy đơn hàng',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: TColors.darkGrey),
                              )),
                      ],
                    );
                  } else if (state is OrderError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          const Spacer(),
          if (!isPaid)
            ElevatedButton(
                onPressed: () {
                  if (_selectedPaymentOption == PaymentOption.full) {
                    context.read<PaymentBloc>().add(PayFullEvent(PayFullParams(
                        totalAmount: totalAmount.toString(),
                        orderId: widget.orderId,
                        request: RequestPayOsModel(returnUrl: "/success", cancelUrl: "/cancel"))));
                  } else {
                    context.read<PaymentBloc>().add(PayDepositEvent(PayDepositParams(
                        totalAmount: totalAmount.toString(),
                        orderId: widget.orderId,
                        percent: 30,
                        request: RequestPayOsModel(returnUrl: "/success", cancelUrl: "/cancel"))));
                  }
                  goRedirectPayment(
                    widget.orderId,
                  );
                },
                child: const Text("Pay Now")),
          const SizedBox(
            width: TSizes.md,
          )
        ],
      ),
    );
  }

  void _showModalCancel(BuildContext context, int orderId) {
    final TextEditingController reasonController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: TSizes.md,
            right: TSizes.md,
            top: TSizes.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lý do hủy',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                controller: reasonController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Enter your massage",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: BlocListener<OrderBloc, OrderState>(
                      listener: (context, state) {
                        if (state is OrderCancelSuccess) {
                          TSnackBar.infoSnackBar(context, message: state.message);
                          goOrderProductDetail(state.orderId);
                        }
                        if (state is OrderError) {
                          TSnackBar.errorSnackBar(context, message: state.message);
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<OrderBloc>()
                              .add(CancelOrderEvent(CancelOrderParams(orderId: orderId, reason: reasonController.text.trim())));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.submit,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontSize: TSizes.md,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
