import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/inherited/appointment_data.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';

class ServiceAppointmentListView extends StatelessWidget {
  final RoutineStepModel data;
  final String lgCode;
  final int orderId;
  final int userId;
  final int routineId;
  final int userRoutineId;

  const ServiceAppointmentListView(
      {super.key,
      required this.data,
      required this.lgCode,
      required this.orderId,
      required this.userId,
      required this.routineId,
      required this.userRoutineId});

  @override
  Widget build(BuildContext context) {
    final controller = AppointmentDataController();
    var isEnableUpdateAll = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${AppLocalizations.of(context)!.service} (${data.serviceRoutineSteps.length})",
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: TSizes.sm),
        Container(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          margin: const EdgeInsets.symmetric(vertical: TSizes.xs),
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: data.serviceRoutineSteps.length,
            separatorBuilder: (context, index) => const SizedBox(width: TSizes.md),
            itemBuilder: (context, index) {
              // final service = data.serviceRoutineSteps[index].;
              final AppointmentModel appt = data.appointments![index];
              if (data.step == 1) {
                isEnableUpdateAll = true;
              }
              var isStaffReal = true;
              if (appt.staff?.roleId == 3) {
                isStaffReal = false;
              }
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => goAppointmentDetail(appt.appointmentId.toString(), isEnableUpdateAll),
                    child: TRoundedContainer(
                      backgroundColor: (appt.status.toLowerCase()) == 'completed'
                          ? TColors.success.withOpacity(0.5)
                          : appt.status.toLowerCase() == 'cancelled'
                              ? Colors.red.shade50
                              : appt.status.toLowerCase() == 'arrived'
                                  ? Colors.tealAccent.withOpacity(0.5)
                                  : TColors.primaryBackground,
                      padding: EdgeInsets.all(TSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appt.service.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: TSizes.sm),
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
                                DateFormat('EEEE, dd MMMM yyyy', lgCode).format(appt.appointmentsTime).toString(),
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
                                size: 20,
                                color: TColors.primary,
                              ),
                              const SizedBox(width: TSizes.sm),
                              Text(
                                "${DateFormat('HH:mm', lgCode).format(appt.appointmentsTime)} - "
                                "${DateFormat('HH:mm', lgCode).format(appt.appointmentEndTime)}",
                              ),
                            ],
                          ),
                          const SizedBox(height: TSizes.sm),
                          isStaffReal
                              ? Row(
                                  children: [
                                    const Icon(
                                      Iconsax.user,
                                      size: 20,
                                    ),
                                    const SizedBox(width: TSizes.sm),
                                    Text(appt.staff?.staffInfo?.fullName ?? ""),
                                  ],
                                )
                              : AppointmentData(
                                  controller: controller,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                        onPressed: () {
                                          controller.updateServiceIds([appt.service.serviceId]);
                                          controller.updateServices([appt.service]);
                                          controller.updateTime(int.parse(appt.service.duration));
                                          controller.updateTotalPrice(0);
                                          controller.updateBranchId(appt.branch?.branchId ?? 0);
                                          controller.updateBranch(appt.branch);
                                          controller.updateUser(appt.customer ?? UserModel.empty());
                                          controller.updateId(appt.appointmentId);
                                          controller.updateNote(appt.notes ?? "");
                                          controller.updateMinDate(appt.appointmentsTime);
                                          controller.updateStep(data.step);
                                          controller.updateOrderId(orderId);
                                          controller.updateUserId(userId);
                                          controller.updateRoutineId(routineId);
                                          controller.updateUserRoutineId(userRoutineId);
                                          goUpdateSpecialist(appt.branch?.branchId ?? 0, controller);
                                        },
                                        child: Text(AppLocalizations.of(context)!.choose_specialist,
                                            style: Theme.of(context).textTheme.labelLarge)),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  if (!isStaffReal && appt.appointmentsTime.difference(DateTime.now()).inHours <= 48)
                    Positioned(
                      bottom: 2,
                      right: 0,
                      child: Transform.rotate(
                        angle: -0.35398, // 45 degrees in radians
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          color: Colors.yellowAccent,
                          child: Text(
                            AppLocalizations.of(context)!.update_now,
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
