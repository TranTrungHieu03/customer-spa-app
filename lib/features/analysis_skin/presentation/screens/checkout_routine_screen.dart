import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_distance.dart';
import 'package:spa_mobile/features/home/presentation/blocs/nearest_branch/nearest_branch_bloc.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_branch_detail.dart';
import 'package:spa_mobile/features/service/presentation/bloc/branch/branch_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/payment_detail_service.dart';

class CheckoutRoutineScreen extends StatefulWidget {
  const CheckoutRoutineScreen({super.key});

  @override
  State<CheckoutRoutineScreen> createState() => _CheckoutRoutineScreenState();
}

class _CheckoutRoutineScreenState extends State<CheckoutRoutineScreen> {
  int? selectedBranch;
  int? previousBranch;
  BranchModel? branchInfo;
  UserModel? userId;
  final _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
        title: Text("Xác nhận"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branchInfo!.branchName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(branchInfo!.branchAddress, style: Theme.of(context).textTheme.bodyMedium)
                        ],
                      ),
                    ),
                    TRoundedIcon(
                      icon: Iconsax.edit,
                      onPressed: () {
                        final state = context.read<ListBranchesBloc>().state;
                        if (state is ListBranchesLoaded) {
                          _showFilterModel(context, state.branches);
                        }
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.md,
              ),
              const TRoundedContainer(
                padding: EdgeInsets.all(TSizes.sm),
                child: Column(
                  children: [
                    Row(
                      children: [Text("Thoi gian dat hen: ")],
                    ),
                    const SizedBox(
                      height: TSizes.sm,
                    ),
                  ],
                ),
              ),
              Divider(
                color: dark ? TColors.darkGrey : TColors.grey,
                thickness: 0.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discount code", style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                      onPressed: () => _showVoucherModal(context),
                      child: TRoundedContainer(padding: const EdgeInsets.all(TSizes.sm), child: Text(AppLocalizations.of(context)!.add)))
                ],
              ),
              Divider(
                color: dark ? TColors.darkGrey : TColors.grey,
                thickness: 0.5,
              ),
              const SizedBox(
                height: TSizes.md,
              ),
              TPaymentDetailService(
                price: (100).toString(),
                total: (100).toString(),
                promotePrice: 0,
              ),
              Divider(
                color: dark ? TColors.darkGrey : TColors.grey,
                thickness: 0.5,
              ),
              Text("Note", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: TSizes.xs,
              ),
              TextField(
                focusNode: _focusNode,
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Paste your message to the center",
                  contentPadding: const EdgeInsets.all(TSizes.sm),
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                autofocus: false,
                onTap: () {
                  _scrollToBottom();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ListBranchesBloc>().add(GetListBranchesEvent());
    _loadLocalData();
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

  Future<void> _loadLocalData() async {
    final branchId = await LocalStorage.getData(LocalStorageKey.defaultBranch);
    AppLogger.debug(branchId);
    if (mounted) {
      if (branchId == "") {
        // TSnackBar.warningSnackBar(context, message: "Vui lòng chọn chi nhánh để tiếp tục.");
        setState(() {
          selectedBranch = 1;
          previousBranch = selectedBranch;
        });
        context.read<BranchBloc>().add(GetBranchDetailEvent(GetBranchDetailParams(1)));
      } else {
        branchInfo = BranchModel.fromJson(json.decode(await LocalStorage.getData(LocalStorageKey.branchInfo)));
        setState(() {
          selectedBranch = int.parse(branchId);
          previousBranch = selectedBranch;
        });
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Hủy FocusNode khi widget bị hủy
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutSine,
        );
      }
    });
  }

  void _showFilterModel(BuildContext context, List<BranchModel> branchesState) {
    List<BranchModel> listBranches = branchesState;

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
            child: BlocBuilder<ListBranchesBloc, ListBranchesState>(
              builder: (context, state) {
                if (state is ListBranchesLoaded) {
                  context.read<NearestBranchBloc>().add(GetNearestBranchEvent(params: GetDistanceParams(state.branches)));
                  final branches = state.branches;
                  listBranches = branches;
                  return Column(
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
                                    AppLogger.info('Selected branch: $value');
                                    setState(() {
                                      selectedBranch = value;
                                      branchInfo = branch;
                                    });
                                  },
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: THelperFunctions.screenWidth(context) * 0.7,
                                  ),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        branch.branchName,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(
                                        width: TSizes.xs,
                                      ),
                                      BlocBuilder<NearestBranchBloc, NearestBranchState>(builder: (context, distanceState) {
                                        if (distanceState is NearestBranchLoaded) {
                                          return Text('(${distanceState.branches[index].distance.text})');
                                        } else if (distanceState is NearestBranchLoading) {
                                          return const TShimmerEffect(width: TSizes.shimmerSm, height: TSizes.shimmerSx);
                                        }
                                        return const SizedBox();
                                      })
                                    ],
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
                              AppLogger.debug(selectedBranch);
                              if (selectedBranch != null) {
                                await LocalStorage.saveData(LocalStorageKey.defaultBranch, selectedBranch.toString());
                                if (selectedBranch != 0) {
                                  await LocalStorage.saveData(
                                      LocalStorageKey.branchInfo, jsonEncode(branches.where((e) => e.branchId == selectedBranch).first));
                                }
                                Navigator.of(context).pop();
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
                  );
                } else if (state is ListBranchesLoading) {
                  return const TLoader();
                }
                return const SizedBox();
              },
            ),
          );
        });
      },
    ).then((_) {
      if (selectedBranch != previousBranch) {
        // updateProducts();
        // _onFilter();
      }
    });
  }
}
