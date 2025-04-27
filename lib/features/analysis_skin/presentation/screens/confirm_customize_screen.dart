import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/mix_data.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/order_mix.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/payment_detail_mix.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/init_dependencies.dart';

class ConfirmCustomizeScreen extends StatefulWidget {
  const ConfirmCustomizeScreen({super.key, required this.controller});

  final MixDataController controller;

  @override
  State<ConfirmCustomizeScreen> createState() => _ConfirmCustomizeScreenState();
}

class _ConfirmCustomizeScreenState extends State<ConfirmCustomizeScreen> {
  @override
  Widget build(BuildContext context) {
    final branch = widget.controller.branch;
    final listProduct = widget.controller.productQuantities;
    final listService = widget.controller.services;
    var isAuto = widget.controller.isAuto;
    return BlocProvider<RoutineBloc>(
      create: (context) => RoutineBloc(
          getRoutineDetail: serviceLocator(),
          bookRoutine: serviceLocator(),
          getCurrentRoutine: serviceLocator(),
          orderMix: serviceLocator()),
      child: BlocListener<RoutineBloc, RoutineState>(
        listener: (context, state) {
          if (state is RoutineError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
          if (state is OrderMixSuccess) {
            TSnackBar.successSnackBar(context, message: "Mua thanh cong");
          }
        },
        child: Scaffold(
          appBar: TAppbar(
            showBackArrow: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(TSizes.sm),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: TSizes.md),
                  TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.building,
                          color: TColors.primary,
                        ),
                        const SizedBox(
                          width: TSizes.sm,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branch?.branchName ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              branch?.branchAddress ?? "",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.md,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listProduct.length,
                    itemBuilder: (context, itemIndex) {
                      final productCart = listProduct[itemIndex];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TRoundedImage(
                            imageUrl: productCart.product.images!.isNotEmpty ? productCart.product.images![0] : TImages.product1,
                            applyImageRadius: true,
                            isNetworkImage: productCart.product.images!.isNotEmpty,
                            onPressed: () => {},
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1,
                            ),
                            width: THelperFunctions.screenWidth(context) * 0.28,
                            height: THelperFunctions.screenWidth(context) * 0.28,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: TSizes.sm),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    productCart.product.productName,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(productCart.product.brand,
                                      maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "x${productCart.quantity}",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        formatMoney(productCart.product.price.toString()),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: TSizes.md,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    // Cho phép ListView tính toán chiều cao theo nội dung
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.controller.services.length,
                    itemBuilder: (context, index) {
                      final service = widget.controller.services[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(service.name, style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(
                                height: TSizes.sm,
                              ),
                              Text(
                                "${service.duration} ${AppLocalizations.of(context)!.minutes}",
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.darkerGrey),
                              ),
                              const SizedBox(
                                height: TSizes.sm,
                              ),
                              if (!widget.controller.isAuto)
                                Text(
                                    '${AppLocalizations.of(context)!.specialist}: ${widget.controller.staff[index]?.staffInfo?.fullName ?? ""}',
                                    style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TProductPriceText(
                                price: service.price.toString(),
                                isLarge: false,
                              ),
                            ],
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: TSizes.sm,
                      );
                    },
                  ),
                  TPaymentDetailMix(
                      total: widget.controller.totalPrice,
                      priceProduct: widget.controller.productQuantities.fold(0.0, (a, b) => a + b.quantity * b.product.price),
                      priceService: widget.controller.services.fold(0.0, (a, b) => a + b.price)),
                  ElevatedButton(
                      onPressed: () {
                        context.read<RoutineBloc>().add(OrderMixEvent(OrderMixParams(
                            customerId: 63,
                            branchId: widget.controller.branchId,
                            voucherId: null,
                            productBranchIds: widget.controller.productQuantities.map((x) => x.productBranchId).toList(),
                            productQuantities: widget.controller.productQuantities.map((x) => x.quantity).toList(),
                            serviceIds: widget.controller.services.map((x) => x.serviceId).toList(),
                            serviceQuantities: List.generate(widget.controller.services.length, (index) => 1),
                            staffIds: widget.controller.staffIds,
                            appointmentDates: isAuto ? [DateTime.now().add(Duration(days: 1))] : widget.controller.timeStart,
                            totalAmount: widget.controller.totalPrice,
                            isAuto: widget.controller.isAuto)));
                      },
                      child: Text('Order'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
