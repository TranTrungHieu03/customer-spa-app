import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/inherited/appointment_data.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/banners.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_feedback_service.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_feedback_service/list_feedback_service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/service/service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/service_detail_shimmer.dart';
import 'package:spa_mobile/init_dependencies.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key, required this.serviceId, required this.branchId, required this.controller});

  final int serviceId;
  final int branchId;
  final AppointmentDataController controller;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late CarouselSliderController _carouselController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    context.read<ServiceBloc>().add(GetServiceDetailEvent(widget.serviceId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceBloc, ServiceState>(
      listener: (context, state) {
        if (state is ServiceDetailFailure) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      child: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const TServiceDetailShimmer();
          } else if (state is ServiceDetailSuccess) {
            final serviceData = state.service;
            return BlocProvider(
              create: (context) => ListFeedbackServiceBloc(getListServiceFeedback: serviceLocator())
                ..add(GetListFeedbackServiceEvent(GetListFeedbackServiceParams(widget.serviceId))),
              child: Scaffold(
                appBar: const TAppbar(
                  showBackArrow: true,
                  actions: [
                    // TRoundedIcon(
                    //   icon: Iconsax.shopping_bag,
                    //   color: TColors.primary,
                    //   size: 25,
                    //   backgroundColor: TColors.primaryBackground,
                    // ),
                    // SizedBox(
                    //   width: TSizes.sm,
                    // )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CarouselSlider(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                  pageSnapping: true,
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: false,
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  onPageChanged: (index, _) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                  aspectRatio: 3 / 2),
                              items: serviceData.images
                                  .map((banner) => TRoundedImage(
                                        imageUrl: banner,
                                        applyImageRadius: false,
                                        isNetworkImage: true,
                                        fit: BoxFit.cover,
                                        onPressed: () => {},
                                        width: THelperFunctions.screenWidth(context),
                                      ))
                                  .toList()),
                          if (_currentIndex > 0)
                            Positioned(
                              left: 0,
                              child: TRoundedIcon(
                                icon: Iconsax.arrow_left_2,
                                backgroundColor: Colors.transparent,
                                onPressed: () {
                                  _carouselController.previousPage();
                                },
                              ),
                            ),
                          if (_currentIndex < banners.length - 1)
                            Positioned(
                              right: 0,
                              child: TRoundedIcon(
                                icon: Iconsax.arrow_right_34,
                                backgroundColor: Colors.transparent,
                                onPressed: () {
                                  _carouselController.nextPage();
                                },
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(TSizes.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  serviceData.serviceCategory?.name ?? "",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                // TRoundedContainer(
                                //   radius: 20,
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(TSizes.sm),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       crossAxisAlignment: CrossAxisAlignment.center,
                                //       children: [
                                //         const Icon(
                                //           Iconsax.star,
                                //           color: Colors.yellow,
                                //         ),
                                //         const SizedBox(
                                //           width: TSizes.sm,
                                //         ),
                                //         Text(TProductDetail.rate)
                                //       ],
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                            TProductTitleText(
                              title: serviceData.name,
                              maxLines: 4,
                            ),
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.alarm_on,
                                      color: TColors.primary,
                                    ),
                                    const SizedBox(
                                      width: TSizes.sm,
                                    ),
                                    Text(
                                      serviceData.duration.toString(),
                                    ),
                                    Text(AppLocalizations.of(context)!.minutes)
                                  ],
                                ),
                                TProductPriceText(
                                  price: serviceData.price.toString(),
                                  isLarge: true,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: TSizes.md,
                            ),
                            Text(AppLocalizations.of(context)!.about_the_service, style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            Text(serviceData.description, style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            Text(AppLocalizations.of(context)!.step + ": ", style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            Text(serviceData.steps, style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(
                              height: TSizes.md,
                            ),
                            // Text("Related Service", style: Theme.of(context).textTheme.bodyLarge),
                            // const TRelatedService()
                            //Comment
                            BlocBuilder<ListFeedbackServiceBloc, ListFeedbackServiceState>(
                              builder: (context, state) {
                                if (state is ListFeedbackServiceLoaded) {
                                  return Padding(
                                    padding: const EdgeInsets.all(TSizes.sm),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.feedback,
                                              style: Theme.of(context)!.textTheme.titleLarge,
                                            ),
                                            TRoundedContainer(
                                              radius: 20,
                                              child: Padding(
                                                padding: const EdgeInsets.all(TSizes.sm),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    const SizedBox(
                                                      width: TSizes.sm,
                                                    ),
                                                    Text(state.average.toString() ?? '5.0')
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: TSizes.sm,
                                        ),
                                        if (state.feedbacks.isEmpty)
                                          Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(AppLocalizations.of(context)!.no_feedback_for_service)),
                                        SizedBox(
                                          height: 400,
                                          child: ListView.separated(
                                              itemBuilder: (context, index) {
                                                final comment = state.feedbacks[index];

                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(comment.customer?.fullName ?? AppLocalizations.of(context)!.user),
                                                        RatingBar.builder(
                                                          initialRating: comment.rating?.toDouble() ?? 5,
                                                          minRating: 1,
                                                          direction: Axis.horizontal,
                                                          allowHalfRating: false,
                                                          itemCount: 5,
                                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                          itemBuilder: (context, _) => const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          itemSize: 21,
                                                          onRatingUpdate: (_) {},
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: TSizes.sm,
                                                    ),
                                                    TRoundedContainer(
                                                      width: THelperFunctions.screenWidth(context),
                                                      padding: const EdgeInsets.all(TSizes.sm),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [Text(comment.comment ?? "")],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: TSizes.sm / 2,
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        DateFormat("HH:mm, dd/MM/yyyy").format(
                                                            DateTime.parse(comment.createdAt).toUtc().toLocal().add(Duration(hours: 7))),
                                                        style: Theme.of(context)!.textTheme.labelMedium,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                              separatorBuilder: (context, index) {
                                                return const SizedBox(
                                                  height: TSizes.md,
                                                );
                                              },
                                              itemCount: state.feedbacks.length),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (state is ListFeedbackServiceLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: TColors.primary,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                bottomNavigationBar: Row(
                  children: [
                    // Expanded(
                    //     flex: 2,
                    //     child: GestureDetector(
                    //       onTap: () {},
                    //       child: Container(
                    //         height: 55,
                    //         decoration: const BoxDecoration(color: TColors.primaryBackground),
                    //         padding: const EdgeInsets.all(TSizes.sm / 2),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             const Icon(
                    //               Iconsax.shopping_cart,
                    //               color: TColors.primary,
                    //             ),
                    //             Text(
                    //               AppLocalizations.of(context)!.addToCart,
                    //               style: Theme.of(context).textTheme.labelMedium,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     )),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          widget.controller.updateServiceIds([widget.serviceId]);
                          widget.controller
                              .updateTime(int.parse((context.read<ServiceBloc>().state as ServiceDetailSuccess).service.duration));
                          widget.controller.updateServices([(context.read<ServiceBloc>().state as ServiceDetailSuccess).service]);
                          widget.controller.updateTotalPrice((context.read<ServiceBloc>().state as ServiceDetailSuccess).service.price);
                          goSelectSpecialist(widget.branchId, widget.controller);
                        },
                        child: Container(
                          height: 55,
                          decoration: const BoxDecoration(
                            color: TColors.primary,
                          ),
                          padding: const EdgeInsets.all(TSizes.sm / 2),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.book_now,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const ErrorScreen();
        },
      ),
    );
  }
}
