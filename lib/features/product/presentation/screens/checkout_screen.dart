import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/order/order_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/ship_fee/ship_fee_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_checkout.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/init_dependencies.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.controller});

  final PurchasingDataController controller;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final products = widget.controller.products;
    return Scaffold(
        appBar: TAppbar(
          showBackArrow: true,
          title: Text(
            AppLocalizations.of(context)!.checkout,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ShipFeeBloc>(
                create: (context) =>
                    ShipFeeBloc(getLeadTime: serviceLocator(), getFeeShipping: serviceLocator(), getAvailableService: serviceLocator())),
          ],
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
            child: SingleChildScrollView(
              child: BlocListener<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is OrderError) {
                    TSnackBar.errorSnackBar(context, message: state.message);
                  }
                  if (state is OrderSuccess) {
                    // goSuccess(AppLocalizations.of(context)!.paymentSuccessTitle, AppLocalizations.of(context)!.paymentSuccessSubTitle,
                    //     () => goFeedback(), TImages.success);
                    context
                        .read<CartBloc>()
                        .add(RemoveProductFromCartEvent(ids: widget.controller.products.map((x) => x.productBranchId.toString()).toList()));
                    goOrderProductDetail(state.orderId);
                  }
                },
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TContactInformation(controller: widget.controller),
                            const SizedBox(
                              height: TSizes.md,
                            ),
                            TProductCheckout(
                              messageController: _messageController,
                              products: products,
                              controller: widget.controller,
                            ),
                            const SizedBox(
                              height: TSizes.md,
                            ),
                            TPaymentMethod(
                              initialMethod: 'payOs',
                              onChanged: (method) {
                                widget.controller.updateMethod(method);
                              },
                            ),
                            const SizedBox(
                              height: TSizes.md,
                            ),
                            TPaymentDetail(
                              controller: widget.controller,
                            )
                          ],
                        ),
                        if (state is OrderLoading) const TLoader()
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: TBottomCheckout(
          controller: widget.controller,
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}

class TPaymentDetail extends StatelessWidget {
  const TPaymentDetail({
    super.key,
    required this.controller,
  });

  final PurchasingDataController controller;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      radius: 10,
      padding: const EdgeInsets.all(TSizes.sm),
      borderColor: TColors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.payment_details, style: Theme.of(context).textTheme.bodyLarge),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.total_order_amount, style: Theme.of(context).textTheme.bodyMedium),
                  TProductPriceText(
                    price: (controller.products.fold(0.0, (x, y) => x += y.product.price.toDouble() * y.quantity)).toString(),
                    isLarge: false,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.shipping_fee, style: Theme.of(context).textTheme.bodyMedium),
                  BlocBuilder<ShipFeeBloc, ShipFeeState>(
                    builder: (context, state) {
                      if (state is ShipFeeLoaded && state.fee != 0) {
                        return TProductPriceText(
                          price: (state.fee).toString(),
                          isLarge: false,
                        );
                      } else if (state is ShipFeeLoaded && state.fee == 0) {
                        return const TShimmerEffect(width: TSizes.shimmerMd, height: TSizes.shimmerSx);
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
              if (controller.voucher != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Phí giảm giá', style: Theme.of(context).textTheme.bodyMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('- '),
                        TProductPriceText(
                          price: (controller.voucher?.discountAmount ?? 0).toString(),
                          isLarge: false,
                        ),
                      ],
                    )
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.total_payment, style: Theme.of(context).textTheme.bodyMedium),
                  BlocBuilder<ShipFeeBloc, ShipFeeState>(
                    builder: (context, state) {
                      if (state is ShipFeeLoaded && state.fee != 0) {
                        return TProductPriceText(
                          price: (controller.products.fold(0.0, (x, y) => x += y.product.price.toDouble() * y.quantity) +
                                  state.fee -
                                  (controller.voucher?.discountAmount.toDouble() ?? 0))
                              .toString(),
                        );
                      } else if (state is ShipFeeLoaded && state.fee == 0) {
                        return const TShimmerEffect(width: TSizes.shimmerMd, height: TSizes.shimmerSx);
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TPaymentMethod extends StatefulWidget {
  const TPaymentMethod({
    super.key,
    required this.onChanged,
    this.initialMethod = 'payOs',
  });

  final String initialMethod;
  final Function(String method) onChanged;

  @override
  State<TPaymentMethod> createState() => _TPaymentMethodState();
}

class _TPaymentMethodState extends State<TPaymentMethod> {
  late String selectedMethod;

  @override
  void initState() {
    super.initState();
    selectedMethod = widget.initialMethod;
  }

  void _selectMethod(String method) {
    setState(() {
      selectedMethod = method;
    });
    widget.onChanged(method);
  }

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      radius: 10,
      padding: const EdgeInsets.all(TSizes.sm),
      borderColor: TColors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.payment_method, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: TSizes.sm),

          /// Cash Option
          GestureDetector(
            onTap: () => _selectMethod('cash'),
            child: Row(
              children: [
                const Icon(Iconsax.money_send, color: TColors.primary),
                const SizedBox(width: TSizes.sm),
                Text(AppLocalizations.of(context)!.cash, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                if (selectedMethod == 'cash') const Icon(Iconsax.tick_circle, color: TColors.primary),
              ],
            ),
          ),

          const SizedBox(height: TSizes.sm),

          /// Bank Transfer Option
          GestureDetector(
            onTap: () => _selectMethod('payOs'),
            child: Row(
              children: [
                const Icon(Iconsax.wallet, color: TColors.primary),
                const SizedBox(width: TSizes.sm),
                Text(AppLocalizations.of(context)!.bank_transfer, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                if (selectedMethod == 'payOs') const Icon(Iconsax.tick_circle, color: TColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TContactInformation extends StatelessWidget {
  const TContactInformation({
    super.key,
    required this.controller,
  });

  final PurchasingDataController controller;

  @override
  Widget build(BuildContext context) {
    final shipment = controller.shipment;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.md * 2 / 3),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: THelperFunctions.screenWidth(context) * 0.5,
                    ),
                    child: Text(
                      shipment.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: THelperFunctions.screenWidth(context) * 0.3,
                    child: Text(
                      shipment.phoneNumber,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: THelperFunctions.screenWidth(context) * 0.8,
                child: Text(
                  shipment.address,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            ],
          ),
          TRoundedIcon(
            icon: Iconsax.edit,
            width: 30,
            size: 20,
            height: 30,
            onPressed: () {
              goShipmentInfo(controller);
            },
          )
        ],
      ),
    );
  }
}

class TBottomCheckout extends StatelessWidget {
  const TBottomCheckout({
    super.key,
    required this.controller,
  });

  final PurchasingDataController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: TSizes.md),
          ElevatedButton(
            onPressed: () {
              context.read<OrderBloc>().add(CreateOrderEvent(CreateOrderParams(
                  userId: controller.user!.userId,
                  totalAmount: controller.totalPrice,
                  voucherId: controller.voucher?.voucherId ?? null,
                  paymentMethod: controller.method,
                  products: controller.products,
                  estimatedDeliveryDate: controller.expectedDate,
                  shippingCost: controller.shippingCost.toDouble(),
                  recipientAddress: controller.shipment.address,
                  recipientName: controller.shipment.name,
                  recipientPhone: controller.shipment.phoneNumber)));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
            ),
            child: Text(
              AppLocalizations.of(context)!.order,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: TSizes.md,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
