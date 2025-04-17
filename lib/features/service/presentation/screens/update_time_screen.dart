import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:iconsax/iconsax.dart";
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spa_mobile/core/common/inherited/appointment_data.dart";
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
import "package:spa_mobile/features/service/data/model/shift_model.dart";
import "package:spa_mobile/features/service/data/model/time_model.dart";
import "package:spa_mobile/features/service/domain/usecases/get_list_slot_working.dart";
import "package:spa_mobile/features/service/domain/usecases/get_time_slot_by_date.dart";
import "package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart";
import "package:spa_mobile/features/service/presentation/bloc/list_time/list_time_bloc.dart";
import "package:spa_mobile/features/service/presentation/bloc/staff_slot_working/staff_slot_working_bloc.dart";
import "package:spa_mobile/features/service/presentation/widgets/leave_booking.dart";

class UpdateTimeScreen extends StatefulWidget {
  const UpdateTimeScreen({super.key, required this.staffIds, required this.controller});

  final List<int> staffIds;
  final AppointmentDataController controller;

  @override
  State<UpdateTimeScreen> createState() => _UpdateTimeScreenState();
}

class _UpdateTimeScreenState extends State<UpdateTimeScreen> {
  List<Map<String, String>> items = [];
  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
  final ScrollController _scrollController = ScrollController();
  String monthView = "";
  String lgCode = "";
  List<TimeModel> bookedSlots = [];
  List<ShiftModel> availableShifts = [];

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
    AppLogger.info(widget.controller.totalDuration);

    while (true) {
      final slotEnd = currentStart.add(Duration(minutes: widget.controller.totalDuration));
      if (slotEnd.isAfter(workDayEnd)) break;

      allPossibleSlots.add(TimeModel(startTime: currentStart, endTime: slotEnd));
      currentStart = currentStart.add(const Duration(minutes: 15));
    }

    final now = DateTime.now();

    availableTimeSlots = allPossibleSlots.where((possibleSlot) {
      final isNotBooked = !bookedSlots.any((bookedSlot) => _isOverlapping(possibleSlot, bookedSlot));
      final isInFuture = possibleSlot.startTime.isAfter(now);
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

        return possibleSlot.startTime.isAtSameMomentAs(shiftStart) || // bắt đầu đúng lúc shift
            (possibleSlot.startTime.isAfter(shiftStart) && possibleSlot.endTime.isBefore(shiftEnd));
      });

      return isNotBooked && isInFuture && isInShift;
    }).toList();

    setState(() {});
  }

  bool _isOverlapping(TimeModel slot1, TimeModel slot2) {
    const buffer = Duration(minutes: 5);

    return slot1.startTime.isBefore(slot2.endTime.add(buffer)) && slot1.endTime.isAfter(slot2.startTime.subtract(buffer));
  }

  @override
  void initState() {
    super.initState();
    _loadLanguageAndInit();
    if (widget.staffIds[0] != 0) {}
    context
        .read<StaffSlotWorkingBloc>()
        .add(GetStaffSlotWorkingEvent(GetListSlotWorkingParams(staffIds: widget.staffIds, workDate: selectedDate)));
    context.read<ListTimeBloc>().add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: widget.staffIds, date: selectedDate)));

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
                if (widget.staffIds[0] != 0) {
                  context
                      .read<ListTimeBloc>()
                      .add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: widget.controller.staffIds, date: date)));
                  context
                      .read<StaffSlotWorkingBloc>()
                      .add(GetStaffSlotWorkingEvent(GetListSlotWorkingParams(staffIds: widget.staffIds, workDate: selectedDate)));
                }
                _scrollToSelectedDate();
              },
            ),
          ),
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
    AppLogger.info(controller.staffIds);
    AppLogger.info(isChooseDiffSpecialist);
    return WillPopScope(
      onWillPop: () async => false,
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
            showBackArrow: false,
            leadingIcon: Iconsax.arrow_left,
            leadingOnPressed: () => goUpdateSpecialist(controller.branchId, controller),
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
                    "Select time",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                const SizedBox(
                  height: TSizes.sm,
                ),
                GestureDetector(
                  onTap: () => goSelectSpecialist(controller.branchId, controller),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isChooseDiffSpecialist)
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
                                        !isAllAny ? "Any" : widget.controller.staff[0]?.staffInfo?.userName ?? ""),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: TSizes.xs),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.3),
                                child: Text(
                                  !isAllAny ? "Any Specialist" : widget.controller.staff[0]?.staffInfo?.userName ?? "",
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
                                .add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: controller.staffIds, date: selectedDate)));
                            context
                                .read<StaffSlotWorkingBloc>()
                                .add(GetStaffSlotWorkingEvent(GetListSlotWorkingParams(staffIds: widget.staffIds, workDate: selectedDate)));
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
                            return const Center(
                              child: Text(
                                'No available time slots for selected date',
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
                                  // If user choose different specialist, we don't need to check staff free time
                                  DateTime currentTime = slot.startTime;

                                  for (int i = 0; i < controller.services.length; i++) {
                                    if (i == 0) {
                                      listTimes.add(currentTime);
                                    }

                                    currentTime = currentTime.add(Duration(minutes: int.parse(controller.services[i].duration) + 5));

                                    if (i < controller.services.length - 1) {
                                      listTimes.add(currentTime);
                                    }
                                  }

                                  AppLogger.info(listTimes);
                                  controller.updateTimeStart(listTimes);
                                  setState(() {
                                    selectedTime = slot.startTime.toString();
                                  });
                                  // if (listTimes.length == 1) {
                                  goUpdateReview(controller);
                                  // }
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
                          return const Center(
                            child: Text(
                              'No available time slots for selected date',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        } else if (state is ListTimeLoading) {
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
        ),
      ),
    );
  }
}
