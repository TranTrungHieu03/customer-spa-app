import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/inherited/appointment_data.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/enum.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_voucher/list_voucher_bloc.dart';
import 'package:spa_mobile/features/product/presentation/screens/voucher_screen.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_staff_free_in_time.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/leave_booking.dart';
import 'package:spa_mobile/features/service/presentation/widgets/payment_detail_service.dart';
import 'package:spa_mobile/init_dependencies.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  const ConfirmPaymentScreen({
    super.key,
    required this.controller,
  });

  final AppointmentDataController controller;

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  String lgCode = 'vi';
  int totalTime = 0;

  @override
  void initState() {
    super.initState();

    _loadLanguageAndInit();
    totalTime = widget.controller.services.fold(0, (sum, x) => sum + int.parse(x.duration));
    if (widget.controller.services.length > 1) {
      totalTime = totalTime + (widget.controller.services.length - 1) * 5;
    }
    // check if choose different specialist between services
    // final isChooseDiffSpecialist = widget.controller.staffIds.map((x) {
    //   return x != widget.controller.staffIds[0];
    // }).contains(true);
    // //check if all specialist is anyone
    // final isHaveSpecific = widget.controller.staffIds.map((x) {
    //   return x == 0;
    // }).contains(false);
    //check if have any specialist is anyone
    final isHaveAny = widget.controller.staffIds.map((x) {
      return x == 0;
    }).contains(true);
    if (isHaveAny) {
      context.read<ListStaffBloc>().add(GetStaffFreeInTimeEvent(
          params: GetStaffFreeInTimeParams(
              branchId: widget.controller.branchId, serviceIds: widget.controller.serviceIds, startTimes: widget.controller.time)));
    }
  }

  Future<void> _loadLanguageAndInit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lgCode = prefs.getString('language_code') ?? "vi";
    });
  }

  void _showModelLeave(BuildContext context) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: TLeaveBooking(clearFn: () => context.read<AppointmentBloc>().add(ClearAppointmentEvent())),
        );
      },
    );
  }

  final _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final FocusNode _focusNode = FocusNode();

  final ValueNotifier<PaymentOption> _selectedPaymentOption = ValueNotifier(PaymentOption.full);

  void handlePaymentOptionChange(PaymentOption option) {
    _selectedPaymentOption.value = option;
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Hủy FocusNode khi widget bị hủy
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutSine,
        );
      }
    });
  }

  double total = 0;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = widget.controller;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: TAppbar(
            showBackArrow: false,
            leadingIcon: Iconsax.arrow_left,
            leadingOnPressed: () => goSelectTime(controller.staffIds, controller),
            actions: [
              TRoundedIcon(
                icon: Iconsax.scissor_1,
                onPressed: () {
                  _showModelLeave(context);
                },
              ),
              const SizedBox(
                width: TSizes.md,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: BlocConsumer<ListStaffBloc, ListStaffState>(
              listener: (context, state) {
                if (state is ListStaffLoaded) {
                  AppLogger.info(widget.controller.staffIds.every((x) => x == 0));
                  if (widget.controller.staffIds.every((x) => x == 0)) {
                    final listStaffFreeIntersection = state.intersectionStaff;
                    final List<int> indexAnySpec =
                        widget.controller.staffIds.asMap().entries.where((entry) => entry.value == 0).map((entry) => entry.key).toList();
                    if (listStaffFreeIntersection.isNotEmpty) {
                      for (int index in indexAnySpec) {
                        widget.controller.addStaffId(index, listStaffFreeIntersection[0].staffId);
                        widget.controller.addStaff(index, listStaffFreeIntersection[0]);
                      }
                      AppLogger.debug("StaffIds: ${widget.controller.staffIds}");
                    } else {
                      final listStaffFree = (context.read<ListStaffBloc>().state as ListStaffLoaded).listStaff;
                      final List<int> indexAnySpec =
                          widget.controller.staffIds.asMap().entries.where((entry) => entry.value == 0).map((entry) => entry.key).toList();
                      for (int index in indexAnySpec) {
                        widget.controller.addStaffId(index, listStaffFree[index].staffs[0].staffId);
                        widget.controller.addStaff(index, listStaffFree[index].staffs[0]);
                      }
                      AppLogger.debug("StaffIds: ${widget.controller.staffIds}");
                    }
                  } else {
                    final listStaffFree = (context.read<ListStaffBloc>().state as ListStaffLoaded).listStaff;
                    final List<int> indexAnySpec =
                        widget.controller.staffIds.asMap().entries.where((entry) => entry.value == 0).map((entry) => entry.key).toList();
                    for (int index in indexAnySpec) {
                      widget.controller.addStaffId(index, listStaffFree[index].staffs[0].staffId);
                      widget.controller.addStaff(index, listStaffFree[index].staffs[0]);
                    }
                    AppLogger.debug("StaffIds: ${widget.controller.staffIds}");
                  }
                } else if (state is ListStaffError) {
                  TSnackBar.errorSnackBar(context, message: state.message);
                }
              },
              builder: (context, state) {
                AppLogger.info(state);
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(TSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Review and confirm",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(
                            height: TSizes.lg,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: TSizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                          controller.branchModel?.branchName ?? "",
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        Text(
                                          controller.branchModel?.branchAddress ?? "",
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
                                      DateFormat('EEEE, dd MMMM yyyy', lgCode).format(controller.time[0]).toString(),
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
                                      "${DateFormat('HH:mm', lgCode).format(controller.time[0]).toString()} - "
                                      "${DateFormat('HH:mm', lgCode).format(controller.time[0].add(Duration(minutes: totalTime))).toString()}",
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
                                ListView.separated(
                                  shrinkWrap: true,
                                  // Cho phép ListView tính toán chiều cao theo nội dung
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.services.length,
                                  itemBuilder: (context, index) {
                                    final service = controller.services[index];
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(service.name, style: Theme.of(context).textTheme.bodyMedium),
                                            const SizedBox(
                                              height: TSizes.sm,
                                            ),
                                            Text(
                                              "${service.duration} ${AppLocalizations.of(context)!.minutes}",
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.darkerGrey),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            TProductPriceText(
                                              price: service.price.toString(),
                                              isLarge: false,
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: TSizes.sm,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: dark ? TColors.darkGrey : TColors.grey,
                            thickness: 0.5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Mã giảm giá", style: Theme.of(context).textTheme.titleLarge),
                              (controller.voucher == null)
                                  ? TextButton(
                                      onPressed: () => _showVoucherModal(
                                          context, controller.totalPrice, controller.user ?? UserModel.empty(), controller),
                                      child: TRoundedContainer(
                                          padding: const EdgeInsets.all(TSizes.sm), child: Text(AppLocalizations.of(context)!.add)))
                                  : GestureDetector(
                                      onTap: () => _showVoucherModal(
                                          context, controller.totalPrice, controller.user ?? UserModel.empty(), controller),
                                      child: Text(controller.voucher?.code ?? ""))
                            ],
                          ),
                          Divider(
                            color: dark ? TColors.darkGrey : TColors.grey,
                            thickness: 0.5,
                          ),
                          const SizedBox(
                            height: TSizes.md,
                          ),
                          // BlocBuilder<ServiceBloc, ServiceState>(
                          //   builder: (context, state) {
                          // if (state is ServiceDetailSuccess) {
                          //   return
                          TPaymentDetailService(
                            price: (controller.services.fold(0.0, (a, b) => a += b.price)).toString(),
                            total: (controller.totalPrice).toString(),
                            promotePrice: controller.voucher?.discountAmount ?? 0,
                            //     );
                            //   }
                            //   return const SizedBox.shrink();
                            // },
                          ),
                          const SizedBox(
                            height: TSizes.md,
                          ),
                          Divider(
                            color: dark ? TColors.darkGrey : TColors.grey,
                            thickness: 0.5,
                          ),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          const SizedBox(
                            height: TSizes.md,
                          ),
                          Text("Note", style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(
                            height: TSizes.xs,
                          ),
                          TextField(
                            focusNode: _focusNode,
                            controller: _messageController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Paste your message to the center",
                              contentPadding: const EdgeInsets.all(TSizes.sm),
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            autofocus: false,
                            onTap: () {
                              _scrollToBottom();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (state is ListStaffLoading) const TLoader(),
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocConsumer<AppointmentBloc, AppointmentState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<AppointmentBloc>().add(CreateAppointmentEvent(CreateAppointmentParams(
                            staffId: controller.staffIds,
                            serviceId: controller.serviceIds,
                            branchId: controller.branchId,
                            appointmentsTime: controller.time,
                            notes: _messageController.text,
                            userId: controller.user?.userId ?? 0,
                            voucherId: controller.voucher?.voucherId ?? 0)));
                      },
                      child: Text(AppLocalizations.of(context)!.confirm),
                    );
                  },
                  listener: (context, state) {
                    if (state is AppointmentCreateSuccess) {
                      TSnackBar.successSnackBar(context, message: "Lich hen cua ban da duoc giu cho. Vui long thanh toan de hoan tat.");
                      goBookingDetail(state.id);
                    } else if (state is AppointmentError) {
                      TSnackBar.errorSnackBar(context, message: state.message);
                    }
                  },
                ),
              ],
            ),
          )),
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
                    "Giữa mỗi dịch vụ được khấu hao 5 phút để chuẩn bị cho dịch vụ tiếp theo",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ],
          ),
        );
      },
    );
  }
}

