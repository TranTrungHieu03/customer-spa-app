import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_available_service.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_fee_shipping.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_lead_time.dart';
import 'package:spa_mobile/features/product/presentation/bloc/ship_fee/ship_fee_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';

import 'product_price.dart';

class TProductCheckout extends StatefulWidget {
  const TProductCheckout({
    super.key,
    required this.products,
    required this.controller,
  });

  final List<ProductQuantity> products;
  final PurchasingDataController controller;

  @override
  State<TProductCheckout> createState() => _TProductCheckoutState();
}

class _TProductCheckoutState extends State<TProductCheckout> {
  @override
  Widget build(BuildContext context) {
    final products = widget.products;
    final controller = widget.controller;
    final branch = widget.controller.branch;
    final shipment = widget.controller.shipment;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 0.2,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (context, index) {
              final product = products[index].product;
              return Column(
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.shop),
                      const SizedBox(
                        width: TSizes.spacebtwItems / 2,
                      ),
                      Text(
                        product.brand,
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ],
                  ),
                  SizedBox(
                      width: THelperFunctions.screenWidth(context),
                      child: const Divider(
                        thickness: 0.2,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TRoundedImage(
                        imageUrl: product.images!.isNotEmpty ? product.images![0] : TImages.product1,
                        applyImageRadius: true,
                        isNetworkImage: product.images!.isNotEmpty,
                        onPressed: () => {},
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                        width: THelperFunctions.screenWidth(context) * 0.28,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: TSizes.sm),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: THelperFunctions.screenWidth(context) * 0.6,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TProductTitleText(
                                title: product.productName,
                                maxLines: 2,
                                smallSize: true,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TProductPriceText(
                                    price: product.price.toString(),
                                  ),
                                  Text(
                                    'x${products[index].quantity.toString()}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: TSizes.sm,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
            itemCount: products.length,
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
                    _showVoucherModal(context);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(AppLocalizations.of(context)!.select_or_enter_code, style: Theme.of(context).textTheme.bodySmall),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.message_to_shop, style: Theme.of(context).textTheme.bodyMedium),
              GestureDetector(
                  onTap: () {
                    _showMessageModal(context);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(AppLocalizations.of(context)!.leave_a_message, style: Theme.of(context).textTheme.bodySmall),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.shipping_carrier, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
          BlocListener<ShipFeeBloc, ShipFeeState>(
            listener: (context, state) {
              if (state is ShipFeeError) {
                TSnackBar.errorSnackBar(context, message: state.message);
              }
              if (state is ShipFeeLoadedServiceId) {
                widget.controller.updateServiceGHN(state.serviceId);
                context.read<ShipFeeBloc>().add(GetLeadTimeEvent(GetLeadTimeParams(
                      fromDistrictId: branch!.district,
                      fromWardCode: branch.wardCode.toString(),
                      toDistrictId: int.parse(shipment.districtId),
                      toWardCode: shipment.wardCode,
                      serviceId: state.serviceId,
                    )));
              }
              if (state is ShipFeeLoaded && state.leadTime.isNotEmpty && state.fee == 0) {
                controller.updateExpectedDate(state.leadTime);
                context.read<ShipFeeBloc>().add(GetShipFeeEvent(GetFeeShippingParams(
                      fromDistrictId: branch!.district,
                      fromWardCode: branch.wardCode.toString(),
                      serviceId: widget.controller.serviceGHN,
                      toDistrictId: int.parse(shipment.districtId),
                      toWardCode: shipment.wardCode,
                      height: 50,
                      length: 50,
                      weight: widget.products.fold<int>(0, (x, y) => x + y.product.volume.toInt()),
                      width: 50,
                    )));
              }
              if (state is ShipFeeLoaded && state.fee != 0) {
                controller.updateShippingCost(state.fee);
                controller.updateTotalPrice(widget.products.fold(0.0, (x, y) => x += y.product.price.toDouble() * y.quantity) + state.fee);
              }
            },
            child: BlocBuilder<ShipFeeBloc, ShipFeeState>(
              builder: (context, state) {
                if (state is ShipFeeLoaded && state.fee != 0) {
                  AppLogger.info(DateTime.parse(state.leadTime).toLocal());
                  return TRoundedContainer(
                    borderColor: Colors.greenAccent,
                    padding: EdgeInsets.all(TSizes.sm),
                    backgroundColor: Colors.greenAccent.withOpacity(0.4),
                    showBorder: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Giao hàng nhanh", style: Theme.of(context).textTheme.bodyLarge),
                            TProductPriceText(price: state.fee.toString()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Đảm bảo nhận hàng vào ${DateFormat('EEEE, dd MMMM yyyy', "vi").format(DateTime.parse(state.leadTime).toUtc().toLocal())}.",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (state is ShipFeeLoading) {
                  return const TLoader();
                }
                return const SizedBox();
              },
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.total_amount, style: Theme.of(context).textTheme.bodyMedium),
              BlocBuilder<ShipFeeBloc, ShipFeeState>(
                builder: (context, state) {
                  if (state is ShipFeeLoaded && state.fee != 0) {
                    return TProductPriceText(
                      price: (widget.products.fold(0.0, (x, y) => x += y.product.price.toDouble() * y.quantity) + state.fee).toString(),
                    );
                  } else if (state is ShipFeeLoaded && state.fee == 0) {
                    return const TShimmerEffect(width: TSizes.shimmerMd, height: TSizes.shimmerSx);
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Đảm bảo widget vẫn còn tồn tại
      final branch = widget.controller.branch;
      final shipment = widget.controller.shipment;

      if (branch == null || shipment.districtId == "0") {
        return;
      }

      final shipFeeBloc = context.read<ShipFeeBloc>();
      if (!shipFeeBloc.isClosed) {
        shipFeeBloc.add(GetAvailableServiceEvent(
            GetAvailableServiceParams(shopId: 3838500, fromDistrict: branch.district, toDistrict: int.parse(shipment.districtId))));
      }
    });
  }
}

void _showVoucherModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
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
              AppLocalizations.of(context)!.shop_voucher,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your voucher code",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Available Vouchers",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: false,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return _buildVoucherItem(context, index);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildVoucherItem(BuildContext context, int index) {
  final voucherTitles = [
    "10% Off for First Order",
    "Free Shipping on Orders Over \$50",
    "Buy 2 Get 1 Free",
    "Buy 3 Get 1 Free",
    "Buy 5 Get 2 Free",
  ];
  final voucherCodes = ["FIRST10", "FREE_SHIP50", "B2G1FREE", "B3G1FREE", "B5G2FREE"];

  return Card(
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      leading: const Icon(
        Icons.local_offer,
        color: Colors.green,
      ),
      title: Text(voucherTitles[index]),
      subtitle: Text("Code: ${voucherCodes[index]}"),
      trailing: ElevatedButton(
        onPressed: () {},
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
}

void _showMessageModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: TSizes.md,
          right: TSizes.md,
          top: TSizes.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.message_to_shop,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter your massage",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.submit,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: TSizes.md,
                          ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
