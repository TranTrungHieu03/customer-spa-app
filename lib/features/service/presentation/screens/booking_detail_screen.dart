import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final int bookingId;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        actions: [
          TRoundedIcon(
            icon: Iconsax.home_2,
            onPressed: () => goHome(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: BlocConsumer<AppointmentBloc, AppointmentState>(listener: (context, state) {
          if (state is AppointmentError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        }, builder: (context, state) {
          if (state is AppointmentLoading) {
            const TLoader();
          } else if (state is AppointmentLoaded) {
            final appointment = state.appointment;
            // return SingleChildScrollView(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Text(
            //       //   formatDate(appointment),
            //       //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            //       //         fontWeight: FontWeight.bold,
            //       //       ),
            //       // ),
            //       const SizedBox(
            //         height: TSizes.md,
            //       ),
            //       TRoundedContainer(
            //         shadow: true,
            //         padding: const EdgeInsets.all(TSizes.sm),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Row(
            //               children: [
            //                 TRoundedImage(
            //                   applyImageRadius: true,
            //                   imageUrl: TImages.thumbnailService,
            //                   isNetworkImage: true,
            //                   width: THelperFunctions.screenWidth(context) * 0.2,
            //                   height: THelperFunctions.screenWidth(context) * 0.2,
            //                   fit: BoxFit.cover,
            //                 ),
            //                 const SizedBox(
            //                   width: TSizes.sm,
            //                 ),
            //                 ConstrainedBox(
            //                   constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.7),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       ConstrainedBox(
            //                         constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.4),
            //                         child: TProductTitleText(
            //                           title: appointment.service!.name,
            //                           maxLines: 1,
            //                         ),
            //                       ),
            //                       Text("Steps", style: Theme.of(context).textTheme.titleLarge),
            //                       const SizedBox(
            //                         height: TSizes.sm,
            //                       ),
            //                       Text(appointment.service!.steps, style: Theme.of(context).textTheme.bodyMedium),
            //                     ],
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(
            //         height: TSizes.md,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [Text("Staff name", style: Theme.of(context).textTheme.titleLarge), const Text("Nguyễn Hiền")],
            //       ),
            //       const SizedBox(
            //         height: TSizes.md,
            //       ),
            //       TPaymentDetailService(
            //           price: appointment.service!.price.toString(),  total: (0 + appointment.service!.price).toString()),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           TextButton(
            //               onPressed: () {
            //                 _showCancelModal(context);
            //               },
            //               child: const Text("Cancel")),
            //           TextButton(
            //               onPressed: () {
            //                 goStatusService(
            //                     "Reschedule Complete",
            //                     "Dear John Kevin please share your avaluable feedback. This will help use improve our services.",
            //                     const Text(""),
            //                     TImages.reBookingSuccessIcon,
            //                     Colors.orange);
            //               },
            //               child: const Text("Re-booking")),
            //         ],
            //       )
            //     ],
            //   ),
            // );
          }
          return const TErrorBody();
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(GetAppointmentEvent(widget.bookingId));
  }
}

void _showCancelModal(BuildContext context) {
  final List<String> reasons = ["Service not needed anymore", "Found a better option", "Too expensive", "Poor service experience", "Other"];

  String? selectedReason;
  showModalBottomSheet(
    context: context,
    elevation: 0.5,
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
              "Reason for cancellation",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  final reason = reasons[index];
                  return RadioListTile<String>(
                    title: Text(reason),
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (value) {
                      // setState(() {
                      //   selectedReason = value;
                      // });
                    },
                  );
                },
              ),
            ),
            if (selectedReason == "Other")
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Enter your reason description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      goStatusService(
                          "Cancel Success",
                          "Dear John Kevin please share your avaluable feedback. This will help use improve our services.",
                          const Text(""),
                          TImages.deleteIcon,
                          Colors.redAccent);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                    ),
                    child: Text(
                      "Cancel",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: TSizes.md,
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
