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
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/enum.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/payment/payment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/payment_detail_service.dart';

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
        actions: [
          TRoundedIcon(
            icon: Iconsax.home_2,
            onPressed: () => goHome(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: BlocListener<AppointmentBloc, AppointmentState>(
          listener: (context, state) {
            if (state is AppointmentLoaded) {
              isPaid = state.appointment.statusPayment == "Pending";
            }
          },
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              if (state is AppointmentLoaded) {
                final order = state.appointment;

                final totalTime = order.appointments.fold(0, (sum, x) => sum + int.parse(x.service?.duration ?? "0"));
                final totalPrice = order.appointments.fold(0.0, (sum, x) => sum + x.subTotal);
                totalAmount = order.totalAmount;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("Code: "),
                            Text(order.orderCode.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.payment, size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            if (order.statusPayment == "Pending")
                              Text(
                                "Pending",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                          ],
                        )
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
                        )
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.md,
                    ),
                    Divider(
                      color: dark ? TColors.darkGrey : TColors.grey,
                      thickness: 0.5,
                    ),
                    const SizedBox(
                      height: TSizes.md,
                    ),
                    TGridLayout(
                        mainAxisExtent: 70,
                        crossAxisCount: 1,
                        itemCount: order.appointments.length,
                        itemBuilder: (context, index) {
                          final serviceState = order.appointments[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(serviceState.service.name, style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(
                                    height: TSizes.sm,
                                  ),
                                  Text(
                                    "${serviceState.service.duration} ${AppLocalizations.of(context)!.minutes}",
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.darkerGrey),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TProductPriceText(price: serviceState.service.price.toString()),
                                ],
                              )
                            ],
                          );
                        }),
                    Divider(
                      color: dark ? TColors.darkGrey : TColors.grey,
                      thickness: 0.5,
                    ),
                    TPaymentDetailService(
                      price: (totalPrice).toString(),
                      total: (order.totalAmount).toString(),
                      promotePrice: order.voucherId != 0 ? order.voucher!.discountAmount : 0,
                    ),
                    Divider(
                      color: dark ? TColors.darkGrey : TColors.grey,
                      thickness: 0.5,
                    ),
                    if (order.statusPayment == "Pending")
                      Text(
                        "Payment Methods",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    if (order.statusPayment == "Pending")
                      TPaymentSelection(
                        total: order.totalAmount,
                        onOptionChanged: handlePaymentOptionChange,
                        selectedOption: _selectedPaymentOption,
                      ),
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
      bottomNavigationBar: Row(
        children: [
          const Spacer(),
          if (isPaid)
            ElevatedButton(
                onPressed: () {
                  context.read<PaymentBloc>().add(PayFullEvent(PayFullParams(
                      totalAmount: totalAmount.toString(),
                      orderId: widget.id,
                      request: RequestPayOsModel(returnUrl: "success", cancelUrl: "cancel"))));
                  goRedirectPayment(
                    widget.id,
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
