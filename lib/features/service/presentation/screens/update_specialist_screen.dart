import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/leave_booking.dart';

class UpdateSpecialistScreen extends StatefulWidget {
  const UpdateSpecialistScreen({super.key, required this.branchId, required this.controller});

  final int branchId;
  final AppointmentDataController controller;

  @override
  State<UpdateSpecialistScreen> createState() => _UpdateSpecialistScreenState();
}

class _UpdateSpecialistScreenState extends State<UpdateSpecialistScreen> {
  List<int>? selectedStaffIds;
  int? selectedStaffId;
  late List<int> serviceCategoryIds;

  @override
  void initState() {
    serviceCategoryIds = widget.controller.services.map((e) => e.serviceCategoryId).toList();
    AppLogger.info(serviceCategoryIds);
    context
        .read<ListStaffBloc>()
        .add(GetListStaffEvent(params: GetListStaffParams(branchId: widget.branchId, serviceCategoryIds: serviceCategoryIds)));
    selectedStaffIds = widget.controller.staffIds;
    super.initState();
  }

  void _showModelLeave(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final serviceId = controller.serviceIds;
    final isSingleService = serviceId.length == 1;
    final int indexExtra = isSingleService ? 1 : 2;
    final isChooseMultiStaff = serviceId.length > 1 && selectedStaffId == -1;
    final isChooseDiffSpecialist = controller.staffIds.map((x) {
      return x != controller.staffIds[0];
    }).contains(true);
    if (!isChooseMultiStaff) {
      selectedStaffId = controller.staffIds[0];
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: TAppbar(
          showBackArrow: false,
          leadingIcon: Iconsax.arrow_left,
          leadingOnPressed: () {
            goUpdateTime([selectedStaffId ?? 1], controller);
          },
          actions: [
            TRoundedIcon(
              icon: Iconsax.scissor_1,
              onPressed: () => _showModelLeave(context),
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
                  "Select specialist",
                  style: Theme.of(context).textTheme.displaySmall ?? const TextStyle(),
                ),
              ),
              const SizedBox(height: TSizes.md),
              if (!isChooseMultiStaff && !isChooseDiffSpecialist)
                Expanded(
                  child: BlocBuilder<ListStaffBloc, ListStaffState>(
                    builder: (context, state) {
                      if (state is ListStaffLoaded) {
                        return TGridLayout(
                          mainAxisExtent: 150,
                          itemCount: state.intersectionStaff.length + indexExtra,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              final isSelected = selectedStaffId == 0;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStaffId = 0;
                                  });
                                  // controller.updateStaffIds(0);
                                  controller.updateStaffIds(0);
                                  // controller.updateStaff({});
                                  goUpdateTime([0], controller);
                                  // if (selectedStaffId != null) {
                                  //   goUpdateTime(staffIds, controller)([selectedStaffId ?? 0], controller);
                                  // }
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
                                        "Any specialist",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (!isSingleService && index == 1) {
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
                                        "Select specialist per service",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              final staff = state.intersectionStaff[index - indexExtra];

                              final isSelected = selectedStaffId == staff.staffId;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStaffId = staff.staffId;
                                  });

                                  if (staff.staffId != 0) {
                                    controller.updateStaffIds(staff.staffId);
                                    controller.updateStaff(staff);
                                    goUpdateTime([staff.staffId], controller);
                                  }
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
                                ),
                              );
                            }
                          },
                        );
                      } else if (state is ListStaffLoading) {
                        return const TLoader();
                      }
                      return const TErrorBody();
                    },
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    goUpdateTime(controller.staffIds, controller);
                  },
                  child: Text(AppLocalizations.of(context)!.continue_book))
            ],
          ),
        ),
      ),
    );
  }
}
