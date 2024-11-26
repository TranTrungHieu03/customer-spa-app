import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/notification.dart';
import 'package:spa_mobile/core/common/widgets/primary_header_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/validators/validation.dart';
import 'package:spa_mobile/features/home/presentation/widgets/banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TPrimaryHeaderContainer(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: TSizes.defaultSpace / 2,
              ),
              TAppbar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const TRoundedImage(
                      imageUrl: TImages.avatar,
                      borderRadius: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: TSizes.defaultSpace / 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreetingMessage(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .apply(color: TColors.white),
                          ),
                          Text(
                            "Tran Trung Hieu",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .apply(color: TColors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                actions: [
                  TNotificationIcon(onPressed: () {}, iconColor: TColors.white)
                ],
              ),
              Form(
                  child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                            TValidator.validateEmptyText('Search', value),
                        decoration: InputDecoration(
                          // labelText: TTexts.placeholderDirectionTo,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: TColors.black.withOpacity(0.5)),
                          floatingLabelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: Colors.transparent),
                          prefixIcon: const Icon(
                            Iconsax.direct_right,
                            color: TColors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: TSizes.spacebtwItems / 2,
                    ),
                    TRoundedIcon(
                      icon: Iconsax.search_normal,
                      color: TColors.white,
                      onPressed: () {},
                      backgroundColor: TColors.primary.withOpacity(0.9),
                    )
                  ],
                ),
              )),
            ],
          )),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: TSizes.defaultSpace,
                ),
                Text(
                  AppLocalizations.of(context)!.bannerTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .apply(color: TColors.black),
                ),
                const TBanner()
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getGreetingMessage() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return AppLocalizations.of(context)!.helloMorning;
    } else if (hour >= 12 && hour < 14) {
      return AppLocalizations.of(context)!.helloAfternoon;
    } else if (hour >= 14 && hour < 18) {
      return AppLocalizations.of(context)!.helloEvening;
    } else {
      return AppLocalizations.of(context)!.helloNight;
    }
  }
}
