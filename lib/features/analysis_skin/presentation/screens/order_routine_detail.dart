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
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_order_routine.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/order_routine/order_routine_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_deposit.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';
import 'package:spa_mobile/features/service/presentation/bloc/payment/payment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/qr_checkin.dart';
import 'package:spa_mobile/init_dependencies.dart';

class OrderRoutineDetail extends StatefulWidget {
  const OrderRoutineDetail({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderRoutineDetail> createState() => _OrderRoutineDetailState();
}

class _OrderRoutineDetailState extends State<OrderRoutineDetail> {
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
        title: Text(AppLocalizations.of(context)!.order_details),
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
                OrderRoutineBloc(getOrderRoutine: serviceLocator())..add(GetOrderRoutineDetailEvent(GetOrderRoutineParams(widget.orderId))),
            child: BlocListener<OrderRoutineBloc, OrderRoutineState>(
              listener: (context, state) {
                if (state is OrderRoutineLoaded) {
                  setState(() {
                    isPaid = state.order.statusPayment == "Paid" || state.order.paymentMethod?.toLowerCase() == 'cash';
                  });
                }
                if (state is OrderRoutineError) {
                  TSnackBar.errorSnackBar(context, message: state.message);
                }
              },
              child: BlocBuilder<OrderRoutineBloc, OrderRoutineState>(
                builder: (context, state) {
                  if (state is OrderRoutineLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrderRoutineLoaded) {
                    final order = state.order;
                    final routine = order.routine;
                    final branch = order.appointments[0].branch;
                    // final List<String> steps = routine.steps.split(", ");
                    totalAmount = order.totalAmount - (order.voucher?.discountAmount ?? 0);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (order.statusPayment != 'Cash')
                          Text(
                            '${AppLocalizations.of(context)!.payment_status}: ${order.statusPayment == 'PaidDeposit' ? '${AppLocalizations.of(context)!.paid} ${formatMoney(((order.totalAmount - (order.voucher?.discountAmount ?? 0)) * 0.3).toString())}' : order.statusPayment == 'Paid' ? AppLocalizations.of(context)!.fully_paid : AppLocalizations.of(context)!.unpaid}',
                            style: Theme.of(context)!.textTheme.bodyLarge,
                          ),
                        const SizedBox(
                          height: TSizes.xs,
                        ),
                        TRoundedContainer(
                          padding: EdgeInsets.all(TSizes.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.building,
                                color: TColors.primary,
                              ),
                              const SizedBox(
                                width: TSizes.sm,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    branch?.branchName ?? "",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    branch?.branchAddress ?? "",
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                        Text(routine.name, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                        Text(routine.description, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: TSizes.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.treatment_steps,
                                overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                            GestureDetector(
                              onTap: () => goTrackingRoutineDetail(
                                  routine.skincareRoutineId, order.customerId, order.orderId, order.userRoutineId ?? 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.view_more, style: Theme.of(context).textTheme.bodySmall),
                                  const Icon(
                                    Iconsax.arrow_right_3,
                                    size: 17,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: TSizes.sm),
                        Text(
                          AppLocalizations.of(context)!.products,
                          style: Theme.of(context)!.textTheme.bodyLarge,
                        ),
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
                                        imageUrl:
                                            orderDetail.product.images!.isNotEmpty ? orderDetail.product.images![0] : TImages.product1,
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
                        Text(
                          AppLocalizations.of(context)!.services,
                          style: Theme.of(context)!.textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: TSizes.md,
                        ),
                        if (order.appointments?.isNotEmpty ?? false)
                          ListView.builder(
                            shrinkWrap: true, // Ensure the ListView takes only as much space as needed
                            physics: const NeverScrollableScrollPhysics(), // Disable scrolling if already in a scrollable container
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
                                            _showModelQR(context, serviceState.appointmentId);
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
                                  (serviceState.staff?.staffId != 3)
                                      ? Text(
                                          '${AppLocalizations.of(context)!.specialist}: ${serviceState.staff?.staffInfo?.fullName ?? ""}',
                                          style: Theme.of(context).textTheme.bodyMedium)
                                      : Text('${AppLocalizations.of(context)!.specialist}: Chưa xác định',
                                          style: Theme.of(context).textTheme.bodyMedium),
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
                        const SizedBox(height: TSizes.md),
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemBuilder: (context, indexStep) {
                        //     return Row(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Column(
                        //           children: [
                        //             CircleAvatar(
                        //               radius: 12,
                        //               backgroundColor: Colors.teal,
                        //               child: Text(
                        //                 '${indexStep + 1}',
                        //                 style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.white),
                        //               ),
                        //             ),
                        //             if (indexStep != steps.length - 1)
                        //               Container(
                        //                 height: 20,
                        //                 width: 2,
                        //                 color: Colors.teal,
                        //               ),
                        //           ],
                        //         ),
                        //         const SizedBox(width: TSizes.md),
                        //         Expanded(
                        //           child: Text(
                        //             steps[indexStep],
                        //             style: Theme.of(context).textTheme.bodyMedium,
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        //   itemCount: steps.length,
                        // ),
                        // const SizedBox(height: TSizes.sm),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     // Text("Chi phí: ", style: Theme.of(context).textTheme.bodyLarge),
                        //     const SizedBox(width: TSizes.sm),
                        //     TProductPriceText(price: routine.totalPrice.toString()),
                        //   ],
                        // ),
                        const Divider(
                          thickness: 0.2,
                        ),
                        if ((order.statusPayment == "Pending" || order.statusPayment == "PendingDeposit") &&
                            order.status.toLowerCase() != "cancelled")
                          Text(
                            AppLocalizations.of(context)!.payment_methods,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        const SizedBox(
                          height: TSizes.sm,
                        ),
                        if ((order.statusPayment == "Pending" || order.statusPayment == "PendingDeposit") &&
                            order.status.toLowerCase() != "cancelled" &&
                            order.paymentMethod?.toLowerCase() != "cash")
                          TPaymentSelection(
                            total: (order.totalAmount - (order.voucher?.discountAmount ?? 0)),
                            onOptionChanged: handlePaymentOptionChange,
                            selectedOption: _selectedPaymentOption,
                          ),
                        if (order.paymentMethod?.toLowerCase() == "cash") Text('Thanh toán tại cửa hàng'),
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
                                  price: (order.totalAmount).toString(),
                                  isLarge: false,
                                )
                              ],
                            ),
                            if (order.voucher != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.discount_fee, style: Theme.of(context).textTheme.bodyMedium),
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
                                  AppLocalizations.of(context)!.total_amount,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                TProductPriceText(
                                  price: (order.totalAmount - (order.voucher?.discountAmount ?? 0)).toString(),
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
                                AppLocalizations.of(context)!.payment_method,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  order.paymentMethod?.toLowerCase() == 'cash'
                                      ? AppLocalizations.of(context)!.cash_on_delivery
                                      : AppLocalizations.of(context)!.bank_transfer,
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
                              AppLocalizations.of(context)!.order_date,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                                DateFormat('HH:mm, dd/MM/yyyy').format(
                                  DateTime.parse(order.createdDate ?? "").toUtc().toLocal().add(Duration(hours: 7)),
                                ),
                                style: Theme.of(context).textTheme.bodySmall)
                          ],
                        ),

                        if (order.status == 'Cancelled')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.cancellation_date,
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
                                AppLocalizations.of(context)!.cancellation_reason,
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
                        // if (order.status == "Pending")
                        //   TextButton(
                        //       onPressed: () {
                        //         _showModalCancel(context, order.orderId);
                        //       },
                        //       child: Text(
                        //         'Hủy đơn hàng',
                        //         style: Theme
                        //             .of(context)
                        //             .textTheme
                        //             .bodyLarge
                        //             ?.copyWith(color: TColors.darkGrey),
                        //       )),
                      ],
                    );
                  } else if (state is OrderRoutineError) {
                    return const SizedBox();
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
                child: Text(AppLocalizations.of(context)!.pay_now)),
          const SizedBox(
            width: TSizes.md,
          )
        ],
      ),
    );
  }

  void _showModelQR(BuildContext context, int id) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.all(TSizes.spacebtwSections), child: TQrCheckIn(id: id.toString(), time: DateTime.now())),
            ],
          ),
        );
      },
    );
  }
}
