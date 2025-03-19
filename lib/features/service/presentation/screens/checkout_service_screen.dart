// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:spa_mobile/core/common/model/branch_model.dart';
// import 'package:spa_mobile/core/common/widgets/appbar.dart';
// import 'package:spa_mobile/core/common/widgets/loader.dart';
// import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
// import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
// import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
// import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
// import 'package:spa_mobile/core/helpers/helper_functions.dart';
// import 'package:spa_mobile/core/local_storage/local_storage.dart';
// import 'package:spa_mobile/core/logger/logger.dart';
// import 'package:spa_mobile/core/utils/constants/colors.dart';
// import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
// import 'package:spa_mobile/core/utils/constants/images.dart';
// import 'package:spa_mobile/core/utils/constants/sizes.dart';
// import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
// import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
// import 'package:spa_mobile/features/service/data/model/service_model.dart';
// import 'package:spa_mobile/features/service/data/model/staff_model.dart';
// import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
// import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
// import 'package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart';
// import 'package:spa_mobile/features/service/presentation/widgets/payment_detail_service.dart';
//
// class CheckoutServiceScreen extends StatefulWidget {
//   const CheckoutServiceScreen({super.key, required this.services});
//
//   final List<ServiceModel> services;
//
//   @override
//   State<CheckoutServiceScreen> createState() => _CheckoutServiceScreenState();
// }
//
// class _CheckoutServiceScreenState extends State<CheckoutServiceScreen> {
//   int? selectedBranch;
//   BranchModel? branchInfo;
//   int? selectedStaffId;
//   StaffModel? staffInfo;
//   bool isLoading = true;
//   bool isValidate = false;
//   List<int> staffList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     staffList = List.filled(widget.services.length, 0);
//   }
//
//   Future<void> _initializeData() async {
//     final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
//     if (int.parse(branchId) == 0) {
//       TSnackBar.warningSnackBar(context, message: "Vui lòng chọn chi nhánh để tiếp tục.");
//     } else {
//       setState(() {
//         selectedBranch = int.parse(branchId);
//       });
//     }
//
//     if (selectedBranch != 0) {
//       context.read<ListBranchesBloc>().add(GetListBranchesEvent());
//
//       branchInfo = BranchModel.fromJson(json.decode(await LocalStorage.getData(LocalStorageKey.branchInfo)));
//     } else {
//       TSnackBar.warningSnackBar(context, message: "Vui lòng chọn chi nhánh để tiếp tục.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final services = widget.services;
//     // List<int> servicesList = services.map((e) => e.serviceId).toList();
//     //
//     double total = services.fold(0, (previousValue, element) => previousValue + element.price);
//     //
//     // DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
//     //
//     // TimeOfDay selectedTime = TimeOfDay.now();
//
//     return BlocConsumer<AppointmentBloc, AppointmentState>(
//       listener: (context, state) {
//         if (state is AppointmentError) {
//           TSnackBar.errorSnackBar(context, message: state.message);
//         }
//         // if (state is AppointmentCreateSuccess) {
//         //   // goWebView("https://www.youtube.com");
//         // }
//       },
//       builder: (context, state) {
//         return Scaffold(
//             appBar: TAppbar(
//               showBackArrow: true,
//               title: Text(
//                 "Appointment's detail",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//             body: Stack(
//               children: [
//                 SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(TSizes.sm),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           BlocConsumer<ListBranchesBloc, ListBranchesState>(
//                             listener: (context, state) {
//                               if (state is ListBranchesError) {
//                                 TSnackBar.errorSnackBar(context, message: state.message);
//                               }
//                             },
//                             builder: (context, state) {
//                               if (state is ListBranchesLoaded) {
//                                 return TRoundedContainer(
//                                   padding: const EdgeInsets.all(TSizes.sm),
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Branch",
//                                         style: Theme.of(context).textTheme.titleLarge,
//                                       ),
//                                       const SizedBox(
//                                         width: TSizes.sm,
//                                       ),
//                                       Expanded(
//                                           child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             branchInfo?.branchName ?? "Vui lòng chọn chi nhánh",
//                                             style: Theme.of(context).textTheme.bodyMedium,
//                                           ),
//                                           Text(
//                                             branchInfo?.branchAddress ?? "",
//                                             style: Theme.of(context).textTheme.bodySmall,
//                                           ),
//                                         ],
//                                       )),
//                                       TRoundedIcon(
//                                         icon: Iconsax.edit,
//                                         onPressed: () {
//                                           _showModalAddress(context, state.branches);
//                                         },
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               }
//                               return const SizedBox.shrink();
//                             },
//                           ),
//                           const SizedBox(
//                             height: TSizes.md,
//                           ),
//                           Text(
//                             AppLocalizations.of(context)!.service + "  (${services.length})",
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                           const SizedBox(
//                             height: TSizes.md,
//                           ),
//                           ListView.builder(
//                             itemCount: services.length,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               final service = services[index];
//
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: TSizes.md),
//                                 child: TRoundedContainer(
//                                   shadow: true,
//                                   padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.md),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: [
//                                           TRoundedImage(
//                                             applyImageRadius: true,
//                                             imageUrl: service.images.isNotEmpty ? service.images[0] : TImages.thumbnailService,
//                                             isNetworkImage: service.images.isNotEmpty,
//                                             width: THelperFunctions.screenWidth(context) * 0.4,
//                                             height: THelperFunctions.screenWidth(context) * 0.2,
//                                             fit: BoxFit.cover,
//                                           ),
//                                           const SizedBox(width: TSizes.sm),
//                                           Row(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   ConstrainedBox(
//                                                     constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.4),
//                                                     child: TProductTitleText(
//                                                       title: service.name,
//                                                       smallSize: true,
//                                                       maxLines: 2,
//                                                     ),
//                                                   ),
//                                                   ConstrainedBox(
//                                                     constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.4),
//                                                     child: Row(
//                                                       children: [
//                                                         Text(
//                                                           AppLocalizations.of(context)!.duration + ": ",
//                                                           style: Theme.of(context).textTheme.labelLarge,
//                                                         ),
//                                                         Text(service.duration),
//                                                         Text(AppLocalizations.of(context)!.minutes)
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   ConstrainedBox(
//                                                       constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.4),
//                                                       child: TProductPriceText(price: service.price.toString())),
//                                                 ],
//                                               ),
//                                               const Align(alignment: Alignment.topRight, child: Text("x1"))
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           const SizedBox(
//                             height: TSizes.md,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [OutlinedButton(onPressed: () {}, child: Text("Add"))],
//                           ),
//                           const SizedBox(
//                             height: TSizes.md,
//                           ),
//                           TPaymentDetailService(price: total.toString(), total: total.toString()),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (state is AppointmentLoading) const TLoader()
//               ],
//             ),
//             bottomNavigationBar: Container(
//               color: TColors.primaryBackground,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     const Spacer(),
//                     TextButton(
//                       onPressed: (selectedBranch == null || selectedBranch == 0 || branchInfo == null)
//                           ? null
//                           : () {
//                               context.read<AppointmentBloc>().add(UpdateCreateServiceIdAndBranchIdEvent(
//                                   serviceId: services.map((x) => x.serviceId).toList(),
//                                   branchId: selectedBranch ?? 1,
//                                   totalMinutes: services.fold(0, (sum, service) => sum + int.parse(service.duration))));
//                               goSelectSpecialist(branchInfo!, services.fold(0, (sum, service) => sum + int.parse(service.duration)),
//                                   services.map((x) => x.serviceId).toList());
//                             },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Iconsax.arrow_right_1),
//                           const SizedBox(width: TSizes.md),
//                           Text(AppLocalizations.of(context)!.continue_book),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//       },
//     );
//   }
//
//   void _showModalAddress(BuildContext context, List<BranchModel> branches) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.md)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
//           return Padding(
//             padding: EdgeInsets.only(
//               left: TSizes.md,
//               right: TSizes.md,
//               top: TSizes.sm,
//               bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Branch',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 const SizedBox(height: TSizes.sm),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: branches.length,
//                   itemBuilder: (context, index) {
//                     final branch = branches[index];
//                     return Padding(
//                       padding: const EdgeInsets.all(TSizes.xs / 4),
//                       child: Row(
//                         children: [
//                           Radio<int>(
//                             value: branch.branchId,
//                             activeColor: TColors.primary,
//                             groupValue: selectedBranch,
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedBranch = value;
//                                 branchInfo = branches.where((e) => e.branchId == selectedBranch).first;
//                               });
//                               context.read<ListStaffBloc>().add(GetListStaffEvent(id: selectedBranch ?? 1));
//                             },
//                           ),
//                           ConstrainedBox(
//                             constraints: BoxConstraints(
//                               maxWidth: THelperFunctions.screenWidth(context) * 0.6,
//                             ),
//                             child: Text(
//                               branch.branchName,
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: TSizes.md),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (selectedBranch != null) {
//                           await LocalStorage.saveData(LocalStorageKey.defaultBranch, selectedBranch.toString());
//                           await LocalStorage.saveData(
//                               LocalStorageKey.branchInfo, jsonEncode(branches.where((e) => e.branchId == selectedBranch).first));
//                           setState(() {
//                             branchInfo = branches.where((e) => e.branchId == selectedBranch).first;
//                           });
//                           AppLogger.info(selectedBranch);
//                           Navigator.pop(context, branchInfo);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
//                       ),
//                       child: Text(
//                         "Set as default",
//                         style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//       },
//     ).then((selectedBranchInfo) {
//       AppLogger.debug(selectedBranchInfo.toString());
//       if (selectedBranchInfo != null) {
//         setState(() {
//           branchInfo = selectedBranchInfo;
//         });
//       } else {
//         AppLogger.debug("No selected branch");
//         setState(() {
//           // branchInfo = branches[0];
//         });
//       }
//     });
//   }
//
// // void _showModalStaff(BuildContext context, List<StaffModel> staffs, int indexService) {
// //   showModalBottomSheet(
// //     context: context,
// //     isScrollControlled: true,
// //     shape: const RoundedRectangleBorder(
// //       borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.md)),
// //     ),
// //     builder: (BuildContext context) {
// //       return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
// //         return Padding(
// //           padding: EdgeInsets.only(
// //             left: TSizes.md,
// //             right: TSizes.md,
// //             top: TSizes.sm,
// //             bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 'Staffs',
// //                 style: Theme.of(context).textTheme.bodyLarge,
// //               ),
// //               const SizedBox(height: TSizes.sm),
// //               ListView.builder(
// //                 shrinkWrap: true,
// //                 itemCount: staffs.length,
// //                 itemBuilder: (context, index) {
// //                   final staff = staffs[index];
// //                   return Padding(
// //                     padding: const EdgeInsets.all(TSizes.xs / 4),
// //                     child: Row(
// //                       children: [
// //                         Radio<int>(
// //                           value: staff.staffId,
// //                           activeColor: TColors.primary,
// //                           groupValue: selectedStaffId,
// //                           onChanged: (value) {
// //                             setState(() {
// //                               selectedStaffId = value;
// //                               staffInfo = staffs.where((e) => e.staffId == selectedStaffId).first;
// //                               staffList[indexService] = selectedStaffId!;
// //                             });
// //                           },
// //                         ),
// //                         ConstrainedBox(
// //                           constraints: BoxConstraints(
// //                             maxWidth: THelperFunctions.screenWidth(context) * 0.6,
// //                           ),
// //                           child: Text(
// //                             staff.staffInfo.fullName ?? staff.staffInfo.userName,
// //                             style: Theme.of(context).textTheme.bodyMedium,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //               const SizedBox(height: TSizes.md),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.end,
// //                 children: [
// //                   ElevatedButton(
// //                     onPressed: () async {
// //                       if (selectedStaffId != null) {
// //                         Navigator.pop(context, staffs.firstWhere((staff) => staff.staffId == selectedStaffId));
// //                       }
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
// //                     ),
// //                     child: Text(
// //                       "Set as default",
// //                       style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         );
// //       });
// //     },
// //   ).then((selectedStaffInfo) {
// //     checkValue();
// //     if (selectedStaffInfo != null) {
// //       setState(() {
// //         staffInfo = selectedStaffInfo;
// //       });
// //     } else {
// //       setState(() {
// //         // staffInfo = staffs.where((e) => e.staffId == selectedStaffId).first;
// //       });
// //     }
// //   });
// // }
// }
