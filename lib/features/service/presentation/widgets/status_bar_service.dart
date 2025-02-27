import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_appointment/list_appointment_bloc.dart';

class TStatusTabService extends StatefulWidget {
  const TStatusTabService({super.key, required this.status});

  final String status;

  @override
  _TStatusTabServiceState createState() => _TStatusTabServiceState();
}

class _TStatusTabServiceState extends State<TStatusTabService> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListAppointmentBloc, ListAppointmentState>(
      builder: (context, state) {
        if (state is ListAppointmentDoneLoaded) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.sm),
                child: GestureDetector(
                  onTap: () => goBookingDetail(1),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: TSizes.sm),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: THelperFunctions.screenWidth(context) * 0.9,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                     const Expanded(
                                        child: TProductTitleText(
                                          title: "Service Name 1",
                                          maxLines: 2,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.payment, size: 16, color: Colors.green),
                                            const SizedBox(width: 4),
                                            Builder(
                                              builder: (context) {
                                                final bool isPaid = true;
                                                final double remainingAmount = 200000;
                                                if (isPaid) {
                                                  return const Text(
                                                    "Đã hoàn tất thanh toán",
                                                    style: TextStyle(color: Colors.green, fontSize: 12),
                                                  );
                                                } else {
                                                  return Text(
                                                    "Cần trả: ${remainingAmount.toStringAsFixed(0)}đ",
                                                    style: const TextStyle(color: Colors.red, fontSize: 12),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
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
                                      Text("20"),
                                      Text(AppLocalizations.of(context)!.minutes)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Specialist " + ": "),
                                      Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text("Nhu Nguyen")),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      HighlightedDate(
                                        date: "09:10 09/10/2024",
                                        backgroundColor: TColors.primary,
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: TSizes.spacebtwItems,
            ),
            itemCount: 5,
          );
        }
        return Center(child: Text('Do not have any order here!!'));
      },
    );
  }

  @override
  void initState() {
    context.read<ListAppointmentBloc>().add(GetListAppointmentEvent(page: 1, title: widget.status));
  }
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
