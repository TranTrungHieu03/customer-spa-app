import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/inherited/appointment_data.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/date_time.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/leave_booking.dart';

class SelectSpecialistScreen extends StatefulWidget {
  const SelectSpecialistScreen({super.key, required this.branchId, required this.controller, required this.isBack});

  final int branchId;
  final AppointmentDataController controller;
  final int isBack;

  @override
  State<SelectSpecialistScreen> createState() => _SelectSpecialistScreenState();
}

class _SelectSpecialistScreenState extends State<SelectSpecialistScreen> {
  List<int>? selectedStaffIds;
  int? selectedStaffId;
  late List<int> serviceCategoryIds;
  late int _currentIsBack;

  @override
  void initState() {
    super.initState();
    _currentIsBack = widget.isBack;
    AppLogger.wtf('InitState: isBack = ${widget.isBack}');
    serviceCategoryIds = widget.controller.services.map((e) => e.serviceCategoryId).toList();
    if (widget.isBack == 0) {
      context
          .read<ListStaffBloc>()
          .add(GetListStaffEvent(params: GetListStaffParams(branchId: widget.branchId, serviceCategoryIds: serviceCategoryIds)));
    }

    selectedStaffIds = widget.controller.staffIds;
  }

  void _showLeaveBookingModal(BuildContext context) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: TLeaveBooking(clearFn: () => context.read<AppointmentBloc>().add(ClearAppointmentEvent())),
        );
      },
    );
  }

  void _goToSelectTime(List<int> staffIds, AppointmentDataController controller, int serviceIndex) {
    goSelectTime(staffIds, controller, serviceIndex);
  }

  void _goToReview(AppointmentDataController controller) {
    goReview(controller);
  }

  void _showSpecialistSelectionModal(BuildContext context, ServiceModel service, List<StaffModel> staffs, int serviceIndex) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.95,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TRoundedIcon(
                            icon: Iconsax.scissor_1,
                            size: 28,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      Text(
                        service.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: TSizes.md),
                      _buildSpecialistsGrid(staffs, serviceIndex, setModalState),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSpecialistsGrid(List<StaffModel> staffs, int serviceIndex, StateSetter setModalState) {
    return TGridLayout(
      mainAxisExtent: 150,
      itemCount: staffs.length,
      crossAxisCount: 2,
      itemBuilder: (context, index) {
        final staff = staffs[index];
        final oldSpec = widget.controller.staffIds[serviceIndex];
        final isSelected = widget.controller.staffIds.isNotEmpty &&
            serviceIndex < widget.controller.staffIds.length &&
            widget.controller.staffIds[serviceIndex] == staff.staffId;

        return GestureDetector(
          onTap: () {
            setModalState(() {
              if (selectedStaffIds != null && serviceIndex < selectedStaffIds!.length) {
                selectedStaffIds![serviceIndex] = staff.staffId;
              }
            });

            setState(() {
              if (selectedStaffIds != null && serviceIndex < selectedStaffIds!.length) {
                selectedStaffIds![serviceIndex] = staff.staffId;
              }
            });
            if (oldSpec != staff.staffId) {
              widget.controller.addStaffId(serviceIndex, staff.staffId);
              widget.controller.addStaff(serviceIndex, staff);
              widget.controller.updateTimeStartWithIndex(kDefaultDateTime, serviceIndex);
              widget.controller.removeSlot(widget.controller.timeStart[serviceIndex]);
            }

            Navigator.pop(context);
          },
          child: SpecialistCard(
            staff: staff,
            isSelected: isSelected,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final serviceIds = controller.serviceIds;
    final isSingleService = serviceIds.length == 1;
    final int indexExtra = isSingleService ? 0 : 1;
    final isChooseMultiStaff = serviceIds.length > 1 && selectedStaffId == -1;

    final isChooseDiffSpecialist =
        controller.staffIds.isNotEmpty && controller.staffIds.length > 1 && controller.staffIds.any((id) => id != controller.staffIds[0]);

    if (!isChooseMultiStaff && controller.staffIds.isNotEmpty) {
      selectedStaffId = controller.staffIds[0];
    }

    return PopScope(
      canPop: false,
      child: BlocListener<ListStaffBloc, ListStaffState>(
        listenWhen: (previous, current) {
          bool shouldListen = previous is! ListStaffLoaded && current is ListStaffLoaded;

          return shouldListen;
        },
        listener: (context, state) {
          if (state is ListStaffLoaded) {
            AppLogger.wtf('Widget isBack value in listener: $_currentIsBack');
            // Use the tracking variable instead of widget.isBack directly
            if (_currentIsBack == 0) {
              _handleStaffLoaded(state, controller, isChooseMultiStaff);
            }
          }
        },
        child: Scaffold(
          appBar: TAppbar(
            showBackArrow: false,
            leadingIcon: Iconsax.arrow_left,
            leadingOnPressed: () {
              if (selectedStaffId != null) {
                _goToSelectTime([selectedStaffId!], controller, -1);
              }
            },
            actions: [
              TRoundedIcon(
                icon: Iconsax.scissor_1,
                onPressed: () => _showLeaveBookingModal(context),
              ),
              const SizedBox(width: TSizes.md),
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
                    AppLocalizations.of(context)?.choose_specialist ?? 'Choose specialist',
                    style: Theme.of(context).textTheme.displaySmall ?? const TextStyle(),
                  ),
                ),
                const SizedBox(height: TSizes.md),
                if (!isChooseMultiStaff && !isChooseDiffSpecialist && widget.isBack == 0)
                  _buildSingleSpecialistSection(controller, indexExtra),
                if (isChooseMultiStaff || isChooseDiffSpecialist || widget.isBack != 0) _buildMultiSpecialistSection(controller),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(controller),
        ),
      ),
    );
  }

  void _handleStaffLoaded(ListStaffLoaded state, AppointmentDataController controller, bool isChooseMultiStaff) {
    if (state.intersectionStaff.isNotEmpty) {
      controller.updateStaff(state.intersectionStaff.first);
      controller.updateStaffIds(state.intersectionStaff.first.staffId);

      if (controller.staffIds.isNotEmpty && !isChooseMultiStaff) {
        selectedStaffId = controller.staffIds[0];
      }

      selectedStaffIds = controller.staffIds;
    } else {
      controller.staffIds.asMap().forEach((index, id) {
        if (state.listStaff.isNotEmpty && index < state.listStaff.length && state.listStaff[index].staffs.isNotEmpty) {
          controller.addStaff(index, state.listStaff[index].staffs[0]);
          controller.addStaffId(index, state.listStaff[index].staffs[0].staffId);
        }
      });

      if (controller.staffIds.isNotEmpty && !isChooseMultiStaff) {
        selectedStaffId = controller.staffIds[0];
      }

      selectedStaffIds = controller.staffIds;
    }
  }

  Widget _buildBottomNavBar(AppointmentDataController controller) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: (!controller.staffIds.contains(-1) && !controller.timeStart.contains(kDefaultDateTime))
                ? () => _goToReview(controller)
                : null,
            child: Text(AppLocalizations.of(context)?.continue_book ?? 'Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleSpecialistSection(AppointmentDataController controller, int indexExtra) {
    return Expanded(
      child: BlocBuilder<ListStaffBloc, ListStaffState>(
        builder: (context, state) {
          if (state is ListStaffLoaded) {
            return TGridLayout(
              mainAxisExtent: 150,
              itemCount: state.intersectionStaff.length + indexExtra,
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                if (index == 0 && indexExtra == 1) {
                  return _buildAnySpecialistCard(context);
                } else {
                  final adjustedIndex = index - indexExtra;
                  if (adjustedIndex >= 0 && adjustedIndex < state.intersectionStaff.length) {
                    final staff = state.intersectionStaff[adjustedIndex];
                    return _buildSpecialistCard(staff, controller);
                  } else {}
                }
              },
            );
          } else if (state is ListStaffLoading) {
            return const TLoader();
          }
          return const TErrorBody();
        },
      ),
    );
  }

  Widget _buildAnySpecialistCard(BuildContext context) {
    final isSelected = selectedStaffId == -1;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStaffId = -1;
        });
      },
      child: TRoundedContainer(
        margin: const EdgeInsets.all(TSizes.xs),
        padding: const EdgeInsets.all(TSizes.xs),
        backgroundColor: isSelected ? TColors.primaryBackground : Colors.white,
        borderColor: isSelected ? TColors.primary : Colors.transparent,
        showBorder: true,
        shadow: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedContainer(
              radius: 50,
              width: 50,
              height: 50,
              backgroundColor: isSelected ? Colors.white : TColors.primaryBackground,
              child: Center(
                child: Text(
                  THelperFunctions.getFirstLetterOfLastName("Any"),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(color: TColors.primary),
                ),
              ),
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              AppLocalizations.of(context)?.select_specialist_per_service ?? 'Select specialist per service',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistCard(StaffModel staff, AppointmentDataController controller) {
    final isSelected = selectedStaffId == staff.staffId;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStaffId = staff.staffId;
        });

        if (staff.staffId != -1) {
          controller.updateStaffIds(staff.staffId);
          controller.updateStaff(staff);
          _goToSelectTime(controller.staffIds, controller, -1);
        }
      },
      child: SpecialistCard(
        staff: staff,
        isSelected: isSelected,
      ),
    );
  }

  Widget _buildMultiSpecialistSection(AppointmentDataController controller) {
    return BlocBuilder<ListStaffBloc, ListStaffState>(
      builder: (context, state) {
        if (state is ListStaffLoaded) {
          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index >= controller.services.length || index >= state.listStaff.length || index >= controller.staffIds.length) {
                    return const SizedBox();
                  }

                  final isAny = selectedStaffIds != null && index < selectedStaffIds!.length && selectedStaffIds![index] == -1;

                  final staffs = state.listStaff[index].staffs;

                  return _buildServiceSpecialistItem(context, controller, index, isAny, staffs);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: TSizes.md);
                },
                itemCount: controller.serviceIds.length,
              ),
              state.intersectionStaff.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        controller.clearSlot();
                        controller.updateStaffIds(-1);
                        goSelectSpecialist(controller.branchId, controller, 0);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chọn một nhân viên cho toàn bộ dịch vụ.",
                            style: Theme.of(context)!.textTheme.bodyLarge,
                          ),
                          const Icon(Iconsax.arrow_right_1)
                        ],
                      ),
                    )
                  : const SizedBox()
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildServiceSpecialistItem(
      BuildContext context, AppointmentDataController controller, int index, bool isAny, List<StaffModel> staffs) {
    StaffModel? selectedStaff;
    if (!isAny && selectedStaffIds != null && index < selectedStaffIds!.length && index < staffs.length) {
      selectedStaff = staffs.firstWhere(
        (x) => x.staffId == selectedStaffIds![index],
        orElse: () => staffs.first,
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.services[index].name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: TSizes.md),
        GestureDetector(
          onTap: () {
            _showSpecialistSelectionModal(context, controller.services[index], staffs, index);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TRoundedContainer(
                width: screenWidth * 0.6,
                radius: TSizes.lg,
                padding: const EdgeInsets.all(TSizes.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TRoundedContainer(
                      radius: 35,
                      width: 35,
                      height: 35,
                      backgroundColor: TColors.primaryBackground,
                      child: Center(
                        child: Text(
                          isAny
                              ? THelperFunctions.getFirstLetterOfLastName("A")
                              : THelperFunctions.getFirstLetterOfLastName(selectedStaff?.staffInfo?.userName ?? ""),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: TColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: screenWidth * 0.3),
                      child: Text(
                          isAny
                              ? AppLocalizations.of(context)?.any_specialist ?? 'Any specialist'
                              : selectedStaff?.staffInfo?.userName ?? "",
                          style: Theme.of(context).textTheme.labelLarge,
                          textAlign: TextAlign.center),
                    ),
                    const Spacer(),
                    const Icon(
                      Iconsax.arrow_down_1,
                      size: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(height: TSizes.sm),
              _buildTimeSelectionWidget(controller, index),
            ],
          ),
        ),
        const SizedBox(
          height: TSizes.lg,
        ),
      ],
    );
  }

  Widget _buildTimeSelectionWidget(AppointmentDataController controller, int index) {
    final isDefaultTime = controller.timeStart.length > index && controller.timeStart[index].isAtSameMomentAs(kDefaultDateTime);

    return Align(
      alignment: Alignment.centerRight,
      child: isDefaultTime
          ? TextButton(
              onPressed: () {
                _goToSelectTime([controller.staffIds[index]], controller, index);
              },
              child: Text('Choose time'),
            )
          : GestureDetector(
              onTap: () {
                AppLogger.wtf(controller.selectedSlots);
                controller.removeSlot(controller.timeStart[index]);
                AppLogger.wtf(controller.selectedSlots);
                _goToSelectTime([controller.staffIds[index]], controller, index);
              },
              child: Text(
                _formatAppointmentTime(controller, index),
              ),
            ),
    );
  }

  String _formatAppointmentTime(AppointmentDataController controller, int index) {
    if (controller.timeStart.length <= index || controller.services.length <= index) {
      return '';
    }

    final startTime = controller.timeStart[index];
    final duration = int.tryParse(controller.services[index].duration) ?? 30;
    final endTime = startTime.add(Duration(minutes: duration + 5));

    return '${DateFormat('HH:mm', "vi").format(startTime)} - '
        '${DateFormat('HH:mm, dd MMMM yyyy', "vi").format(endTime)}';
  }
}

class SpecialistCard extends StatelessWidget {
  final StaffModel staff;
  final bool isSelected;

  const SpecialistCard({
    super.key,
    required this.staff,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      margin: const EdgeInsets.all(TSizes.xs),
      padding: const EdgeInsets.all(TSizes.xs),
      backgroundColor: isSelected ? TColors.primaryBackground : Colors.white,
      borderColor: isSelected ? TColors.primary : Colors.transparent,
      showBorder: true,
      shadow: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TRoundedContainer(
            radius: 50,
            width: 50,
            height: 50,
            backgroundColor: isSelected ? Colors.white : TColors.primaryBackground,
            child: Center(
              child: Text(
                THelperFunctions.getFirstLetterOfLastName(staff.staffInfo?.userName ?? ""),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: TColors.primary),
              ),
            ),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            staff.staffInfo?.userName ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
