import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_district.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_ward.dart';
import 'package:spa_mobile/features/user/presentation/bloc/address/address_bloc.dart';

class AddressInput extends StatefulWidget {
  const AddressInput({super.key, required this.update});

  final Function(String, String, String) update;

  @override
  State<AddressInput> createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  String province = "";
  String address = "";
  String district = "";
  String districtID = "";
  String commune = "";
  String communeID = "";

  void updateAddress() {
    setState(() {
      address = [_numberAddress.text, commune, district, province].where((e) => e.isNotEmpty).join(', ');
    });
  }

  final ExpansionTileController _controllerProvince = ExpansionTileController();
  final ExpansionTileController _controllerDistrict = ExpansionTileController();
  final ExpansionTileController _controllerWard = ExpansionTileController();
  final TextEditingController _numberAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Địa chỉ: ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: TSizes.md),
                  Expanded(
                    child: Text(
                      address,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.md),
              ExpansionTile(
                controller: _controllerProvince,
                title: Text("Chọn tỉnh thành"),
                children: [
                  BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
                    if (state is AddressProvinceLoaded && state.provinces.isNotEmpty) {
                      return SizedBox(
                          height: 350,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.provinces[index].provinceName),
                                onTap: () {
                                  _controllerProvince.collapse();
                                  setState(() {
                                    province = state.provinces[index].provinceName;
                                    district = "";
                                    districtID = "";
                                    commune = "";
                                    communeID = "";
                                    _numberAddress.text = "";
                                  });
                                  updateAddress();
                                  context.read<AddressBloc>().add(GetListDistrictEvent(GetDistrictParams(state.provinces[index].provinceId)));
                                },
                              );
                            },
                            itemCount: state.provinces.length,
                          ));
                    } else if (state is AddressLoading) {
                      return const TLoader();
                    }
                    return const TErrorBody();
                  }),
                ],
              ),
              ExpansionTile(
                title: Text("Chọn quận huyện", style: Theme.of(context).textTheme.bodyLarge),
                controller: _controllerDistrict,
                onExpansionChanged: (isExpanded) {
                  if (context.read<AddressBloc>().state is AddressProvinceLoaded &&
                      (context.read<AddressBloc>().state as AddressProvinceLoaded).districts.isEmpty) {
                    _controllerDistrict.collapse();
                  }
                },
                children: [
                  BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
                    if (state is AddressProvinceLoaded && state.districts.isNotEmpty) {
                      return SizedBox(
                          height: 350,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.districts[index].districtName),
                                onTap: () {
                                  _controllerDistrict.collapse();
                                  setState(() {
                                    district = state.districts[index].districtName;
                                    districtID = state.districts[index].districtId.toString();
                                    commune = "";
                                    communeID = "";
                                    _numberAddress.text = "";
                                  });
                                  AppLogger.info("$districtID, $communeID");
                                  updateAddress();
                                  context.read<AddressBloc>().add(GetListCommuneEvent(GetWardParams(state.districts[index].districtId)));
                                },
                              );
                            },
                            itemCount: state.districts.length,
                          ));
                    } else if (state is AddressProvinceLoaded && state.isLoadingDistrict) {
                      return TLoader();
                    }
                    return const SizedBox();
                  }),
                ],
              ),
              ExpansionTile(
                title: Text("Chọn xã phường", style: Theme.of(context).textTheme.bodyLarge),
                controller: _controllerWard,
                onExpansionChanged: (isExpanded) {
                  if (context.read<AddressBloc>().state is AddressProvinceLoaded &&
                      (context.read<AddressBloc>().state as AddressProvinceLoaded).wards.isEmpty) {
                    _controllerWard.collapse();
                  }
                },
                children: [
                  BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
                    if (state is AddressProvinceLoaded && state.wards.isNotEmpty) {
                      return SizedBox(
                          height: 350,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.wards[index].wardName),
                                onTap: () {
                                  _controllerWard.collapse();
                                  setState(() {
                                    commune = state.wards[index].wardName;
                                    communeID = state.wards[index].wardCode;
                                  });
                                  updateAddress();
                                },
                              );
                            },
                            itemCount: state.wards.length,
                          ));
                    } else if (state is AddressProvinceLoaded && state.isLoadingDistrict) {
                      return TLoader();
                    }
                    return const SizedBox();
                  }),
                ],
              ),
              TextField(
                  controller: _numberAddress,
                  decoration: InputDecoration(
                    hintText: "Số nhà",
                    contentPadding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                    prefixIcon: const TRoundedIcon(icon: Iconsax.building),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (v) => updateAddress(),
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: TSizes.lg,),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        widget.update(address, districtID, communeID);
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.continue_book)))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(GetListProvinceEvent());
  }
}
