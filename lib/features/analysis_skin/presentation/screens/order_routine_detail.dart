import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/model/request_payos_model.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/payment_method.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/enum.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_order_routine.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/order_routine/order_routine_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_deposit.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';
import 'package:spa_mobile/features/service/presentation/bloc/payment/payment_bloc.dart';
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
                OrderRoutineBloc(getOrderRoutine: serviceLocator())..add(GetOrderRoutineDetailEvent(GetOrderRoutineParams(widget.orderId))),
            child: BlocListener<OrderRoutineBloc, OrderRoutineState>(
              listener: (context, state) {
                if (state is OrderRoutineLoaded) {
                  setState(() {
                    isPaid = state.order.statusPayment == "Paid" || state.order.statusPayment == "PaidDeposit";
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
                    final List<String> steps = routine.steps.split(", ");
                    totalAmount = order.totalAmount - (order.voucher?.discountAmount ?? 0);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (order.statusPayment != 'Cash')
                          Text(
                              'Trạng thái thanh toán: ${order.statusPayment == 'PaidDeposit' ? 'Đã thanh toán ${(order.totalAmount - (order.voucher?.discountAmount ?? 0)) * 0.3}' : order.statusPayment == 'Paid' ? 'Đã thanh toán đủ' : 'Chưa thanh toán'}'),
                        const SizedBox(
                          height: TSizes.xs,
                        ),
                        Text(routine.description, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: TSizes.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Các bước của liệu trình", overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                            GestureDetector(
                              onTap: () => goTrackingRoutineDetail(routine.skincareRoutineId, order.customerId),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Xem chi tiết", style: Theme.of(context).textTheme.bodySmall),
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, indexStep) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.teal,
                                      child: Text(
                                        '${indexStep + 1}',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.white),
                                      ),
                                    ),
                                    if (indexStep != steps.length - 1)
                                      Container(
                                        height: 20,
                                        width: 2,
                                        color: Colors.teal,
                                      ),
                                  ],
                                ),
                                const SizedBox(width: TSizes.md),
                                Expanded(
                                  child: Text(
                                    steps[indexStep],
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: steps.length,
                        ),
                        const SizedBox(height: TSizes.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Chi phí: ", style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(width: TSizes.sm),
                            TProductPriceText(price: routine.totalPrice.toString()),
                          ],
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
                                "Phương thức thanh toán",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  order.paymentMethod?.toLowerCase() == 'cash' ? 'Thanh toán khi nhận hàng' : 'Chuyển khoản',
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
                              'Ngày đặt lịch',
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
                child: const Text("Pay Now")),
          const SizedBox(
            width: TSizes.md,
          )
        ],
      ),
    );
  }
}
