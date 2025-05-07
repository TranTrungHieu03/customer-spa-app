import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:iconsax/iconsax.dart";
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spa_mobile/core/common/inherited/mix_data.dart";
import "package:spa_mobile/core/common/widgets/appbar.dart";
import "package:spa_mobile/core/common/widgets/grid_layout.dart";
import "package:spa_mobile/core/common/widgets/loader.dart";
import "package:spa_mobile/core/common/widgets/rounded_container.dart";
import "package:spa_mobile/core/common/widgets/rounded_icon.dart";
import "package:spa_mobile/core/helpers/helper_functions.dart";
import "package:spa_mobile/core/logger/logger.dart";
import "package:spa_mobile/core/utils/constants/colors.dart";
import "package:spa_mobile/core/utils/constants/exports_navigators.dart";
import "package:spa_mobile/core/utils/constants/sizes.dart";
import "package:spa_mobile/features/service/data/model/appointment_model.dart";
import "package:spa_mobile/features/service/data/model/shift_model.dart";
import "package:spa_mobile/features/service/data/model/time_model.dart";
import "package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart";
import "package:spa_mobile/features/service/domain/usecases/get_list_slot_working.dart";
import "package:spa_mobile/features/service/domain/usecases/get_time_slot_by_date.dart";
import "package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart";
import "package:spa_mobile/features/service/presentation/bloc/list_appointment/list_appointment_bloc.dart";
import "package:spa_mobile/features/service/presentation/bloc/list_time/list_time_bloc.dart";
import "package:spa_mobile/features/service/presentation/bloc/staff_slot_working/staff_slot_working_bloc.dart";
import "package:spa_mobile/features/service/presentation/widgets/leave_booking.dart";

class UpdateAppointmentsTimeScreen extends StatefulWidget {
  const UpdateAppointmentsTimeScreen({super.key, required this.staffIds, required this.controller, required this.indexOfAppointment});

  final List<int> staffIds;
  final MixDataController controller;
  final int indexOfAppointment;

  @override
  State<UpdateAppointmentsTimeScreen> createState() => _UpdateAppointmentsTimeScreenState();
}

class _UpdateAppointmentsTimeScreenState extends State<UpdateAppointmentsTimeScreen> {
  List<Map<String, String>> items = [];
  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
  final ScrollController _scrollController = ScrollController();
  String monthView = "";
  String lgCode = "";
  List<int> staffIds = [];
  List<TimeModel> bookedSlots = [];
  List<ShiftModel> availableShifts = [];
  List<AppointmentModel> existAppointment = [];
  List<TimeModel> selectedSlots = [];

