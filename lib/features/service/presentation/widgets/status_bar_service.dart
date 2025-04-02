import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/features/service/data/model/order_appointment_model.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_appointment/list_appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/order_horizontal_shimmer_card.dart';

class TStatusTabService extends StatefulWidget {
  const TStatusTabService({super.key, required this.status});

  final String status;

  @override
  _TStatusTabServiceState createState() => _TStatusTabServiceState();
}

class _TStatusTabServiceState extends State<TStatusTabService> with AutomaticKeepAliveClientMixin {
  List<OrderAppointmentModel> orders = [];
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
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ListAppointmentBloc>(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.lg),
        child: Expanded(
          child: BlocBuilder<ListAppointmentBloc, ListAppointmentState>(
            builder: (context, state) {
              if (state is ListAppointmentLoaded) {
                if (widget.status == "pending") {
                  orders = state.pending;
                  pagination = state.paginationPending;
                  isLoading = state.isLoadingMorePending;
                } else if (widget.status == "completed") {
                  orders = state.completed;
                  pagination = state.paginationCompleted;
                  isLoading = state.isLoadingMoreCompleted;
                } else if (widget.status == "arrived") {
                  orders = state.arrived;
                  pagination = state.paginationArrived;
                  isLoading = state.isLoadingMoreArrived;
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
                        context.read<ListAppointmentBloc>().add(GetListAppointmentEvent(page: pagination.page + 1, title: widget.status));
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
                          return isLoading ? const TOrderHorizontalShimmer() : const SizedBox.shrink();
                        } else {
                          final order = orders[index];
                          var totalTime = order.appointments.fold(0, (sum, x) => sum + int.parse(x.service?.duration ?? "0"));
                          if (order.appointments.length > 1) {
                            totalTime = totalTime + (order.appointments.length - 1) * 5;
                          }
                          return TRoundedContainer(
                            padding: const EdgeInsets.all(TSizes.sm),
                            child: GestureDetector(
                              onTap: () => goBookingDetail(orders[index].orderId, isBack: true),
                              child: Column(
                                children: [
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
                                    height: TSizes.sm,
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
                                    height: TSizes.sm,
                                  ),
                                  TGridLayout(
                                      itemCount: orders[index].appointments.length,
                                      mainAxisExtent: 50,
                                      crossAxisCount: 1,
                                      itemBuilder: (context, indexItem) {
                                        final appointment = order.appointments[indexItem];

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
                                      TProductPriceText(price: order.totalAmount.toString())
                                    ],
                                  ),
                                  const SizedBox(
                                    height: TSizes.sm,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const Spacer(),
                                  //     Container(
                                  //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.grey[200],
                                  //         borderRadius: BorderRadius.circular(8),
                                  //       ),
                                  //       child: Row(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         children: [
                                  //           const Icon(Icons.payment, size: 20, color: Colors.green),
                                  //           const SizedBox(width: 4),
                                  //           // Builder(
                                  //           //   builder: (context) {
                                  //           //     final bool isPaid = order.statusPayment != "Pending";
                                  //           //     final double remainingAmount = 200000;
                                  //           //     if (isPaid) {
                                  //           //       return Text(
                                  //           //         "Đã hoàn tất thanh toán",
                                  //           //         style: Theme.of(context).textTheme.labelLarge,
                                  //           //       );
                                  //           //     } else {
                                  //           //       return Text(
                                  //           //         "Cần trả: ${remainingAmount.toStringAsFixed(0)}đ",
                                  //           //         style: Theme.of(context).textTheme.labelLarge,
                                  //           //       );
                                  //           //     }
                                  //           //   },
                                  //           // ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                );
              } else if (state is ListAppointmentLoading) {
                return TGridLayout(
                    itemCount: 4,
                    mainAxisExtent: 150,
                    itemBuilder: (_, __) {
                      return const TOrderHorizontalShimmer();
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
  void initState() {
    super.initState();
    _loadLanguageAndInit();
    _scrollController = ScrollController();
    context.read<ListAppointmentBloc>().add(GetListAppointmentEvent(page: 1, title: widget.status));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class HighlightedDate extends StatelessWidget {
  final String date;
  final Color backgroundColor;
  final Color textColor;

  const HighlightedDate({
    Key? key,
    required this.date,
    this.backgroundColor = TColors.primary,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        date,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
