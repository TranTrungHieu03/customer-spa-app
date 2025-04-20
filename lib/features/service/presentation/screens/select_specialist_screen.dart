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
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/leave_booking.dart';

class SelectSpecialistScreen extends StatefulWidget {
  const SelectSpecialistScreen({super.key, required this.branchId, required this.controller});

  final int branchId;
  final AppointmentDataController controller;

  @override
  State<SelectSpecialistScreen> createState() => _SelectSpecialistScreenState();
}

class _SelectSpecialistScreenState extends State<SelectSpecialistScreen> {
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
    final int indexExtra = isSingleService ? 0 : 1;
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
            goSelectTime([selectedStaffId ?? 1], controller);
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
                  AppLocalizations.of(context)!.choose_specialist,
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
                            if (index == 0 && !isSingleService) {
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
                                        AppLocalizations.of(context)!.select_specialist_per_service,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            // else
                            // if (!isSingleService && index == 1) {
                            // final isSelected = selectedStaffId == -1;
                            //
                            // return GestureDetector(
                            //   onTap: () {
                            //     setState(() {
                            //       selectedStaffId = -1;
                            //     });
                            //   },
                            //   child: TRoundedContainer(
                            //     margin: const EdgeInsets.all(TSizes.xs),
                            //     padding: const EdgeInsets.all(TSizes.xs),
                            //     backgroundColor: isSelected ? TColors.primaryBackground : Colors.white,
                            //     borderColor: isSelected ? TColors.primary : Colors.transparent,
                            //     showBorder: true,
                            //     shadow: true,
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         TRoundedContainer(
                            //           radius: 50,
                            //           width: 50,
                            //           height: 50,
                            //           backgroundColor: isSelected ? Colors.white : TColors.primaryBackground,
                            //           child: Center(
                            //             child: Text(
                            //               THelperFunctions.getFirstLetterOfLastName("Any"),
                            //               style: Theme.of(context).textTheme.displaySmall!.copyWith(color: TColors.primary),
                            //             ),
                            //           ),
                            //         ),
                            //         const SizedBox(height: TSizes.xs),
                            //         Text(
                            //           AppLocalizations.of(context)!.select_specialist_per_service,
                            //           style: Theme.of(context).textTheme.bodyMedium,
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // );
                            // }
                            else {
                              final staff = state.intersectionStaff[index - indexExtra];
                              AppLogger.info(state.intersectionStaff[index - indexExtra]);
                              final isSelected = selectedStaffId == staff.staffId;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStaffId = staff.staffId;
                                  });

                                  if (staff.staffId != -1) {
                                    controller.updateStaffIds(staff.staffId);
                                    controller.updateStaff(staff);
                                    goSelectTime([staff.staffId], controller);
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
              if (isChooseMultiStaff || isChooseDiffSpecialist)
                BlocBuilder<ListStaffBloc, ListStaffState>(builder: (context, state) {
                  if (state is ListStaffLoaded) {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final isAny = selectedStaffIds?[index] == -1;
                          final staffs = state.listStaff[index].staffs;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.services[index].name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                height: TSizes.md,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showModelSpecialist(context, controller.services[index],
                                      (context.read<ListStaffBloc>().state as ListStaffLoaded).listStaff[index].staffs, index);
                                },
                                child: TRoundedContainer(
                                  width: THelperFunctions.screenWidth(context) * 0.6,
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
                                                : THelperFunctions.getFirstLetterOfLastName(
                                                    staffs.firstWhere((x) => x.staffId == selectedStaffIds?[index]).staffInfo?.userName ??
                                                        ""),
                                            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: TColors.primary),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: TSizes.sm),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.3),
                                        child: Text(
                                            isAny
                                                ? AppLocalizations.of(context)!.any_specialist
                                                : staffs.firstWhere((x) => x.staffId == selectedStaffIds?[index]).staffInfo?.userName ?? "",
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
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: TSizes.md);
                        },
                        itemCount: controller.serviceIds.length);
                  } else {
                    return const SizedBox();
                  }
                }),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: !widget.controller.staffIds.contains(0)
                      ? () {
                          goSelectTime(controller.staffIds, controller);
                        }
                      : null,
                  child: Text(AppLocalizations.of(context)!.continue_book))
            ],
          ),
        ),
      ),
    );
  }

  void _showModelSpecialist(BuildContext context, ServiceModel service, List<StaffModel> staffs, int indexService) {
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
                      TGridLayout(
                        mainAxisExtent: 150,
                        itemCount: staffs.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          // if (index == 0) {
                          //   final isSelected = widget.controller.staffIds[indexService] == 0;
                          //   return GestureDetector(
                          //     onTap: () {
                          //       setModalState(() {
                          //         selectedStaffIds?[indexService] = 0;
                          //       });
                          //       setState(() {
                          //         selectedStaffIds?[indexService] = 0;
                          //       });
                          //       widget.controller.addStaffId(indexService, 0);
                          //       Navigator.pop(context);
                          //     },
                          //     child: TRoundedContainer(
                          //       margin: const EdgeInsets.all(TSizes.xs),
                          //       padding: const EdgeInsets.all(TSizes.xs),
                          //       backgroundColor: isSelected ? TColors.primaryBackground : Colors.white,
                          //       borderColor: isSelected ? TColors.primary : Colors.transparent,
                          //       showBorder: true,
                          //       shadow: true,
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           TRoundedContainer(
                          //             radius: 50,
                          //             width: 50,
                          //             height: 50,
                          //             backgroundColor: isSelected ? Colors.white : TColors.primaryBackground,
                          //             child: Center(
                          //               child: Text(
                          //                 THelperFunctions.getFirstLetterOfLastName("Any"),
                          //                 style: Theme.of(context).textTheme.displaySmall!.copyWith(color: TColors.primary),
                          //               ),
                          //             ),
                          //           ),
                          //           const SizedBox(height: TSizes.xs),
                          //           Text(
                          //             AppLocalizations.of(context)!.any_specialist,
                          //             style: Theme.of(context).textTheme.bodyMedium,
                          //             textAlign: TextAlign.center,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   );
                          // } else {
                          final staff = staffs[index];
                          final isSelected = widget.controller.staffIds[indexService] == staff.staffId;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedStaffIds?[indexService] = staff.staffId;
                              });
                              setState(() {
                                selectedStaffIds?[indexService] = staff.staffId;
                              });
                              widget.controller.addStaffId(indexService, staff.staffId);
                              widget.controller.addStaff(indexService, staff);
                              Navigator.pop(context);
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
                          // }
                        },
                      ),
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
}
