import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/leave_booking.dart';

class SelectSpecialistScreen extends StatefulWidget {
  const SelectSpecialistScreen({super.key, required this.branch});

  final BranchModel branch;

  @override
  State<SelectSpecialistScreen> createState() => _SelectSpecialistScreenState();
}

class _SelectSpecialistScreenState extends State<SelectSpecialistScreen> {
  int? selectedStaffId;

  @override
  void initState() {
    context.read<ListStaffBloc>().add(GetListStaffEvent(id: widget.branch.branchId));
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

        return  FractionallySizedBox(
          heightFactor: 0.5,
          child: TLeaveBooking( clearFn: () => context.read<AppointmentBloc>().add(ClearAppointmentEvent())),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: false,
        leadingIcon: Iconsax.arrow_left,
        leadingOnPressed: () {
          goSelectTime([selectedStaffId ?? 1], widget.branch );
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
            Expanded(
              child: BlocBuilder<ListStaffBloc, ListStaffState>(
                builder: (context, state) {
                  if (state is ListStaffLoaded) {
                    return BlocBuilder<AppointmentBloc, AppointmentState>(
                      builder: (context, stateAppointment) {
                       if (stateAppointment is AppointmentCreateData && stateAppointment.params.staffId.isNotEmpty){
                         return TGridLayout(
                           mainAxisExtent: 150,
                           itemCount: state.listStaff.length,
                           crossAxisCount: 2,
                           itemBuilder: (context, index) {
                             final staff = state.listStaff[index];
                             final isSelected = stateAppointment.params.staffId[0]  == staff.staffId;

                             return GestureDetector(
                               onTap: () {
                                 setState(() {
                                   selectedStaffId = staff.staffId;
                                 });

                                 if (selectedStaffId != null) {
                                   context.read<AppointmentBloc>().add(UpdateCreateStaffIdEvent(staffId: [selectedStaffId ?? 1]));
                                   goSelectTime([selectedStaffId ?? 1], widget.branch );
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
                                           THelperFunctions.getFirstLetterOfLastName(staff.staffInfo.userName),
                                           style: Theme.of(context).textTheme.displaySmall!.copyWith(color: TColors.primary),
                                         ),
                                       ),
                                     ),
                                     const SizedBox(height: TSizes.xs),
                                     Text(
                                       staff.staffInfo.userName ?? "",
                                       style: Theme.of(context).textTheme.bodyMedium,
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           },
                         );
                       }
                       return TGridLayout(
                         mainAxisExtent: 150,
                         itemCount: state.listStaff.length,
                         crossAxisCount: 2,
                         itemBuilder: (context, index) {
                           final staff = state.listStaff[index];
                           final isSelected = selectedStaffId == staff.staffId;

                           return GestureDetector(
                             onTap: () {
                               setState(() {
                                 selectedStaffId = staff.staffId;
                               });

                               if (selectedStaffId != null) {
                                 context.read<AppointmentBloc>().add(UpdateCreateStaffIdEvent(staffId: [selectedStaffId ?? 1]));
                                 goSelectTime([selectedStaffId ?? 1], widget.branch);
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
                                         THelperFunctions.getFirstLetterOfLastName(staff.staffInfo.userName),
                                         style: Theme.of(context).textTheme.displaySmall!.copyWith(color: TColors.primary),
                                       ),
                                     ),
                                   ),
                                   const SizedBox(height: TSizes.xs),
                                   Text(
                                     staff.staffInfo.userName ?? "",
                                     style: Theme.of(context).textTheme.bodyMedium,
                                   ),
                                 ],
                               ),
                             ),
                           );
                         },
                       );
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
    );
  }
}
