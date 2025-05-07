import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/styles/shadow_styles.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/notification.dart';
import 'package:spa_mobile/core/common/widgets/primary_header_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_current_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_history.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/image/image_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_routine/list_routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_all_notification.dart';
import 'package:spa_mobile/features/home/presentation/blocs/home_state/home_state_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/list_notification/list_notification_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/features/user/domain/usecases/get_recommend.dart';
import 'package:spa_mobile/features/user/presentation/bloc/recommend/recommend_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperHomeScreen extends StatelessWidget {
  const WrapperHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => ListRoutineBloc(getListRoutine: serviceLocator(), getHistoryRoutine: serviceLocator())),
      BlocProvider(create: (context) => RecommendBloc(getRcm: serviceLocator()))
    ], child: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  bool isLoading = true;
  UserChatModel? userChatModel;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (jsonDecode(userJson) != null) {
      setState(() {
        user = UserModel.fromJson(jsonDecode(userJson));
        isLoading = false;
      });
      if (user?.userId != 0 && user?.userId != null) {
        // context.read<RoutineBloc>().add(GetCurrentRoutineEvent(GetCurrentRoutineParams(user!.userId)));
        context
            .read<ListNotificationBloc>()
            .add(GetAllNotificationEvent(GetAllNotificationParams(userId: user!.userId, pageIndex: 1, pageSize: 10)));
        context.read<HomeStateBloc>().add(ResetDataEvent());
        context
            .read<HomeStateBloc>()
            .add(GetNotificationEvent(GetAllNotificationParams(userId: user!.userId, pageIndex: 1, pageSize: 10, isRead: false)));
        context.read<ListRoutineBloc>().add(GetSuitableRoutineEvent(GetRoutineHistoryParams(userId: user!.userId, status: "Suitable")));
        context.read<RecommendBloc>().add(GetListRecommendEvent(GetRecommendParams(user!.userId)));
      }
    } else {
      setState(() {
        isLoading = false;
      });
      goLoginNotBack();
    }

    final jsonUserChat = await LocalStorage.getData(LocalStorageKey.userChat);
    if (jsonUserChat != null && jsonUserChat.isNotEmpty) {
    } else {
      if (user?.userId != 0 && user?.userId != null) {
        context.read<RoutineBloc>().add(GetCurrentRoutineEvent(GetCurrentRoutineParams(user!.userId)));
      }
      goHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
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
                    BlocBuilder<HomeStateBloc, HomeStateState>(
                      builder: (context, state) {
                        if (state is HomeStateLoaded) {
                          return TNotificationIcon(
                              onPressed: () {
                                goNotification(user?.userId ?? 0);
                              },
                              iconColor: TColors.primary,
                              newNotifications: state.newNoti);
                        } else if (state is ListNotificationLoading) {
                          return const TShimmerEffect(width: TSizes.shimmerSx, height: TSizes.shimmerSx);
                        }
                        return const SizedBox();
                      },
                    ),
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
                          child: Column(
                            children: [
                              Row(
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
                                      _showImageSourceActionSheet(context);
                                    },
                                  ),
                                  TFlashAction(
                                    title: AppLocalizations.of(context)!.analysisData,
                                    iconData: Iconsax.document_1,
                                    onPressed: () => goFormData(SkinHealthModel.empty(), false),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: TSizes.sm,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TFlashAction(
                                    title: AppLocalizations.of(context)!.solaceConnect,
                                    iconData: Iconsax.message_2,
                                    onPressed: () => goChatList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  Text(AppLocalizations.of(context)!.recommended_package, style: Theme.of(context).textTheme.titleLarge),
                  BlocBuilder<ListRoutineBloc, ListRoutineState>(builder: (context, state) {
                    if (state is ListRoutineLoaded) {
                      if (state.suitable.where((e) => e.status.toLowerCase() == 'active').toList().isEmpty) {
                        return Text(AppLocalizations.of(context)!.no_package_found);
                      }
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final activeRoutine = state.suitable.where((e) => e.status.toLowerCase() == 'active').toList();
                            final routine = activeRoutine[index];
                            return GestureDetector(
                              onTap: () => goRoutineDetail(routine.skincareRoutineId.toString()),
                              child: Stack(children: [
                                TRoundedContainer(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(routine.name, style: Theme.of(context).textTheme.titleLarge),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(routine.description),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                formatMoney(routine.totalPrice.toString()),
                                                style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          goRoutineDetail(routine.skincareRoutineId.toString());
                                        },
                                      ),
                                      const SizedBox(
                                        height: TSizes.md,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            );
                          },
                          separatorBuilder: (context, state) {
                            return const SizedBox(
                              height: TSizes.sm,
                            );
                          },
                          itemCount: state.suitable.where((e) => e.status.toLowerCase() == 'active').length);
                    } else if (state is ListRoutineLoading) {
                      return SizedBox(
                        height: 230,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return TShimmerEffect(width: THelperFunctions.screenWidth(context), height: TSizes.shimmerMd);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: TSizes.sm,
                            );
                          },
                          itemCount: 2,
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  BlocBuilder<RecommendBloc, RecommendState>(
                    builder: (context, state) {
                      if (state is RecommendLoaded && state.data.services.isNotEmpty) {
                        final services = state.data.services;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.recommended_service, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(
                              height: TSizes.spacebtwItems,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                              margin: const EdgeInsets.symmetric(vertical: TSizes.xs),
                              height: 250,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: services.length,
                                separatorBuilder: (context, index) => const SizedBox(width: TSizes.md),
                                itemBuilder: (context, index) {
                                  final service = services[index];
                                  return GestureDetector(
                                    onTap: () => goServiceDetailWithBranch(service.serviceId),
                                    child: TRoundedContainer(
                                      width: THelperFunctions.screenWidth(context) * 0.45,
                                      // height: 150,
                                      radius: 10,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          TRoundedImage(
                                            applyImageRadius: true,
                                            imageUrl: service.images.isNotEmpty ? service.images[0] : TImages.thumbnailService,
                                            isNetworkImage: service.images.isNotEmpty,
                                            width: THelperFunctions.screenWidth(context) * 0.45,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(TSizes.sm),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      if (service.serviceCategory != null)
                                                        ConstrainedBox(
                                                            constraints: BoxConstraints(
                                                              maxWidth: THelperFunctions.screenWidth(context) * 0.44,
                                                            ),
                                                            child: TRoundedContainer(
                                                              padding:
                                                                  EdgeInsets.symmetric(horizontal: TSizes.xs, vertical: TSizes.xs * 0.5),
                                                              backgroundColor: TColors.primaryBackground,
                                                              child: Text(
                                                                service.serviceCategory?.name ?? "",
                                                                overflow: TextOverflow.ellipsis,
                                                                style: Theme.of(context).textTheme.labelMedium,
                                                                maxLines: 1,
                                                              ),
                                                            )),
                                                      ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                            maxWidth: THelperFunctions.screenWidth(context) * 0.44,
                                                          ),
                                                          child: TProductTitleText(
                                                            title: service.name,
                                                            smallSize: true,
                                                            maxLines: 2,
                                                          )),
                                                      // TProductPriceText(price: service.price.toString())
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  BlocBuilder<RecommendBloc, RecommendState>(
                    builder: (context, state) {
                      if (state is RecommendLoaded && state.data.products.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.recommended_product, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(
                              height: TSizes.spacebtwItems,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                              color: Colors.white,
                              height: 310,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.data.products.length,
                                separatorBuilder: (context, index) => const SizedBox(width: TSizes.md),
                                itemBuilder: (context, index) {
                                  final product = state.data.products[index];
                                  return Container(
                                      margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
                                      child: GestureDetector(
                                        child: Container(
                                          // width: ,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              boxShadow: [TShadowStyle.verticalProductShadow],
                                              borderRadius: BorderRadius.circular(TSizes.productImageRadius),
                                              color: dark ? TColors.darkerGrey : TColors.white),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              TRoundedContainer(
                                                height: TSizes.productHeight,
                                                width: THelperFunctions.screenWidth(context) * 0.45 + 15,
                                                padding: const EdgeInsets.all(TSizes.sm),
                                                backgroundColor: dark ? TColors.dark : TColors.light,
                                                child: Stack(
                                                  children: [
                                                    TRoundedImage(
                                                      width: THelperFunctions.screenWidth(context) * 0.45,
                                                      imageUrl: product.images!.isNotEmpty ? product.images![0] : TImages.product1,
                                                      applyImageRadius: true,
                                                      isNetworkImage: product.images!.isNotEmpty,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: TSizes.spacebtwItems / 2,
                                              ),

                                              //details

                                              GestureDetector(
                                                onTap: () => goProductDetailWithBranch(product.productId),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: TSizes.sm),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints(
                                                              maxWidth: THelperFunctions.screenWidth(context) * 0.45,
                                                            ),
                                                            child: TProductTitleText(
                                                              title: product.productName,
                                                              smallSize: true,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: TSizes.md,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
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

void _showImageSourceActionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.take_photo),
              onTap: () {
                // Navigator.of(ctx).pop();
                context.read<ImageBloc>().add(PickImageEvent(true));
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.choose_from_gallery),
              onTap: () {
                // Navigator.of(ctx).pop();
                context.read<ImageBloc>().add(PickImageEvent(false));
              },
            ),
          ],
        ),
      );
    },
  );
}
