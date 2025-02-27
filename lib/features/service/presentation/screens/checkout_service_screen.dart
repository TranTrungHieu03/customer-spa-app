import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/widgets/date_picker.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/payment_method.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/common/widgets/time_picker.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/enum.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/bottom_checkout_service.dart';
import 'package:spa_mobile/features/service/presentation/widgets/payment_detail_service.dart';

class CheckoutServiceScreen extends StatefulWidget {
  const CheckoutServiceScreen({super.key, required this.services});

  final List<ServiceModel> services;

  @override
  State<CheckoutServiceScreen> createState() => _CheckoutServiceScreenState();
}

class _CheckoutServiceScreenState extends State<CheckoutServiceScreen> {
  int? selectedBranch;
  BranchModel? branchInfo;
  int? selectedStaffId;
  StaffModel? staffInfo;
  UserModel? user;
  bool isLoading = true;
  bool isValidate = false;
  List<int> staffList = [];

  void _getUser() async {
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    AppLogger.info("User: $userJson");
    if (jsonDecode(userJson) != null) {
      setState(() {
        user = UserModel.fromJson(jsonDecode(userJson));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      goLoginNotBack();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    _getUser();
    staffList = List.filled(widget.services.length, 0);
  }

  Future<void> _initializeData() async {
    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    setState(() {
      selectedBranch = int.parse(branchId) == 0 ? 1 : int.parse(branchId);
    });
    if (selectedBranch != "0") {
      context.read<ListBranchesBloc>().add(GetListBranchesEvent());
      context.read<ListStaffBloc>().add(GetListStaffEvent(id: selectedBranch ?? 1));

      branchInfo = BranchModel.fromJson(json.decode(await LocalStorage.getData(LocalStorageKey.branchInfo)));
    } else {
      TSnackBar.warningSnackBar(context, message: "Vui long chon chi nhanh");
    }
  }

  void checkValue () {
    setState(() {
      isValidate = checkIsValidate();
    });
  }
  bool checkIsValidate() {
    if (staffList.contains(0)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.services;
    List<int> servicesList = services.map((e) => e.serviceId).toList();

    double total = services.fold(0, (previousValue, element) => previousValue + element.price);

    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    TimeOfDay selectedTime = TimeOfDay.now();
    PaymentOption _selectedPaymentOption = PaymentOption.full;

    void handlePaymentOptionChange(PaymentOption option) {
      setState(() {
        _selectedPaymentOption = option;
      });
    }

    return BlocConsumer<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
        if (state is AppointmentCreateSuccess) {
          goWebView("https://www.youtube.com");
          // goSuccess(AppLocalizations.of(context)!.paymentSuccessTitle, AppLocalizations.of(context)!.paymentSuccessSubTitle,
          //     () => goBookingDetail(state.appointment.appointmentId), TImages.success);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(TSizes.sm),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<ListBranchesBloc, ListBranchesState>(
                        listener: (context, state) {
                          if (state is ListBranchesError) {
                            TSnackBar.errorSnackBar(context, message: state.message);
                          }
                        },
                        builder: (context, state) {
                          if (state is ListBranchesLoaded) {
                            return TRoundedContainer(
                              padding: const EdgeInsets.all(TSizes.sm),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Branch",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    width: TSizes.sm,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        branchInfo?.branchName ?? "Chưa có dữ liệu",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      Text(
                                        branchInfo?.branchAddress ?? "...",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  )),
                                  TRoundedIcon(
                                    icon: Iconsax.edit,
                                    onPressed: () {
                                      _showModalAddress(context, state.branches);
                                    },
                                  )
                                ],
                              ),
                            );
                          }
                          return TRoundedContainer(
                            padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "All Branches ",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TRoundedIcon(
                                  icon: Iconsax.filter_tick,
                                  onPressed: () {
                                    TSnackBar.warningSnackBar(context, message: "No branch available.");
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Text(
                                  "Date",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(
                                  width: TSizes.md,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: DatePickerWidget(
                              onDateSelected: (value) {
                                selectedDate = value;
                                AppLogger.info("Ngày đã chọn: ${selectedDate.toIso8601String()}");
                              },
                              initialDate: selectedDate,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      Text(
                        AppLocalizations.of(context)!.service + "  (${services.length})",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      ListView.builder(
                        itemCount: services.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final service = services[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: TSizes.md), // Khoảng cách giữa các item
                            child: TRoundedContainer(
                              shadow: true,
                              padding: const EdgeInsets.all(TSizes.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TRoundedImage(
                                        applyImageRadius: true,
                                        imageUrl: service.images.isNotEmpty ? service.images[0] : TImages.thumbnailService,
                                        isNetworkImage: service.images.isNotEmpty,
                                        width: THelperFunctions.screenWidth(context) * 0.4,
                                        height: THelperFunctions.screenWidth(context) * 0.2,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: TSizes.sm),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.5),
                                            child: TProductTitleText(
                                              title: service.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.duration + ": ",
                                                  style: Theme.of(context).textTheme.labelLarge,
                                                ),
                                                Text(service.duration),
                                                Text(AppLocalizations.of(context)!.minutes)
                                              ],
                                            ),
                                          ),
                                          ConstrainedBox(
                                              constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.5),
                                              child: TProductPriceText(price: service.price.toString())),
                                        ],
                                      )
                                    ],
                                  ),

                                  const SizedBox(height: TSizes.sm),

                                  // Hàng thứ hai: Chọn nhân viên
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 4, // Chữ "Staff" chiếm 4 phần
                                        child: Row(
                                          children: [
                                            Text(
                                              "Staff",
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            const SizedBox(width: TSizes.sm),
                                            GestureDetector(
                                              child: const Icon(
                                                Iconsax.info_circle,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.sm)),
                                                  ),
                                                  builder: (context) {
                                                    return const Padding(
                                                      padding: EdgeInsets.all(TSizes.sm),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "Nếu bạn muốn nhân viên được chỉ định làm, thời gian có thể thay đổi",
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: BlocConsumer<ListStaffBloc, ListStaffState>(
                                          listener: (context, state) {
                                            if (state is ListStaffError) {
                                              TSnackBar.errorSnackBar(context, message: state.message);
                                            }
                                          },
                                          builder: (context, state) {
                                            if (state is ListStaffEmpty) {
                                              return const Text("No staff available");
                                            } else if (state is ListStaffLoaded) {
                                              final staffs = state.listStaff;

                                              return TRoundedContainer(
                                                padding: const EdgeInsets.all(TSizes.sm * 1.5),
                                                showBorder: true,
                                                borderColor: Colors.black12,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        staffInfo != null
                                                            ? staffInfo!.staffInfo.fullName ?? staffInfo!.staffInfo.userName
                                                            : "Choose staff",
                                                        style: Theme.of(context).textTheme.bodyMedium,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: TSizes.md),
                                                    GestureDetector(
                                                      child: const Icon(Iconsax.arrow_down_1, size: 20),
                                                      onTap: () {
                                                        _showModalStaff(context, staffs, index);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (state is ListStaffLoading) {
                                              return const TShimmerEffect(width: TSizes.shimmerLg, height: TSizes.shimmerSx * 2);
                                            }
                                            return const SizedBox();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: TSizes.sm),

                                  // Hàng thứ ba: Chọn thời gian
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Time",
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            const SizedBox(width: TSizes.sm),
                                            GestureDetector(
                                              child: const Icon(
                                                Iconsax.info_circle,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.sm)),
                                                  ),
                                                  builder: (context) {
                                                    return const Padding(
                                                      padding: EdgeInsets.all(TSizes.sm),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "Nếu bạn muốn nhân viên được chỉ định làm, thời gian có thể thay đổi",
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6, // Phần chọn thời gian chiếm 6 phần
                                        child: TimePickerWidget(
                                          onTimeSelected: (value) {
                                            int hour = value.hour;

                                            if (hour >= 22 || hour < 8) {
                                              TSnackBar.warningSnackBar(context, message: "Vui lòng chọn thời gian từ 08:00 đến 21:59");
                                              value = selectedTime;
                                            } else {
                                              selectedTime = value;
                                              AppLogger.info("Ngày đã chọn: $selectedDate $selectedTime");
                                            }
                                          },
                                          initialTime: selectedTime,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Text(
                        "Payment Methods",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      TPaymentSelection(total: total, onOptionChanged: handlePaymentOptionChange, selectedOption: _selectedPaymentOption),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      Text(
                        "Promo Code",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      GestureDetector(
                          onTap: () {
                            _showVoucherModal(context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.select_or_enter_code, style: Theme.of(context).textTheme.bodySmall),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )
                            ],
                          )),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      TPaymentDetailService(price: total.toString(), total: total.toString()),
                    ],
                  ),
                ),
              ),
              if (state is AppointmentLoading) const TLoader()
            ],
          ),
          bottomNavigationBar: TBottomCheckoutService(onPressed: () {
            context.read<AppointmentBloc>().add(CreateAppointmentEvent(CreateAppointmentParams(
                customerId: user?.userId ?? 1,
                //api create appoinment cho customer và cho cashier chung hay riêng
                staffId: staffList,
                serviceId: servicesList,
                branchId: selectedBranch ?? 1,
                appointmentsTime: combineDateTime(selectedDate, selectedTime),
                notes: "")));
          }, isValue: isValidate,),
        );
      },
    );
  }

  void _showVoucherModal(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.shop_voucher,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter your voucher code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Available Vouchers",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildVoucherItem(context, index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVoucherItem(BuildContext context, int index) {
    final voucherTitles = [
      "10% Off for First Order",
      "Free Shipping on Orders Over \$50",
      "Buy 2 Get 1 Free",
      "Buy 3 Get 1 Free",
      "Buy 5 Get 2 Free",
    ];
    final voucherCodes = ["FIRST10", "FREE_SHIP50", "B2G1FREE", "B3G1FREE", "B5G2FREE"];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.local_offer,
          color: Colors.green,
        ),
        title: Text(voucherTitles[index]),
        subtitle: Text("Code: ${voucherCodes[index]}"),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
          ),
          child: Text(
            AppLocalizations.of(context)!.apply,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: TSizes.md,
                ),
          ),
        ),
      ),
    );
  }

  void _showModalAddress(BuildContext context, List<BranchModel> branches) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.md)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: TSizes.md,
              right: TSizes.md,
              top: TSizes.sm,
              bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Branch',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: TSizes.sm),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    return Padding(
                      padding: const EdgeInsets.all(TSizes.xs / 4),
                      child: Row(
                        children: [
                          Radio<int>(
                            value: branch.branchId,
                            activeColor: TColors.primary,
                            groupValue: selectedBranch,
                            onChanged: (value) {
                              setState(() {
                                selectedBranch = value;
                                branchInfo = branches.where((e) => e.branchId == selectedBranch).first;
                              });
                              context.read<ListStaffBloc>().add(GetListStaffEvent(id: selectedBranch ?? 1));
                            },
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                            ),
                            child: Text(
                              branch.branchName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: TSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedBranch != null) {
                          await LocalStorage.saveData(LocalStorageKey.defaultBranch, selectedBranch.toString());
                          await LocalStorage.saveData(
                              LocalStorageKey.branchInfo, jsonEncode(branches.where((e) => e.branchId == selectedBranch).first));
                          setState(() {
                            branchInfo = branches.where((e) => e.branchId == selectedBranch).first;
                          });
                          AppLogger.info(selectedBranch);
                          Navigator.pop(context, branchInfo);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                      ),
                      child: Text(
                        "Set as default",
                        style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    ).then((selectedBranchInfo) {
      AppLogger.debug(selectedBranchInfo.toString());
      if (selectedBranchInfo != null) {
        setState(() {
          branchInfo = selectedBranchInfo;
        });
      } else {
        AppLogger.debug("No selected branch");
        setState(() {
          // branchInfo = branches[0];
        });
      }
    });
  }

  void _showModalStaff(BuildContext context, List<StaffModel> staffs, int indexService) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.md)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: TSizes.md,
              right: TSizes.md,
              top: TSizes.sm,
              bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Staffs',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: TSizes.sm),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: staffs.length,
                  itemBuilder: (context, index) {
                    final staff = staffs[index];
                    return Padding(
                      padding: const EdgeInsets.all(TSizes.xs / 4),
                      child: Row(
                        children: [
                          Radio<int>(
                            value: staff.staffId,
                            activeColor: TColors.primary,
                            groupValue: selectedStaffId,
                            onChanged: (value) {
                              setState(() {
                                selectedStaffId = value;
                                staffInfo = staffs.where((e) => e.staffId == selectedStaffId).first;
                                staffList[indexService] = selectedStaffId!;
                              });
                            },
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                            ),
                            child: Text(
                              staff.staffInfo.fullName ?? staff.staffInfo.userName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: TSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedStaffId != null) {
                          Navigator.pop(context, staffs.firstWhere((staff) => staff.staffId == selectedStaffId));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                      ),
                      child: Text(
                        "Set as default",
                        style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    ).then((selectedStaffInfo) {
      checkValue();
      if (selectedStaffInfo != null) {
        setState(() {
          staffInfo = selectedStaffInfo;
        });
      } else {
        setState(() {
          // staffInfo = staffs.where((e) => e.staffId == selectedStaffId).first;
        });
      }
    });
  }
}
