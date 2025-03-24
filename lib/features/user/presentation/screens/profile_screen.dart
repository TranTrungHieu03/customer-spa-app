import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/circular_image.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/user/domain/usecases/update_profile.dart';
import 'package:spa_mobile/features/user/presentation/bloc/address/address_bloc.dart';
import 'package:spa_mobile/features/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:spa_mobile/features/user/presentation/widgets/autofill_address.dart';
import 'package:spa_mobile/features/user/presentation/widgets/profile_item.dart';
import 'package:spa_mobile/init_dependencies.dart';

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
  }

  void _updateControllers(UserModel user) {
    fullNameController.text = user.fullName ?? "";
    emailController.text = user.email;
    phoneController.text = user.phoneNumber ?? "";
    cityController.text = user.city ?? "";
    userNameController.text = user.userName;
    addressController.text = user.address ?? "";
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
        showBackArrow: true,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            TSnackBar.errorSnackBar(context, message: state.message);
            goLoginNotBack();
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
                        onTap: () => _showModalEditAddress(context, addressController),
                        child: TProfileItem(
                          label: AppLocalizations.of(context)!.address,
                          icon: Iconsax.home,
                          controller: addressController,
                          isEdit: false,
                        ),
                      ),
                      const SizedBox(height: TSizes.md),
                      _buildActionButtons(context),
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

  void _showModalEditAddress(BuildContext context, TextEditingController addressController) {
    // final addressBloc = context.read<AddressBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.md)),
      ),
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => serviceLocator<AddressBloc>(),
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: AutofillAddress(addressController: addressController),
          ),
        );
      },
    );
  }

  Widget _buildProfilePictureSection(String? avatar) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            TCircularImage(
              image: avatar ?? TImages.avatar,
              isNetworkImage: avatar != null,
              width: 80.0,
              height: 80.0,
              padding: TSizes.sm,
            ),
            TextButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context)!.changeAvatar),
            ),
          ],
        ));
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
            if (context.read<ProfileBloc>().state is ProfileLoaded) {
              final updatedUser = (context.read<ProfileBloc>().state as ProfileLoaded).userInfo.copyWith(
                    fullName: fullNameController.text.trim(),
                    email: emailController.text.trim(),
                    phoneNumber: phoneController.text.trim(),
                    city: cityController.text.trim(),
                    userName: userNameController.text.trim(),
                    address: addressController.text.trim(),
                  );
              context.read<ProfileBloc>().add(UpdateUserProfileEvent(UpdateProfileParams(updatedUser, "")));
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
