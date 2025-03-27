import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/circular_image.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/image/image_bloc.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/data/models/address_model.dart';
import 'package:spa_mobile/features/user/domain/usecases/update_profile.dart';
import 'package:spa_mobile/features/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:spa_mobile/features/user/presentation/widgets/autofill_address.dart';
import 'package:spa_mobile/features/user/presentation/widgets/profile_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController cityController;
  late TextEditingController userNameController;
  late TextEditingController addressController;
  late AddressModel addressModel;

  void _updateAddress(AddressModel model) {
    AppLogger.info("updated address");
    AppLogger.info(model.district);
    AppLogger.info(model.province);
    AppLogger.info(model.commune);
    setState(() {
      addressModel = model;
      addressController.text = model.fullAddress;
    });
    //
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    context.read<ProfileBloc>().add(GetUserInfoEvent());
  }

  void _initializeControllers() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    cityController = TextEditingController();
    userNameController = TextEditingController();
    addressController = TextEditingController();
    addressModel = AddressModel.empty();
  }

  void _updateControllers(UserModel user) {
    fullNameController.text = user.fullName ?? "";
    emailController.text = user.email;
    phoneController.text = user.phoneNumber ?? "";
    cityController.text = user.city ?? "";
    userNameController.text = user.userName;
    addressController.text = user.address ?? "";
  }

  void showModalEditAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.md)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: AutofillAddress(
            addressSubController: addressController,
            update: (AddressModel selectedAddress) {
              // Update the original controller with the selected address
              addressController.text = selectedAddress.fullAddress;
              // Call the original update function
              _updateAddress(selectedAddress);
            },
          ),
        );
      },
    ).then((_) {});
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    userNameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: Text(
          AppLocalizations.of(context)!.yourProfile,
          style: Theme.of(context).textTheme.headlineMedium!,
        ),
        showBackArrow: false,
        leadingIcon: Iconsax.arrow_left,
        leadingOnPressed: () {
          goSetting();
        },
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            TSnackBar.errorSnackBar(context, message: state.message);
            // goLoginNotBack();
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const TLoader();
            } else if (state is ProfileLoaded) {
              _updateControllers(state.userInfo);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfilePictureSection(state.userInfo.avatar),
                      const SizedBox(height: TSizes.md),
                      TProfileItem(
                        label: AppLocalizations.of(context)!.fullName,
                        icon: Iconsax.profile_2user,
                        controller: fullNameController,
                      ),
                      const SizedBox(height: TSizes.sm),
                      TProfileItem(
                        label: AppLocalizations.of(context)!.username,
                        icon: Iconsax.profile_2user,
                        controller: userNameController,
                      ),
                      const SizedBox(height: TSizes.sm),
                      TProfileItem(
                        label: AppLocalizations.of(context)!.email,
                        icon: Iconsax.direct_right,
                        controller: emailController,
                        isEdit: false,
                      ),
                      const SizedBox(height: TSizes.sm),
                      TProfileItem(
                        label: AppLocalizations.of(context)!.phone,
                        icon: Iconsax.call,
                        controller: phoneController,
                      ),
                      const SizedBox(height: TSizes.sm),
                      TProfileItem(
                        label: AppLocalizations.of(context)!.city,
                        icon: Iconsax.building,
                        controller: cityController,
                      ),
                      const SizedBox(height: TSizes.sm),
                      GestureDetector(
                        onTap: () => showModalEditAddress(context),
                        child: TProfileItem(
                          label: AppLocalizations.of(context)!.address,
                          icon: Iconsax.home,
                          controller: addressController,
                          isEdit: false,
                        ),
                      ),
                      const SizedBox(height: TSizes.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                              side: const BorderSide(color: Colors.red, width: 1.0),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: TSizes.md),
                          ElevatedButton(
                            onPressed: () {
                              AppLogger.info(addressController.text);
                              AppLogger.info(addressModel.district);
                              AppLogger.info(addressModel.province);
                              AppLogger.info(addressModel.commune);
                              AppLogger.info(addressModel.fullAddress);

                              if (context.read<ProfileBloc>().state is ProfileLoaded) {
                                final isChangeAddress =
                                    (context.read<ProfileBloc>().state as ProfileLoaded).userInfo.address != addressModel.fullAddress;
                                final updatedUser = (context.read<ProfileBloc>().state as ProfileLoaded).userInfo.copyWith(
                                      fullName: fullNameController.text.trim(),
                                      email: emailController.text.trim(),
                                      phoneNumber: phoneController.text.trim(),
                                      city: cityController.text.trim(),
                                      userName: userNameController.text.trim(),
                                      address: isChangeAddress ? addressModel.fullAddress : addressController.text.trim(),
                                    );
                                if (context.read<ImageBloc>().state is ImagePicked) {
                                  context.read<ProfileBloc>().add(
                                        UpdateUserProfileEvent(
                                            params: UpdateProfileParams(
                                              updatedUser,
                                              (context.read<ImageBloc>().state as ImagePicked).image.path,
                                            ),
                                            isChangeAddress: isChangeAddress,
                                            addressModel: addressModel),
                                      );
                                  context.read<ImageBloc>().add(RefreshImageEvent());
                                } else {
                                  context.read<ProfileBloc>().add(UpdateUserProfileEvent(
                                      params: UpdateProfileParams(updatedUser, ""),
                                      isChangeAddress: isChangeAddress,
                                      addressModel: addressModel));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.save,
                              style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            return const ErrorScreen();
          },
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(String? avatar) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        if (state is ImagePicked) {
          return SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  TRoundedContainer(
                      width: 80,
                      height: 80,
                      radius: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            state.image,
                            fit: BoxFit.cover,
                          ))),
                  TextButton(
                    onPressed: () {
                      context.read<ImageBloc>().add(PickImageEvent());
                    },
                    child: Text(AppLocalizations.of(context)!.changeAvatar),
                  ),
                ],
              ));
        }
        return SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                TCircularImage(
                  image: avatar ?? TImages.avatar,
                  isNetworkImage: avatar != null,
                  width: 80.0,
                  fit: BoxFit.cover,
                  height: 80.0,
                  padding: 0,
                ),
                TextButton(
                  onPressed: () {
                    context.read<ImageBloc>().add(PickImageEvent());
                  },
                  child: Text(AppLocalizations.of(context)!.changeAvatar),
                ),
              ],
            ));
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
            side: const BorderSide(color: Colors.red, width: 1.0),
          ),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
          ),
        ),
        const SizedBox(width: TSizes.md),
        ElevatedButton(
          onPressed: () {
            AppLogger.info(addressController.text);
            AppLogger.info(addressModel.district);

            if (context.read<ProfileBloc>().state is ProfileLoaded) {
              final isChangeAddress = (context.read<ProfileBloc>().state as ProfileLoaded).userInfo.address != addressController.text;
              final updatedUser = (context.read<ProfileBloc>().state as ProfileLoaded).userInfo.copyWith(
                    fullName: fullNameController.text.trim(),
                    email: emailController.text.trim(),
                    phoneNumber: phoneController.text.trim(),
                    city: cityController.text.trim(),
                    userName: userNameController.text.trim(),
                    address: addressController.text.trim(),
                  );
              if (context.read<ImageBloc>().state is ImagePicked) {
                context.read<ProfileBloc>().add(
                      UpdateUserProfileEvent(
                          params: UpdateProfileParams(
                            updatedUser,
                            (context.read<ImageBloc>().state as ImagePicked).image.path,
                          ),
                          isChangeAddress: isChangeAddress,
                          addressModel: addressModel),
                    );
                context.read<ImageBloc>().add(RefreshImageEvent());
              } else {
                context.read<ProfileBloc>().add(UpdateUserProfileEvent(
                    params: UpdateProfileParams(updatedUser, ""), isChangeAddress: isChangeAddress, addressModel: addressModel));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
          ),
          child: Text(
            AppLocalizations.of(context)!.save,
            style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
