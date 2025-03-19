import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/notification.dart';
import 'package:spa_mobile/core/common/widgets/primary_header_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/image/image_bloc.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/presentation/widgets/banner.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

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
  Widget build(BuildContext context) {
    return BlocListener<ImageBloc, ImageState>(
      listener: (context, state) {
        if (state is ImagePicked) {
          goImageReview(state.image);
        }
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TPrimaryHeaderContainer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: TSizes.defaultSpace / 2,
                ),
                TAppbar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: TSizes.sm / 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreetingMessage(),
                              style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.white),
                            ),
                            isLoading
                                ? const TShimmerEffect(width: TSizes.shimmerLg, height: TSizes.shimmerSx)
                                : ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.7),
                                    child: Text(
                                      user?.userName ?? "",
                                      style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                  actions: [
                    TNotificationIcon(onPressed: () {}, iconColor: TColors.primary),
                    const SizedBox(
                      width: TSizes.md,
                    ),
                  ],
                ),

                // const TSearchHome(),
                const SizedBox(
                  height: TSizes.md * 2,
                )
              ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BlocBuilder<ImageBloc, ImageState>(
                    builder: (context, state) {
                      return TRoundedContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(TSizes.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TFlashAction(
                                title: AppLocalizations.of(context)!.solaceChat,
                                iconData: Iconsax.message,
                                onPressed: () => goChat(),
                              ),
                              TFlashAction(
                                title: AppLocalizations.of(context)!.analysisImage,
                                iconData: Iconsax.scan,
                                onPressed: () {
                                  context.read<ImageBloc>().add(PickImageEvent());
                                },
                              ),
                              TFlashAction(
                                title: AppLocalizations.of(context)!.analysisData,
                                iconData: Iconsax.document_1,
                                onPressed: () => goFormData(SkinHealthModel.empty(), false),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  Text("Dịch vụ đề xuất", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  Text("Sản phẩm đề xuất", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: TSizes.sm,
                  ),

                  Text("Lịch hẹn sắp tới", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  Text(AppLocalizations.of(context)!.bannerTitle, style: Theme.of(context).textTheme.titleLarge),
                  const TBanner(),
                  const SizedBox(
                    height: TSizes.defaultSpace,
                  ),
                  Text(AppLocalizations.of(context)!.service_type, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  const TServiceCategories(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.featured_service, style: Theme.of(context).textTheme.titleLarge),
                      GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(AppLocalizations.of(context)!.view_all, style: Theme.of(context).textTheme.bodySmall),
                              const TRoundedIcon(icon: Icons.chevron_right)
                            ],
                          ))
                    ],
                  ),
                  // TGridLayout(
                  //     itemCount: 2,
                  //     crossAxisCount: 2,
                  //     itemBuilder: (context, index) {
                  //       return null;
                  //
                  //       // return const TServiceCard();
                  //     }),
                  const SizedBox(
                    height: TSizes.md,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.best_selling_product, style: Theme.of(context).textTheme.titleLarge),
                      GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(AppLocalizations.of(context)!.view_all, style: Theme.of(context).textTheme.bodySmall),
                              const TRoundedIcon(icon: Icons.chevron_right)
                            ],
                          ))
                    ],
                  ),
                  // TGridLayout(
                  //     crossAxisCount: 2,
                  //     itemCount: 2,
                  //     itemBuilder: (_, index) => const TProductCardVertical()),
                  const SizedBox(
                    height: TSizes.md,
                  ),
                  TextButton(
                    onPressed: () {
                      // goSelectServices();
                    },
                    child: Text("QR CODE"),
                  ),
                  TextButton(
                    onPressed: () {
                      // goSelectTime();
                    },
                    child: Text("Statistics"),
                  )
                ],
              ),
            )
          ],
        ),
      )),
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

class TFlashAction extends StatelessWidget {
  const TFlashAction({
    super.key,
    required this.title,
    required this.iconData,
    required this.onPressed,
  });

  final String title;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: THelperFunctions.screenWidth(context) * 0.25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TRoundedIcon(
                icon: iconData,
                color: TColors.primary,
                backgroundColor: TColors.primaryBackground,
                borderRadius: TSizes.sm,
              ),
              const SizedBox(
                height: TSizes.sm / 2,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              )
            ],
          )),
    );
  }
}

class TSearchHome extends StatelessWidget {
  const TSearchHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.md),
      child: GestureDetector(
          onTap: () => goSearch(),
          child: TRoundedContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: TSizes.md),
                  child: Text(AppLocalizations.of(context)!.search, style: Theme.of(context).textTheme.bodySmall),
                ),
                const TRoundedIcon(icon: Iconsax.search_favorite)
              ],
            ),
          )),
    );
  }
}
