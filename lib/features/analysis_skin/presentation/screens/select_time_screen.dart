import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/inherited/routine_data.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/data/model/time_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SelectRoutineTimeScreen extends StatefulWidget {
  const SelectRoutineTimeScreen({super.key, required this.controller});

  final RoutineDataController controller;

  @override
  State<SelectRoutineTimeScreen> createState() => _SelectRoutineTimeScreenState();
}

class _SelectRoutineTimeScreenState extends State<SelectRoutineTimeScreen> {
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

  void generateAvailableTimeSlots() {
    final workDayStart = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
    final workDayEnd = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 21, 0);

    List<TimeModel> allPossibleSlots = [];
    DateTime currentStart = workDayStart;

    while (true) {
      final slotEnd = currentStart.add(const Duration(minutes: 60));
      //
      if (slotEnd.isAfter(workDayEnd)) break;
      //
      allPossibleSlots.add(TimeModel(startTime: currentStart, endTime: slotEnd));

      currentStart = currentStart.add(const Duration(minutes: 15));
    }
    final now = DateTime.now();

    availableTimeSlots = allPossibleSlots.where((possibleSlot) {
      final isNotBooked = !bookedSlots.any((bookedSlot) => _isOverlapping(possibleSlot, bookedSlot));
      final isInFuture = possibleSlot.startTime.isAfter(now);
      return isNotBooked && isInFuture;
    }).toList();

    setState(() {});
  }

  bool _isOverlapping(TimeModel slot1, TimeModel slot2) {
    return slot1.startTime.isBefore(slot2.endTime) && slot1.endTime.isAfter(slot2.startTime);
  }

  List<TimeModel> availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _loadLanguageAndInit();

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

                _scrollToSelectedDate();
              },
            ),
          ),
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
          showBackArrow: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(monthView, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
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
                        });
                        generateAvailableTimeSlots();
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
                  child: TGridLayout(
                itemCount: availableTimeSlots.length,
                mainAxisExtent: 50,
                crossAxisCount: 2,
                isScroll: true,
                itemBuilder: (context, index) {
                  final slot = availableTimeSlots[index];
                  final isSelected = selectedTime == slot.startTime.toString();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = slot.startTime.toString();
                      });
                      widget.controller.updateTime(slot.startTime.toString());
                      goCheckoutRoutine(widget.controller);
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
                          // const Text(" - "),
                          // Text(DateFormat('HH:mm').format(slot.endTime))
                        ],
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(TSizes.sm),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       ElevatedButton(
        //           onPressed: () {
        //             goCheckoutRoutine(
        //               widget.routineModel,
        //                selectedTime
        //             );
        //           },
        //           child: Text(AppLocalizations.of(context)!.continue_book))
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
