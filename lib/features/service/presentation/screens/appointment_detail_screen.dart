import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment_detail.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/qr_checkin.dart';
import 'package:spa_mobile/init_dependencies.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppbar(
        title: Text('Appointment Detail'),
        showBackArrow: true,
      ),
      body: BlocProvider(
        create: (_) => AppointmentBloc(
            getAppointment: serviceLocator(),
            cancelOrder: serviceLocator(),
            createAppointment: serviceLocator(),
            updateAppointment: serviceLocator(),
            getAppointmentDetail: serviceLocator())
          ..add(GetAppointmentDetailEvent(GetAppointmentDetailParams(appointmentId: widget.appointmentId))),
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            if (state is AppointmentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AppointmentDetailLoaded) {
              final appointment = state.appointment;
              return Padding(
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              appointment.status,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                        if (appointment.status.toLowerCase() == 'pending')
                          Align(
                            alignment: Alignment.centerRight,
                            child: TRoundedIcon(
                              icon: Icons.qr_code_scanner_rounded,
                              color: TColors.primary,
                              size: 30,
                              onPressed: () => _showModelQR(context, appointment.appointmentId),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.md,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
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
                              appointment.branch?.branchName ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              appointment.branch?.branchAddress ?? "",
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
                          DateFormat('EEEE, dd MMMM yyyy', lgCode).format(appointment.appointmentsTime).toString(),
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
                          "${DateFormat('HH:mm', lgCode).format(appointment.appointmentsTime).toString()} - "
                          "${DateFormat('HH:mm', lgCode).format(appointment.appointmentEndTime).toString()}",
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.md,
                    ),
                    const SizedBox(
                      height: TSizes.md,
                    ),
                    (appointment.staff?.roleId != 3)
                        ? TRoundedContainer(
                            padding: const EdgeInsets.all(TSizes.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Specialist information', style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
                                const SizedBox(
                                  height: TSizes.sm,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.user,
                                      size: 17,
                                    ),
                                    const SizedBox(
                                      width: TSizes.sm,
                                    ),
                                    Text(
                                      appointment.staff?.staffInfo?.fullName ?? "",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.call,
                                      size: 17,
                                    ),
                                    const SizedBox(
                                      width: TSizes.sm,
                                    ),
                                    Text(
                                      appointment.staff?.staffInfo?.phoneNumber ?? "",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {}, child: Text('Choose specialist', style: Theme.of(context).textTheme.labelLarge)),
                          ),
                    const SizedBox(
                      height: TSizes.md,
                    ),
                    TRoundedContainer(
                      padding: const EdgeInsets.all(TSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Service information', style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Text(
                            appointment.service.name ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              Text('Duration:'),
                              const SizedBox(
                                width: TSizes.sm,
                              ),
                              Text(
                                '${appointment.service.duration} minutes' ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Text(
                            appointment.service.description ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Steps: '),
                              const SizedBox(
                                width: TSizes.sm,
                              ),
                              Text(
                                '${appointment.service.steps} ' ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ])));
            } else if (state is AppointmentError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
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
