import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/section_heading.dart';
import 'package:spa_mobile/core/provider/language_provider.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/user/presentation/widgets/setting_menu_title.dart';
import 'package:spa_mobile/features/user/presentation/widgets/user_profile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.headlineMedium!,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TUserProfileTile(
              onPressed: () => goProfile(),
            ),
            const SizedBox(
              height: TSizes.spacebtwItems,
            ),
            //body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
              child: Column(
                children: [
                  const TSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spacebtwItems,
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.award,
                    title: "Rewards",
                    onTap: () {},
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.language_circle,
                    title: "Language",
                    onTap: () {
                      _changeLanguagePopup(context);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "English",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          width: TSizes.sm,
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.receipt,
                    title: "Order",
                    onTap: () => goHistory(),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.bookmark,
                    title: "Appointment",
                    onTap: () => goHistory(),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  const Divider(),
                  TSettingsMenuTile(
                    icon: Iconsax.profile_remove,
                    title: "Delete account",
                    onTap: () => _deleteAccountWarningPopup(context),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.logout,
                    title: "Logout",
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: TSizes.spacebtwItems,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _deleteAccountWarningPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account permanently? '
            'This action is not reversible and all of your data will be removed permanently.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context)
                    .pop(); // Đóng dialog sau khi xóa tài khoản
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Delete'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeLanguagePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Language'),
          content:
              const Text('Are you sure you want to change to Vietnamese? '),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<LanguageProvider>(context, listen: false)
                    .changeLanguage(Locale('en'));
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Change'),
              ),
            ),
          ],
        );
      },
    );
  }
}