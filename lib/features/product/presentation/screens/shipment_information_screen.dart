import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/data/model/shipment_model.dart';
import 'package:spa_mobile/features/user/domain/usecases/update_profile.dart';
import 'package:spa_mobile/features/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:spa_mobile/features/user/presentation/widgets/address_input.dart';
import 'package:spa_mobile/features/user/presentation/widgets/profile_item.dart';

class ShipmentInformationScreen extends StatefulWidget {
  const ShipmentInformationScreen({super.key, required this.controller});

  final PurchasingDataController controller;

  @override
  State<ShipmentInformationScreen> createState() => _ShipmentInformationScreenState();
}

class _ShipmentInformationScreenState extends State<ShipmentInformationScreen> {
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late String districtId;
  late String wardCode;

  void _updateAddress(String address, String dtId, String wdCode) {
    addressController.text = address;
    districtId = dtId;
    wardCode = wdCode;
  }

  void showModalEditAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.md)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(heightFactor: 0.9, child: AddressInput(update: _updateAddress));
      },
    ).then((_) {});
  }

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.controller.shipment.name);
    phoneController = TextEditingController(text: widget.controller.shipment.phoneNumber);
    addressController = TextEditingController(text: widget.controller.shipment.address);
    districtId = widget.controller.shipment.districtId;
    wardCode = widget.controller.shipment.wardCode;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text(
          "Thông tin giao hàng",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            } else if (state is ProfileLoaded) {
              goCheckout(widget.controller);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TProfileItem(
                label: AppLocalizations.of(context)!.fullName,
                icon: Iconsax.profile_2user,
                controller: fullNameController,
              ),
              const SizedBox(height: TSizes.sm),
              TProfileItem(
                label: AppLocalizations.of(context)!.phone,
                icon: Iconsax.call,
                controller: phoneController,
              ),
              const SizedBox(height: TSizes.sm),
              GestureDetector(
                onTap: () => showModalEditAddress(context),
                child: TProfileItem(
                  label: AppLocalizations.of(context)!.address,
                  icon: Iconsax.building,
                  controller: addressController,
                  isEdit: false,
                ),
              ),
              const SizedBox(height: TSizes.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () async {
                        final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
                        if (jsonDecode(userJson) != null) {
                          final user = UserModel.fromJson(jsonDecode(userJson));

                          widget.controller.updateUser(user.copyWith(
                              fullName: fullNameController.text.trim(),
                              phoneNumber: phoneController.text.toString().trim(),
                              address: addressController.text.trim(),
                              wardCode: int.parse(wardCode),
                              district: int.parse(districtId)));
                          widget.controller.updateShipment(ShipmentModel(
                              address: addressController.text.trim(),
                              name: fullNameController.text.trim(),
                              phoneNumber: phoneController.text.toString().trim(),
                              districtId: districtId,
                              wardCode: wardCode));
                          context.read<ProfileBloc>().add(UpdateUserProfileEvent(
                              params: UpdateProfileParams(
                                  user.copyWith(
                                      fullName: fullNameController.text.trim(),
                                      phoneNumber: phoneController.text.toString().trim(),
                                      address: addressController.text.trim(),
                                      wardCode: int.parse(wardCode),
                                      district: int.parse(districtId)),
                                  "")));
                        } else {
                          goLoginNotBack();
                        }
                      },
                      child: const Text("Lưu vào dữ liệu")),
                  const SizedBox(
                    width: TSizes.lg,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        widget.controller.updateShipment(ShipmentModel(
                            address: addressController.text.trim(),
                            name: fullNameController.text.trim(),
                            phoneNumber: phoneController.text.toString().trim(),
                            districtId: districtId,
                            wardCode: wardCode));
                        goCheckout(widget.controller);
                      },
                      child: Text(AppLocalizations.of(context)!.save))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