void _showVoucherModal(BuildContext context, double currentTotalPrice, UserModel user, AppointmentDataController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              left: TSizes.md,
              right: TSizes.md,
              top: TSizes.md,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   AppLocalizations.of(context)!.shop_voucher,
                //   style: Theme.of(context).textTheme.titleMedium,
                // ),
                // const SizedBox(height: 16),
                // TextField(
                //   decoration: InputDecoration(
                //     hintText: "Enter your voucher code",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16),
                Text(
                  "Available Vouchers",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 500,
                  child: BlocProvider<ListVoucherBloc>(
                    create: (context) =>
                        ListVoucherBloc(getVouchers: serviceLocator())..add(GetVoucherByDateEvent(DateTime.now().toUtc().toString())),
                    child: BlocBuilder<ListVoucherBloc, ListVoucherState>(
                      builder: (context, state) {
                        if (state is ListVoucherLoaded) {
                          final vouchers = [...state.vouchers]..sort((a, b) {
                              bool isInvalid(VoucherModel v) =>
                                  (user.bonusPoint ?? 0) < (v.requirePoint ?? 0) || currentTotalPrice < (v.minOrderAmount ?? 0);

                              return isInvalid(a) == isInvalid(b) ? 0 : (isInvalid(a) ? 1 : -1);
                            });

                          return ListView.builder(
                            shrinkWrap: false,
                            padding: const EdgeInsets.only(top: TSizes.md),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.vouchers.length,
                            itemBuilder: (BuildContext context, int index) {
                              final voucher = vouchers[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: ((user.bonusPoint ?? 0) < voucher.requirePoint || currentTotalPrice < (voucher.minOrderAmount ?? 0))
                                    ? TColors.grey
                                    : TColors.primaryBackground.withOpacity(0.9),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.local_offer,
                                    color:
                                        ((user.bonusPoint ?? 0) < voucher.requirePoint || currentTotalPrice < (voucher.minOrderAmount ?? 0))
                                            ? TColors.darkerGrey
                                            : Colors.green,
                                  ),
                                  title: GestureDetector(onTap: () => _showVoucherDetail(context, voucher), child: Text(voucher.code)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(formatMoney(voucher.discountAmount.toString())),
                                      if ((user.bonusPoint ?? 0) < voucher.requirePoint)
                                        Text('Cần thêm ${voucher.requirePoint - (user.bonusPoint ?? 0).toInt()} điểm để sử dụng mã này',
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.darkerGrey)),
                                      if (currentTotalPrice < (voucher.minOrderAmount ?? 0))
                                        Text(
                                            'Mua thêm ${formatMoney((voucher.minOrderAmount ?? 0 - currentTotalPrice).toString())} để sử dụng mã này',
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.darkerGrey)),
                                    ],
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: ((user.bonusPoint ?? 0) < voucher.requirePoint ||
                                            currentTotalPrice < (voucher.minOrderAmount ?? 0))
                                        ? null
                                        : () {
                                            controller.updateVoucher(voucher);
                                            controller.updateTotalPrice((controller.services.fold(0.0, (x, y) => x += y.price.toDouble()) -
                                                (controller.voucher?.discountAmount.toDouble() ?? 0)));
                                            goReview(controller);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.apply,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: Colors.white,
                                            fontSize: TSizes.md,
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is ListVoucherLoading) {
                          return ListView.builder(
                            shrinkWrap: false,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TShimmerEffect(width: THelperFunctions.screenWidth(context) * 0.7, height: TSizes.shimmerMd),
                                  TShimmerEffect(width: TSizes.shimmerMd, height: TSizes.shimmerSm)
                                ],
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showVoucherDetail(BuildContext context, VoucherModel voucher) {
  showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(heightFactor: 0.6, child: VoucherScreen(voucherModel: voucher));
      });
}
