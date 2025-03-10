import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:iconsax/iconsax.dart";
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spa_mobile/core/common/model/branch_model.dart";
import "package:spa_mobile/core/common/widgets/appbar.dart";
import "package:spa_mobile/core/common/widgets/grid_layout.dart";
import "package:spa_mobile/core/common/widgets/loader.dart";
import "package:spa_mobile/core/common/widgets/rounded_container.dart";
import "package:spa_mobile/core/common/widgets/rounded_icon.dart";
import "package:spa_mobile/core/common/widgets/shimmer.dart";
import "package:spa_mobile/core/helpers/helper_functions.dart";
import "package:spa_mobile/core/logger/logger.dart";
import "package:spa_mobile/core/utils/constants/colors.dart";
import "package:spa_mobile/core/utils/constants/exports_navigators.dart";
import "package:spa_mobile/core/utils/constants/sizes.dart";
import "package:spa_mobile/features/service/data/model/time_model.dart";
import "package:spa_mobile/features/service/domain/usecases/get_single_staff.dart";
import "package:spa_mobile/features/service/domain/usecases/get_staff_free_in_time.dart";
import "package:spa_mobile/features/service/domain/usecases/get_time_slot_by_date.dart";
import "package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart";
import "package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart";
import "package:spa_mobile/features/service/presentation/bloc/list_time/list_time_bloc.dart";
import "package:spa_mobile/features/service/presentation/bloc/staff/staff_bloc.dart";
import "package:spa_mobile/features/service/presentation/widgets/leave_booking.dart";

class SelectTimeScreen extends StatefulWidget {
  const SelectTimeScreen({super.key, required this.staffId, required this.branch, required this.totalTime, required this.serviceId});

  final List<int> staffId;
  final BranchModel branch;
  final int totalTime;
  final List<int> serviceId;

  @override
  State<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  List<Map<String, String>> items = [];
  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
  final ScrollController _scrollController = ScrollController();
  String monthView = "";
  String lgCode = "";
  List<TimeModel> bookedSlots = [];

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
    AppLogger.info(bookedSlots.map((slot) => slot.toJson()).toList());

