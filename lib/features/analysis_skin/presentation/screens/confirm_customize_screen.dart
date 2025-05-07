import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/mix_data.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/order_mix.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/payment_detail_mix.dart';
import 'package:spa_mobile/features/home/presentation/blocs/mix/mix_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_voucher/list_voucher_bloc.dart';
import 'package:spa_mobile/features/product/presentation/screens/voucher_screen.dart';
import 'package:spa_mobile/features/product/presentation/widgets/payment_method.dart';
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
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text(
          AppLocalizations.of(context)!.review_and_confirm,
          style: Theme.of(context)!.textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(TSizes.sm),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.md),
              TRoundedContainer(
                padding: EdgeInsets.all(TSizes.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
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
              if (listProduct.isNotEmpty)
                Text(
                  AppLocalizations.of(context)!.products,
                  style: Theme.of(context)!.textTheme.bodyLarge,
                ),
              if (listProduct.isNotEmpty)
                const SizedBox(
                  height: TSizes.sm,
                ),
              if (listProduct.isNotEmpty)
                TRoundedContainer(
                  padding: EdgeInsets.all(TSizes.sm),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listProduct.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: TSizes.md,
                      );
                    },
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
                ),
              const SizedBox(
                height: TSizes.lg,
              ),
              if (listService.isNotEmpty)
                Text(
                  AppLocalizations.of(context)!.services,
                  style: Theme.of(context)!.textTheme.bodyLarge,
                ),
              if (listService.isNotEmpty)
                const SizedBox(
                  height: TSizes.sm,
                ),
              if (listService.isNotEmpty)
                TRoundedContainer(
                  padding: EdgeInsets.all(
                    TSizes.sm,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
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
                ),
              const SizedBox(
                height: TSizes.lg,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.shop_voucher, style: Theme.of(context).textTheme.bodyMedium),
                  GestureDetector(
                      onTap: () {
                        _showVoucherModal(context, widget.controller.totalPrice, widget.controller);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.controller.voucher != null)
                            Text(
                              widget.controller.voucher?.code ?? "",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (widget.controller.voucher == null)
                            Text(AppLocalizations.of(context)!.select_or_enter_code, style: Theme.of(context).textTheme.bodySmall),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          )
                        ],
                      ))
                ],
              ),
              const SizedBox(height: TSizes.md),
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.sm),
                child: TPaymentDetailMix(
                    total: widget.controller.totalPrice,
                    promotePrice: widget.controller.voucher?.discountAmount ?? 0,
                    priceProduct: widget.controller.productQuantities.fold(0.0, (a, b) => a + b.quantity * b.product.price),
                    priceService: widget.controller.services.fold(0.0, (a, b) => a + b.price)),
              ),
              TPaymentMethod(
                initialMethod: 'PayOs',
                onChanged: (method) {
                  widget.controller.updateMethod(method);
                },
              ),
              const SizedBox(height: TSizes.md),
              BlocListener<MixBloc, MixState>(
                  listener: (context, state) {
                    if (state is OrderMixError) {
                      TSnackBar.errorSnackBar(context, message: state.message);
                    }
                    if (state is OrderMixSuccess) {
                      TSnackBar.successSnackBar(context, message: "Đơn hàng đã được tạo thành công.");
                      goOrderMixDetail(state.id);
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<MixBloc>().add(OrderMixEvent(OrderMixParams(
                              customerId: widget.controller.user?.userId ?? 0,
                              branchId: widget.controller.branchId,
                              voucherId: widget.controller.voucher?.voucherId ?? null,
                              productBranchIds: widget.controller.productQuantities.map((x) => x.productBranchId).toList(),
                              productQuantities: widget.controller.productQuantities.map((x) => x.quantity).toList(),
                              serviceIds: widget.controller.services.map((x) => x.serviceId).toList(),
                              serviceQuantities: List.generate(widget.controller.services.length, (index) => 1),
                              staffIds: widget.controller.staffIds,
                              appointmentDates: isAuto ? [DateTime.now().add(const Duration(days: 2))] : widget.controller.timeStart,
                              totalAmount: widget.controller.totalPrice,
                              paymentMethod: widget.controller.method,
                              isAuto: widget.controller.isAuto)));
                        },
                        child: Text(AppLocalizations.of(context)!.order)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

void _showVoucherModal(BuildContext context, double currentTotalPrice, MixDataController controller) {
  final user = controller.user!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              left: TSizes.md,
              right: TSizes.md,
              top: TSizes.md,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.available_vouchers,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 500,
                  child: BlocProvider<ListVoucherBloc>(
                    create: (context) =>
                        ListVoucherBloc(getVouchers: serviceLocator())..add(GetVoucherByDateEvent(DateTime.now().toUtc().toString())),
                    child: BlocBuilder<ListVoucherBloc, ListVoucherState>(
                      builder: (context, state) {
                        if (state is ListVoucherLoaded) {
                          final vouchers = [...state.vouchers]..sort((a, b) {
                              bool isInvalid(VoucherModel v) =>
                                  (user.bonusPoint ?? 0) < (v.requirePoint ?? 0) || currentTotalPrice < (v.minOrderAmount ?? 0);

                              return isInvalid(a) == isInvalid(b) ? 0 : (isInvalid(a) ? 1 : -1);
                            });

                          return ListView.builder(
                            shrinkWrap: false,
                            padding: const EdgeInsets.only(top: TSizes.md),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.vouchers.length,
                            itemBuilder: (BuildContext context, int index) {
                              final voucher = vouchers[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: ((user.bonusPoint ?? 0) < voucher.requirePoint || currentTotalPrice < (voucher.minOrderAmount ?? 0))
                                    ? TColors.grey
                                    : TColors.primaryBackground.withOpacity(0.9),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.local_offer,
                                    color:
                                        ((user.bonusPoint ?? 0) < voucher.requirePoint || currentTotalPrice < (voucher.minOrderAmount ?? 0))
                                            ? TColors.darkerGrey
                                            : Colors.green,
                                  ),
                                  title: GestureDetector(onTap: () => _showVoucherDetail(context, voucher), child: Text(voucher.code)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(formatMoney(voucher.discountAmount.toString())),
                                      if ((user.bonusPoint ?? 0) < voucher.requirePoint)
                                        Text(
                                            '${AppLocalizations.of(context)!.need_more} ${voucher.requirePoint - (user.bonusPoint ?? 0).toInt()} ${AppLocalizations.of(context)!.points_required_to_use}',
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.darkerGrey)),
                                      if (currentTotalPrice < (voucher.minOrderAmount ?? 0))
                                        Text(
                                            '${AppLocalizations.of(context)!.buy_more} ${formatMoney((voucher.minOrderAmount ?? 0 - currentTotalPrice).toString())} ${AppLocalizations.of(context)!.to_use_this_code}',
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.darkerGrey)),
                                    ],
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed:
                                        ((user.bonusPoint ?? 0) < voucher.requirePoint || currentTotalPrice < (voucher.minOrderAmount ?? 0))
                                            ? null
                                            : () {
                                                controller.updateVoucher(voucher);
                                                controller.updateTotalPrice(
                                                    (controller.productQuantities.fold(0.0, (a, b) => a + b.quantity * b.product.price) +
                                                            controller.services.fold(0.0, (a, b) => a + b.price)) -
                                                        (controller.voucher?.discountAmount.toDouble() ?? 0));
                                                goReviewChangeRoutine(controller);
                                              },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.apply,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: Colors.white,
                                            fontSize: TSizes.md,
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is ListVoucherLoading) {
                          return ListView.builder(
                            shrinkWrap: false,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TShimmerEffect(width: THelperFunctions.screenWidth(context) * 0.7, height: TSizes.shimmerMd),
                                  TShimmerEffect(width: TSizes.shimmerMd, height: TSizes.shimmerSm)
                                ],
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showVoucherDetail(BuildContext context, VoucherModel voucher) {
  showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(heightFactor: 0.6, child: VoucherScreen(voucherModel: voucher));
      });
}
