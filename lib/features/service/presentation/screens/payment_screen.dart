import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/model/request_payos_model.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/payment_method.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/enum.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/product/domain/usecases/cancel_order.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_deposit.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/payment/payment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/payment_detail_service.dart';
import 'package:spa_mobile/features/service/presentation/widgets/qr_checkin.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.id, required this.isBack});

  final int id;
  final bool isBack;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentOption _selectedPaymentOption = PaymentOption.full;
  double totalAmount = 0;
  bool isPaid = true;

  void handlePaymentOptionChange(PaymentOption option) {
    setState(() {
      _selectedPaymentOption = option;
    });
  }

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
    context.read<AppointmentBloc>().add(GetAppointmentEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: widget.isBack,
        title: Text(AppLocalizations.of(context)!.order_details),
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
          child: BlocListener<AppointmentBloc, AppointmentState>(
            listener: (context, state) {
              if (state is AppointmentLoaded) {
                setState(() {
                  isPaid = state.appointment.statusPayment == "Paid";
                });
              }
            },
            child: BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                if (state is AppointmentLoaded) {
                  final order = state.appointment;

                  var totalTime = order.appointments.fold(0, (sum, x) => sum + int.parse(x.service?.duration ?? "0"));
                  if (order.appointments.length > 1) {
                    totalTime = totalTime + (order.appointments.length - 1) * 5;
                  }
                  final totalPrice = order.appointments.fold(0.0, (sum, x) => sum + x.subTotal);
                  totalAmount = order.totalAmount;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Text(
                      //           AppLocalizations.of(context)!.order_ref,
                      //           style: Theme.of(context).textTheme.bodySmall,
                      //         ),
                      //         Text(
                      //           order.orderCode.toString(),
                      //           style: Theme.of(context).textTheme.bodySmall,
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: TSizes.sm,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.payment, color: Colors.green),
                          const SizedBox(width: TSizes.sm),
                          if (order.statusPayment != 'Cash')
                            Text(
                                '${AppLocalizations.of(context)!.payment_status}: ${order.statusPayment == 'PaidDeposit' ? '${AppLocalizations.of(context)!.deposit_paid} ${formatMoney(((order.totalAmount - (order.voucher?.discountAmount ?? 0)) * 0.3).toString())}' : order.statusPayment == 'Paid' ? AppLocalizations.of(context)!.fully_paid : AppLocalizations.of(context)!.unpaid}'),
                          const SizedBox(
                            height: TSizes.xs,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.sm,
                      ),
                      Row(
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
                                order.appointments[0].branch?.branchName ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                order.appointments[0].branch?.branchAddress ?? "",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.calendar_1,
                            color: TColors.primary,
                          ),
                          const SizedBox(
                            width: TSizes.sm,
                          ),
                          Text(
                            DateFormat('EEEE, dd MMMM yyyy', lgCode).format(order.appointments[0].appointmentsTime).toString(),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.clock,
                            color: TColors.primary,
                          ),
                          const SizedBox(
                            width: TSizes.sm,
                          ),
                          Text(
                            "${DateFormat('HH:mm', lgCode).format(order.appointments[0].appointmentsTime).toString()} - "
                            "${DateFormat('HH:mm', lgCode).format(order.appointments[0].appointmentsTime.add(Duration(minutes: totalTime))).toString()}",
                          ),
                          const Spacer(),
                          TRoundedIcon(
                            icon: Iconsax.info_circle,
                            color: TColors.darkerGrey,
                            onPressed: () => _showModelTimeInfo(context),
                          )
                        ],
                      ),
                      Divider(
                        color: dark ? TColors.darkGrey : TColors.grey,
                        thickness: 0.5,
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      TGridLayout(
                          mainAxisExtent: 180,
                          crossAxisCount: 1,
                          isScroll: false,
                          itemCount: order.appointments.length,
                          itemBuilder: (context, index) {
                            final serviceState = order.appointments[index];
                            return
                                // Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // children: [
                                Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(serviceState.service.name, style: Theme.of(context).textTheme.bodyMedium),
                                    if (order.status.toLowerCase() != 'cancelled')
                                      TRoundedIcon(
                                        icon: Icons.qr_code_scanner_rounded,
                                        color: TColors.primary,
                                        size: 30,
                                        onPressed: () => _showModelQR(context, serviceState.appointmentId),
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
                                Text('${AppLocalizations.of(context)!.specialist}: ${serviceState.staff?.staffInfo?.fullName ?? ""}',
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
                                  color: dark ? TColors.darkGrey : TColors.grey,
                                  thickness: 0.5,
                                ),
                              ],
                            );
                          }),
                      TPaymentDetailService(
                        price: (totalPrice).toString(),
                        total: (order.totalAmount - (order.voucher?.discountAmount ?? 0)).toString(),
                        promotePrice: order.voucherId != 0 ? order.voucher!.discountAmount : 0,
                      ),
                      Divider(
                        color: dark ? TColors.darkGrey : TColors.grey,
                        thickness: 0.5,
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
                          order.status.toLowerCase() != "cancelled")
                        TPaymentSelection(
                          total: (order.totalAmount - (order.voucher?.discountAmount ?? 0)),
                          onOptionChanged: handlePaymentOptionChange,
                          selectedOption: _selectedPaymentOption,
                        ),
                      Divider(
                        color: dark ? TColors.darkGrey : TColors.grey,
                        thickness: 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.booking_date,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(DateFormat('HH:mm, dd/MM/yyyy').format(order.createdDate.toUtc().toLocal().add(Duration(hours: 7))),
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
                                  order.updatedDate.toUtc().toLocal().add(Duration(hours: 7)),
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
                      if (order.status == "Pending")
                        TextButton(
                            onPressed: () {
                              _showModalCancel(context, order.orderId);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.cancel_appointment,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: TColors.darkGrey),
                            ))
                    ],
                  );
                } else if (state is AppointmentLoading) {
                  return const TLoader();
                }
                return const SizedBox();
              },
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
                        orderId: widget.id,
                        request: RequestPayOsModel(returnUrl: "/success", cancelUrl: "/cancel"))));
                  } else {
                    context.read<PaymentBloc>().add(PayDepositEvent(PayDepositParams(
                        totalAmount: totalAmount.toString(),
                        orderId: widget.id,
                        percent: 30,
                        request: RequestPayOsModel(returnUrl: "/success", cancelUrl: "/cancel"))));
                  }
                  goRedirectPayment(
                    widget.id,
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

  void _showModelTimeInfo(BuildContext context) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.2,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(TSizes.spacebtwSections),
                  child: Text(
                    AppLocalizations.of(context)!.service_gap_notice,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ],
          ),
        );
      },
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
                AppLocalizations.of(context)!.cancellation_reason,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                controller: reasonController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enter_your_message,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: BlocListener<AppointmentBloc, AppointmentState>(
                      listener: (context, state) {
                        if (state is CancelAppointmentSuccess) {
                          TSnackBar.infoSnackBar(context, message: state.error);
                          goBookingDetail(state.orderId);
                        }
                        if (state is AppointmentError) {
                          TSnackBar.errorSnackBar(context, message: state.message);
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<AppointmentBloc>()
                              .add(CancelAppointmentEvent(CancelOrderParams(orderId: orderId, reason: reasonController.text.trim())));
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