    final workDayStart = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
    final workDayEnd = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 21, 0);

    List<TimeModel> allPossibleSlots = [];
    DateTime currentStart = workDayStart;

    while (true) {
      final slotEnd = currentStart.add(Duration(minutes: widget.totalTime));

      if (slotEnd.isAfter(workDayEnd)) break;

      allPossibleSlots.add(TimeModel(startTime: currentStart, endTime: slotEnd));

      currentStart = currentStart.add(const Duration(minutes: 15));
    }

    availableTimeSlots = allPossibleSlots.where((possibleSlot) {
      return !bookedSlots.any((bookedSlot) => _isOverlapping(possibleSlot, bookedSlot));
    }).toList();

    setState(() {});
  }

  bool _isOverlapping(TimeModel slot1, TimeModel slot2) {
    return slot1.startTime.isBefore(slot2.endTime) && slot1.endTime.isAfter(slot2.startTime);
  }

  @override
  void initState() {
    super.initState();
    _loadLanguageAndInit();
    if (widget.staffId[0] != 0) {
      context.read<StaffBloc>().add(GetStaffInfoEvent(GetSingleStaffParams(staffId: widget.staffId[0])));
    }
    context.read<ListTimeBloc>().add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: widget.staffId[0], date: selectedDate)));

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
                if (widget.staffId[0] != 0) {
                  context.read<ListTimeBloc>().add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: widget.staffId[0], date: date)));
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: TAppbar(
          showBackArrow: false,
          leadingIcon: Iconsax.arrow_left,
          leadingOnPressed: () => goSelectSpecialist(widget.branch, widget.totalTime, widget.serviceId),
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
                onTap: () => goSelectSpecialist(widget.branch, widget.totalTime, widget.serviceId),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<StaffBloc, StaffState>(
                      builder: (context, state) {
                        if (state is StaffLoaded) {
                          final staff = state.staff;
                          // final staffs = state.listStaff;
                          // if (staffs.length == 1) {
                          if (widget.staffId[0] == 0) {
                            return TRoundedContainer(
                              radius: TSizes.lg,
                              padding: const EdgeInsets.all(TSizes.sm),
                              child: Row(
                                children: [
                                  Text("Any specialist", style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(
                                    width: TSizes.sm,
                                  ),
                                  const Icon(
                                    Iconsax.arrow_down_1,
                                    size: 15,
                                  )
                                ],
                              ),
                            );
                          }
                          return TRoundedContainer(
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
                                      THelperFunctions.getFirstLetterOfLastName(staff.staffInfo?.userName ?? ""),
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.primary),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: TSizes.xs),
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.3),
                                  child: Text(
                                    staff.staffInfo?.fullName ?? "",
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                                const SizedBox(
                                  width: TSizes.xs,
                                ),
                                const Icon(
                                  Iconsax.arrow_down_1,
                                  size: 15,
                                )
                              ],
                            ),
                          );
                          // }
                          // else if (staffs.length > 1) {
                          //     AppLogger.debug("Length !=1");
                          //     return TRoundedContainer(
                          //       radius: TSizes.lg,
                          //       height: 50,
                          //       padding: const EdgeInsets.all(TSizes.sm),
                          //       child: Row(
                          //         children: [
                          //           SizedBox(
                          //             height: 50,
                          //             child: ListView.builder(
                          //               shrinkWrap: true,
                          //               scrollDirection: Axis.horizontal,
                          //               itemCount: state.listStaff.length,
                          //               itemBuilder: (context, index) {
                          //                 final staff = state.listStaff[index];
                          //                 return TRoundedContainer(
                          //                   radius: 35,
                          //                   width: 35,
                          //                   height: 35,
                          //                   backgroundColor: TColors.primaryBackground,
                          //                   child: Center(
                          //                     child: Text(
                          //                       THelperFunctions.getFirstLetterOfLastName(staff.staffInfo.userName),
                          //                       style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.primary),
                          //                     ),
                          //                   ),
                          //                 );
                          //               },
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: TSizes.sm,
                          //           ),
                          //           ConstrainedBox(
                          //             constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.3),
                          //             child: Text(
                          //               "Multi specialists",
                          //               style: Theme.of(context).textTheme.labelMedium,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: TSizes.xs,
                          //           ),
                          //           const Icon(
                          //             Iconsax.arrow_down_1,
                          //             size: 15,
                          //           )
                          //         ],
                          //       ),
                          //     );
                          //   }
                          //   return const SizedBox.shrink();
                        } else if (state is StaffLoading) {
                          return const TShimmerEffect(width: TSizes.shimmerXl, height: TSizes.shimmerSm);
                        }
                        return TRoundedContainer(
                          radius: TSizes.lg,
                          padding: const EdgeInsets.all(TSizes.sm),
                          child: Row(
                            children: [
                              Text("Any specialist", style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(
                                width: TSizes.sm,
                              ),
                              const Icon(
                                Iconsax.arrow_down_1,
                                size: 15,
                              )
                            ],
                          ),
                        );
                      },
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
                              .add(GetListTimeByDateEvent(GetTimeSlotByDateParams(staffId: widget.staffId[0], date: selectedDate)));
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
                            return GestureDetector(
                              onTap: () {
                                context.read<AppointmentBloc>().add(UpdateCreateTimeEvent(appointmentTime: slot.startTime));

                                if (widget.staffId.contains(0)) {
                                  context.read<ListStaffBloc>().add(GetStaffFreeInTimeEvent(
                                      params: GetStaffFreeInTimeParams(
                                          branchId: widget.branch.branchId,
                                          serviceId: widget.serviceId.first,
                                          startTime: slot.startTime.toString())));
                                }

                                goReview(widget.staffId, widget.branch, widget.totalTime, widget.serviceId);
                              },
                              child: TRoundedContainer(
                                padding: const EdgeInsets.all(TSizes.md),
                                width: double.infinity,
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
    );
  }
}
