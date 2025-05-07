import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/inherited/appointment_data.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_appointment/list_appointment_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';
import 'package:table_calendar/table_calendar.dart';

class TableAppointmentsScreen extends StatefulWidget {
  const TableAppointmentsScreen({super.key});

  @override
  State<TableAppointmentsScreen> createState() => _TableAppointmentsScreenState();
}

class _TableAppointmentsScreenState extends State<TableAppointmentsScreen> {
  DateTime _selectedDate = DateTime.now();
  String _lgCode = 'vi';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lgCode = prefs.getString('language_code') ?? "vi";
    });
  }

  DateTime getStartOfWeek(DateTime date) {
    DateTime monday = date.subtract(Duration(days: date.weekday - DateTime.monday));
    return DateTime(monday.year, monday.month, monday.day);
  }

  DateTime getEndOfWeek(DateTime date) {
    final end = date.add(Duration(days: DateTime.sunday - date.weekday));
    return DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
  }

  Map<DateTime, List<AppointmentModel>> _groupByDay(List<AppointmentModel> list) {
    final Map<DateTime, List<AppointmentModel>> grouped = {};
    for (var appointment in list) {
      final key = DateTime(appointment.appointmentsTime.year, appointment.appointmentsTime.month, appointment.appointmentsTime.day);
      grouped.putIfAbsent(key, () => []).add(appointment);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentDataController controller = AppointmentDataController();
    return Scaffold(
      appBar: TAppbar(title: Text(AppLocalizations.of(context)!.appointment_schedule), showBackArrow: true),
      body: BlocProvider(
        create: (_) => ListAppointmentBloc(getListAppointment: serviceLocator(), getAppointmentsByRoutine: serviceLocator())
          ..add(GetListAppointmentEvent(
            GetListAppointmentParams(
              startTime: getStartOfWeek(_selectedDate).toIso8601String(),
              endTime: getEndOfWeek(_selectedDate).toIso8601String(),
            ),
          )),
        child: BlocConsumer<ListAppointmentBloc, ListAppointmentState>(
          listener: (context, state) {
            if (state is ListAppointmentError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          builder: (context, state) {
            final events = state is ListAppointmentLoaded ? _groupByDay(state.appointments) : {};
            final selectedEvents = events[DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)] ?? [];

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Column(
                    children: [
                      TableCalendar<AppointmentModel>(
                        locale: _lgCode,
                        firstDay: DateTime.utc(2020),
                        lastDay: DateTime.utc(2030),
                        focusedDay: _selectedDate,
                        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                        onDaySelected: (selectedDay, _) {
                          final oldWeekStart = getStartOfWeek(_selectedDate);
                          final newWeekStart = getStartOfWeek(selectedDay);

                          setState(() => _selectedDate = selectedDay);

                          if (!isSameDay(oldWeekStart, newWeekStart)) {
                            context.read<ListAppointmentBloc>().add(
                                  GetListAppointmentEvent(
                                    GetListAppointmentParams(
                                      startTime: getStartOfWeek(selectedDay).toIso8601String(),
                                      endTime: getEndOfWeek(selectedDay).toIso8601String(),
                                    ),
                                  ),
                                );
                          }
                        },
                        onPageChanged: (focusedDay) {
                          final oldWeekStart = getStartOfWeek(_selectedDate);
                          final newWeekStart = getStartOfWeek(focusedDay);

                          // Cập nhật _selectedDate để theo dõi tuần hiện tại
                          setState(() {
                            _selectedDate = focusedDay;
                          });

                          if (!isSameDay(oldWeekStart, newWeekStart)) {
                            context.read<ListAppointmentBloc>().add(
                                  GetListAppointmentEvent(
                                    GetListAppointmentParams(
                                      startTime: getStartOfWeek(focusedDay).toIso8601String(),
                                      endTime: getEndOfWeek(focusedDay).toIso8601String(),
                                    ),
                                  ),
                                );
                          }
                        },
                        eventLoader: (day) {
                          return events[DateTime(day.year, day.month, day.day)] ?? [];
                        },
                        calendarFormat: CalendarFormat.week,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        rowHeight: 52,
                        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: false),
                        calendarStyle: const CalendarStyle(
                          todayDecoration: BoxDecoration(color: TColors.primary, shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                        ),
                        calendarBuilders: CalendarBuilders(
                          dowBuilder: (context, day) {
                            final text = DateFormat.E(_lgCode).format(day);
                            return Center(
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: day.weekday == DateTime.sunday ? Colors.red : Colors.black87,
                                ),
                              ),
                            );
                          },
                          markerBuilder: (context, date, appts) {
                            if (appts.isNotEmpty) {
                              return Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: TColors.primary,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      const SizedBox(height: TSizes.sm),
                      if (state is ListAppointmentLoaded && selectedEvents.isEmpty)
                        Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_appointments_available,
                              style: TextStyle(fontSize: 16, color: TColors.black),
                            ),
                          ),
                        ),
                      if (state is ListAppointmentLoaded)
                        Expanded(
                          child: ListView.separated(
                            itemCount: selectedEvents.length,
                            separatorBuilder: (_, __) => const SizedBox(height: TSizes.sm),
                            itemBuilder: (context, index) {
                              final AppointmentModel appt = selectedEvents[index];
                              var isStaffReal = true;
                              if (appt.staff?.roleId == 3) {
                                isStaffReal = false;
                              }
                              AppLogger.info(appt.staff?.roleId);
                              return GestureDetector(
                                onTap: () => goAppointmentDetail(appt.appointmentId.toString(), false),
                                child: TRoundedContainer(
                                  backgroundColor: (!isStaffReal)
                                      ? TColors.warning.withOpacity(0.8)
                                      : (appt.status.toLowerCase()) == 'completed'
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
                                      if (isStaffReal)
                                        Row(
                                          children: [
                                            const Icon(
                                              Iconsax.clock,
                                              size: 20,
                                            ),
                                            const SizedBox(width: TSizes.sm),
                                            Text(
                                              "${DateFormat('HH:mm', _lgCode).format(appt.appointmentsTime)} - "
                                              "${DateFormat('HH:mm', _lgCode).format(appt.appointmentEndTime)}",
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
                                          : (appt.step != 0)
                                              ? Align(
                                                  alignment: Alignment.centerRight,
                                                  child: appt.status.toLowerCase() == 'cancelled'
                                                      ? null
                                                      : TextButton(
                                                          onPressed: () {},
                                                          child: Text(AppLocalizations.of(context)!.update_staff_from_package,
                                                              style: Theme.of(context).textTheme.labelLarge)),
                                                )
                                              : Align(
                                                  alignment: Alignment.centerRight,
                                                  child: AppointmentData(
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
                                                            AppLogger.info(appt.appointmentsTime);

                                                            goUpdateSpecialist(appt.branch?.branchId ?? 0, controller);
                                                          },
                                                          child: Text(AppLocalizations.of(context)!.choose_specialist,
                                                              style: Theme.of(context).textTheme.labelLarge)),
                                                    ),
                                                  ),
                                                ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                if (state is ListAppointmentLoading) const TLoader(),
              ],
            );
          },
        ),
      ),
    );
  }
}