  void _scrollToSelectedDate() {
    int index = items.indexWhere((item) => item['date'] == DateFormat('yyyy-MM-dd').format(selectedDate));
    if (index != -1) {
      _scrollController.animateTo(
        index * 50.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        monthView = items[index]['monthName']!;
      });
    }
  }

  List<TimeModel> availableTimeSlots = [];

  void generateAvailableTimeSlots() {
    final workDayStart = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
    final workDayEnd = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 21, 0);

    List<TimeModel> allPossibleSlots = [];
    DateTime currentStart = workDayStart;

    final int durationTime = (widget.indexOfAppointment != -1)
        ? (int.parse(widget.controller.services[widget.indexOfAppointment].duration) + 5)
        : widget.controller.totalDuration;

    while (true) {
      final slotEnd = currentStart.add(Duration(minutes: durationTime));
      if (slotEnd.isAfter(workDayEnd)) break;

      allPossibleSlots.add(TimeModel(startTime: currentStart, endTime: slotEnd));
      currentStart = currentStart.add(const Duration(minutes: 5));
    }

    final now = DateTime.now();

    availableTimeSlots = allPossibleSlots.where((possibleSlot) {
      final isNotBooked = !bookedSlots.any((bookedSlot) => _isOverlapping(possibleSlot, bookedSlot));
      final isInFuture = possibleSlot.startTime.isAfter(now);
      final isNotChoose = widget.indexOfAppointment == -1
          ? true
          : !widget.controller.selectedSlots.any((bookedSlot) => _isOverlapping(possibleSlot, bookedSlot));
      final isInShift = availableShifts.any((shift) {
        final shiftStart = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          int.parse(shift.startTime.split(':')[0]),
          int.parse(shift.startTime.split(':')[1]),
        );

        final shiftEnd = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          int.parse(shift.endTime.split(':')[0]),
          int.parse(shift.endTime.split(':')[1]),
        );

        return possibleSlot.startTime.isAtSameMomentAs(shiftStart) ||
            (possibleSlot.startTime.isAfter(shiftStart) && possibleSlot.endTime.isBefore(shiftEnd));
      });

      final isNotConflictWithAppointments = !existAppointment.any((appointment) {
        return _isOverlappingSlotAndAppointment(possibleSlot, appointment);
      });

      return isNotBooked && isInFuture && isInShift && isNotConflictWithAppointments && isNotChoose;
    }).toList();

    setState(() {});
  }

  bool _isOverlapping(TimeModel slot1, TimeModel slot2) {
    const buffer = Duration(seconds: 1);

    return slot1.startTime.isBefore(slot2.endTime.add(buffer)) && slot1.endTime.isAfter(slot2.startTime.subtract(buffer));
  }

  bool _isOverlappingSlotAndAppointment(TimeModel slot, AppointmentModel appointment) {
    const buffer = Duration(seconds: 1);
    return slot.startTime.isBefore(appointment.appointmentEndTime.add(buffer)) &&
        slot.endTime.isAfter(appointment.appointmentsTime.subtract(buffer));
  }

  DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  @override
  void initState() {
    super.initState();
    staffIds = widget.indexOfAppointment == -1 ? widget.controller.staffIds : [widget.controller.staffIds[widget.indexOfAppointment]];
    _loadLanguageAndInit();
    context
        .read<StaffSlotWorkingBloc>()
        .add(GetStaffSlotWorkingEvent(GetListSlotWorkingParams(staffIds: staffIds, workDate: selectedDate)));
    context.read<ListTimeBloc>().add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: staffIds, date: selectedDate)));
    context.read<ListAppointmentBloc>().add(GetListAppointmentEvent(GetListAppointmentParams(
        startTime: getStartOfDay(selectedDate).toIso8601String(), endTime: getEndOfDay(selectedDate).toIso8601String())));
    generateAvailableTimeSlots();
  }

  Future<void> _loadLanguageAndInit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lgCode = prefs.getString('language_code') ?? "vi";
      _initializeDates();
      monthView = items.isNotEmpty ? items[0]['monthName']! : "";
    });
  }

  void _initializeDates() {
    DateTime now = DateTime.now();
    items.clear();
    for (int i = 0; i < 14; i++) {
      DateTime date = now.add(Duration(days: i));
      items.add({
        'day': DateFormat('EEEE', lgCode).format(date),
        'date': DateFormat('yyyy-MM-dd').format(date),
        'dayNumber': DateFormat('dd').format(date),
        'monthName': DateFormat('MMMM yyyy', lgCode).format(date),
      });
    }
  }

  void _showCalendar(BuildContext context) {
    final staffSlotWorkingBloc = context.read<StaffSlotWorkingBloc>();
    final listAppointmentBloc = context.read<ListAppointmentBloc>();
    final listTimeBloc = context.read<ListTimeBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: staffSlotWorkingBloc),
            BlocProvider.value(value: listAppointmentBloc),
            BlocProvider.value(value: listTimeBloc),
          ],
          child: Padding(
              padding: EdgeInsets.only(
                left: TSizes.md,
                right: TSizes.md,
                top: TSizes.md,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Theme(
                data: ThemeData(
                  colorScheme: const ColorScheme.light(
                    primary: TColors.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 13)),
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                    staffSlotWorkingBloc.add(GetStaffSlotWorkingEvent(GetListSlotWorkingParams(staffIds: staffIds, workDate: date)));

                    listAppointmentBloc.add(GetListAppointmentEvent(GetListAppointmentParams(
                        startTime: getStartOfDay(date).toIso8601String(), endTime: getEndOfDay(date).toIso8601String())));

                    listTimeBloc.add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: staffIds, date: date)));
                    _scrollToSelectedDate();
                  },
                ),
              )),
        );
      },
    );
  }

  void _showModelLeave(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final clearFn = context.read<AppointmentBloc>().add(ClearAppointmentEvent());
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: TLeaveBooking(clearFn: () => clearFn),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final isChooseDiffSpecialist = widget.staffIds.map((x) {
      return x != controller.staffIds[0];
    }).contains(true);
    final isAllAny = widget.staffIds.map((x) {
      return x == 0;
    }).contains(false);

    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<ListAppointmentBloc, ListAppointmentState>(
        listener: (context, state) {
          if (state is ListAppointmentLoaded) {
            existAppointment = state.appointments.where((x) => x.status.toLowerCase() == "pending").toList();
            generateAvailableTimeSlots();
          }
        },
        child: BlocListener<StaffSlotWorkingBloc, StaffSlotWorkingState>(
            listener: (context, slotState) {
              if (slotState is StaffSlotWorkingLoaded) {
                availableShifts = slotState.staffSlotWorking;
                generateAvailableTimeSlots();
              }
              if (slotState is StaffSlotWorkingError) {
                AppLogger.error(slotState.message);
              }
            },
            child: Scaffold(
              appBar: TAppbar(
                showBackArrow: true,
                leadingIcon: Iconsax.arrow_left,
                // leadingOnPressed: () => goUpdateSpecialist(controller.branchId, controller),
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
              body: Padding(
                padding: const EdgeInsets.all(TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        AppLocalizations.of(context)!.select_time,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.sm,
                    ),
                    GestureDetector(
                      // onTap: () => goSelectSpecialist(controller.branchId, controller),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isChooseDiffSpecialist || (widget.indexOfAppointment != -1))
                            TRoundedContainer(
                              radius: TSizes.lg,
                              padding: const EdgeInsets.all(TSizes.sm),
                              child: Row(
                                children: [
                                  TRoundedContainer(
                                    radius: 35,
                                    width: 35,
                                    height: 35,
                                    backgroundColor: TColors.primaryBackground,
                                    child: Center(
                                      child: Text(
                                        THelperFunctions.getFirstLetterOfLastName(
                                          widget.indexOfAppointment == -1
                                              ? widget.controller.staff[0]?.staffInfo?.userName ?? ""
                                              : widget.controller.staff[widget.indexOfAppointment]?.staffInfo?.userName ?? "",
                                        ),
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.primary),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: TSizes.xs),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.3),
                                    child: Text(
                                      widget.indexOfAppointment == -1
                                          ? widget.controller.staff[0]?.staffInfo?.userName ?? ""
                                          : widget.controller.staff[widget.indexOfAppointment]?.staffInfo?.userName ?? "",
                                      style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: TSizes.sm,
                                  ),
                                  const Icon(
                                    Iconsax.arrow_down_1,
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                          if (isChooseDiffSpecialist && widget.indexOfAppointment == -1)
                            TRoundedContainer(
                              radius: TSizes.lg,
                              padding: const EdgeInsets.all(TSizes.sm),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppLocalizations.of(context)!.multiple_specialist, style: Theme.of(context).textTheme.labelLarge),
                                  const SizedBox(
                                    width: TSizes.sm,
                                  ),
                                  Row(
                                    children: List.generate(
                                      min(3, controller.staffIds.length), // Show max 3 items
                                      (index) {
                                        final isAny = controller.staffIds[index] == 0;
                                        return Padding(
                                          padding: EdgeInsets.only(right: index < min(3, controller.staffIds.length) - 1 ? TSizes.xs : 0),
                                          child: TRoundedContainer(
                                            radius: 35,
                                            width: 35,
                                            height: 35,
                                            backgroundColor: TColors.primaryBackground,
                                            child: Center(
                                              child: Text(
                                                THelperFunctions.getFirstLetterOfLastName(
                                                    isAny ? "A" : widget.controller.staff[index]?.staffInfo?.userName ?? ""),
                                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.primary),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: TSizes.xs),
                                  const Icon(
                                    Iconsax.arrow_down_1,
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                          TRoundedIcon(
                            icon: Iconsax.calendar_1,
                            borderRadius: 10,
                            backgroundColor: TColors.primaryBackground,
                            onPressed: () {
                              _showCalendar(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(monthView, style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          bool isSelected = item['date'] == DateFormat('yyyy-MM-dd').format(selectedDate);
                          bool isToday = item['date'] == DateFormat('yyyy-MM-dd').format(DateTime.now());

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = DateTime.parse(item['date']!);
                                context
                                    .read<ListTimeBloc>()
                                    .add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: staffIds, date: selectedDate)));
                                context
                                    .read<StaffSlotWorkingBloc>()
                                    .add(GetStaffSlotWorkingEvent(GetListSlotWorkingParams(staffIds: staffIds, workDate: selectedDate)));
                                context.read<ListAppointmentBloc>().add(GetListAppointmentEvent(GetListAppointmentParams(
                                    startTime: getStartOfDay(selectedDate).toIso8601String(),
                                    endTime: getEndOfDay(selectedDate).toIso8601String())));
                              });

                              _scrollToSelectedDate();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(TSizes.sm),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TRoundedContainer(
                                    padding: const EdgeInsets.all(TSizes.md),
                                    radius: 100,
                                    backgroundColor: (isSelected
                                        ? TColors.primary
                                        : isToday
                                            ? TColors.primary.withOpacity(0.5)
                                            : Colors.grey.shade200),
                                    child: Text(
                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                            color: isSelected || isToday ? Colors.white : Colors.black,
                                          ),
                                      item['dayNumber']!,
                                    ),
                                  ),
                                  const SizedBox(height: TSizes.sm),
                                  Text(
                                    item['day']!,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: BlocListener<ListTimeBloc, ListTimeState>(
                        listener: (context, state) {
                          if (state is ListTimeLoaded) {
                            bookedSlots = state.slots;
                            generateAvailableTimeSlots();
                          }
                        },
                        child: BlocBuilder<ListTimeBloc, ListTimeState>(
                          builder: (context, state) {
                            if (state is ListTimeLoaded) {
                              if (availableTimeSlots.isEmpty) {
                                return Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.no_available_slots,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              }
                              return TGridLayout(
                                itemCount: availableTimeSlots.length,
                                mainAxisExtent: 50,
                                crossAxisCount: 2,
                                isScroll: true,
                                itemBuilder: (context, index) {
                                  final slot = availableTimeSlots[index];
                                  final isSelected = selectedTime == slot.startTime.toString();
                                  return GestureDetector(
                                    onTap: () {
                                      final listTimes = <DateTime>[];

                                      DateTime currentTime = slot.startTime;

                                      if (widget.indexOfAppointment == -1) {
                                        for (int i = 0; i < controller.services.length; i++) {
                                          if (i == 0) {
                                            listTimes.add(currentTime);
                                          }

                                          currentTime = currentTime.add(Duration(minutes: int.parse(controller.services[i].duration) + 5));

                                          if (i < controller.services.length - 1) {
                                            listTimes.add(currentTime);
                                          }
                                        }
                                      }

                                      if (widget.indexOfAppointment == -1) {
                                        controller.updateTimeStart(listTimes);
                                      } else {
                                        controller.updateTimeStartWithIndex(currentTime, widget.indexOfAppointment);
                                      }
                                      AppLogger.wtf(controller.selectedSlots);
                                      if (widget.indexOfAppointment == -1) {
                                        DateTime currentStart = slot.startTime;

                                        for (final service in controller.services) {
                                          final duration = int.parse(service.duration) + 5;
                                          final currentEnd = currentStart.add(Duration(minutes: duration));
                                          AppLogger.wtf(
                                            TimeModel(
                                              startTime: currentStart,
                                              endTime: currentEnd,
                                            ),
                                          );
                                          controller.addSlot(
                                            TimeModel(
                                              startTime: currentStart,
                                              endTime: currentEnd,
                                            ),
                                          );

                                          currentStart = currentEnd;
                                        }
                                      } else {
                                        controller.addSlot(slot);
                                      }
                                      AppLogger.wtf(controller.selectedSlots);
                                      goUpdateStaffMix(controller, controller.branchId, 1);
                                    },
                                    child: TRoundedContainer(
                                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.xs),
                                      backgroundColor: isSelected ? TColors.primaryBackground : Colors.white,
                                      borderColor: isSelected ? TColors.primary : Colors.transparent,
                                      width: double.infinity,
                                      showBorder: true,
                                      shadow: true,
                                      child: Row(
                                        children: [
                                          Text(DateFormat('HH:mm').format(slot.startTime)),
                                          const Text(" - "),
                                          Text(DateFormat('HH:mm').format(slot.endTime))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (state is ListTimeEmpty) {
                              return Center(
                                child: Text(
                                  AppLocalizations.of(context)!.no_available_slots,
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            } else if (state is ListTimeLoading &&
                                context.read<ListAppointmentBloc>().state is ListAppointmentLoading &&
                                context.read<StaffSlotWorkingBloc>().state is StaffSlotWorkingLoading) {
                              return const TLoader();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
