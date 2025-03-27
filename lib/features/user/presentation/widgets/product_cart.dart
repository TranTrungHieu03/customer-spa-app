import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/product/presentation/cubit/checkbox_cart_cubit.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_title.dart';

class TProductCart extends StatelessWidget {
  final PurchasingDataController controller;
  final List<ProductCartModel> products;

  const TProductCart({super.key, required this.controller, required this.products});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckboxCartCubit(products.map((x) => x.product.productBranchId).toList()),
      child: Scaffold(
        body: ListView.separated(
            itemBuilder: (context, index) {
              final productCart = products[index];
              return Dismissible(
                key: Key(index.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  context.read<CartBloc>().add(RemoveProductFromCartEvent(id: productCart.product.productBranchId.toString()));
                  TSnackBar.successSnackBar(context, message: "Xóa sản phẩm thaành công");
                },
                background: Container(
                  color: Colors.redAccent.withOpacity(0.8),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Iconsax.shop_remove,
                        color: Colors.white,
                        size: TSizes.lg,
                      ),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: TProductCartItem(
                    index: index,
                    product: productCart.product,
                  ),
                ), // Pass the index to TProductCart
              );
            },
            separatorBuilder: (_, __) {
              return const SizedBox(
                height: TSizes.sm,
              );
            },
            itemCount: products.length),
        bottomNavigationBar: BlocBuilder<CheckboxCartCubit, CheckboxCartState>(
          builder: (context, state) {
            if (state is CheckboxCartInitial) {
              final selectedProducts = products.where((product) {
                final cartState = state.itemStates.firstWhere(
                  (item) => item.id == product.product.productBranchId,
                );
                return cartState.status;
              }).toList();

              // Tính tổng giá
              double totalPrice = selectedProducts.fold(0, (sum, item) => sum + item.product.price);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: state.isAllSelected,
                          onChanged: (bool? newValue) {
                            context.read<CheckboxCartCubit>().toggleSelectAll(newValue ?? false);
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)!.all,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.totalPayment,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: TSizes.sm / 2),
                        // Hiển thị tổng giá đã tính
                        TProductPriceText(price: totalPrice.toStringAsFixed(2)),
                        const SizedBox(width: TSizes.md),
                        ElevatedButton(
                          onPressed: selectedProducts.isNotEmpty
                              ? () {
                                  final List<ProductQuantity> checkoutItems = selectedProducts.map((productCart) {
                                    return ProductQuantity(
                                        quantity: productCart.quantity,
                                        productBranchId: productCart.product.productBranchId,
                                        product: productCart.product);
                                  }).toList();
                                  controller.updateProducts(checkoutItems);
                                  goCheckout(controller);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: 10),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.buy,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: TSizes.md,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class TProductCartItem extends StatefulWidget {
  final int index;
  final ProductModel product;

  const TProductCartItem({
    super.key,
    required this.index,
    required this.product,
  });

  @override
  _TProductCartItemState createState() => _TProductCartItemState();
}

class _TProductCartItemState extends State<TProductCartItem> {
  late TextEditingController _quantityController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    int currentQuantity = int.tryParse(_quantityController.text) ?? 0;
    if (currentQuantity < widget.product.stockQuantity) {
      setState(() {
        currentQuantity++;
        _quantityController.text = currentQuantity.toString();
        _isEditing = true;
      });
    } else {
      TSnackBar.warningSnackBar(context, message: "Số lượng không đượt vượt quá ${widget.product.stockQuantity}");
    }
  }

// Helper method to decrement quantity
  void _decrementQuantity() {
    int currentQuantity = int.tryParse(_quantityController.text) ?? 0;
    if (currentQuantity > 1) {
      setState(() {
        currentQuantity--;
        _quantityController.text = currentQuantity.toString();
        _isEditing = true;
      });
    } else {
      TSnackBar.warningSnackBar(context, message: "Bạn có chắc muốn xóa sản phẩm này");
    }
  }

  void _saveQuantity() {
    int? quantity = int.tryParse(_quantityController.text);
    if (quantity != null && quantity > 0 && quantity < 1000) {
      // Add event to update cart quantity
      context.read<CartBloc>().add(AddProductToCartEvent(
          params: AddProductCartParams(userId: 0, productId: widget.product.productId, quantity: quantity, operation: 0)));

      setState(() {
        _isEditing = false;
      });
    } else {
      // Show error if quantity is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số lượng hợp lệ (1-999)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckboxCartCubit, CheckboxCartState>(
      builder: (context, state) {
        if (state is CheckboxCartInitial) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.sm / 2, vertical: TSizes.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 0.2,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Column(
              children: [
                // Brand row remains the same
                Row(
                  children: [
                    const Icon(Iconsax.shop),
                    const SizedBox(width: TSizes.spacebtwItems / 2),
                    Text(
                      widget.product.brand,
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
                SizedBox(
                  width: THelperFunctions.screenWidth(context),
                  child: const Divider(thickness: 0.2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Checkbox remains the same
                    Checkbox(
                      value: state.itemStates[widget.index].status ?? false,
                      onChanged: (bool? newValue) {
                        context.read<CheckboxCartCubit>().toggleItemCheckbox(state.itemStates[widget.index].id, newValue ?? false);
                      },
                    ),
                    // Product image
                    TRoundedImage(
                      imageUrl: widget.product.images!.isNotEmpty ? widget.product.images![0] : TImages.product1,
                      applyImageRadius: true,
                      isNetworkImage: widget.product.images!.isNotEmpty,
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
                          maxWidth: THelperFunctions.screenWidth(context) * 0.5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product title
                            TProductTitleText(
                              title: widget.product.productName,
                              maxLines: 2,
                              smallSize: true,
                            ),
                            // Product price
                            TProductPriceText(
                              price: widget.product.price.toString(),
                            ),
                            const SizedBox(height: TSizes.spacebtwItems / 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Decrement button
                                GestureDetector(
                                  onTap: _decrementQuantity,
                                  child: TRoundedIcon(
                                    icon: Iconsax.minus,
                                    backgroundColor: TColors.primary.withOpacity(0.05),
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                const SizedBox(width: TSizes.sm / 2),
                                // Quantity input
                                SizedBox(
                                  width: THelperFunctions.screenWidth(context) * 0.15,
                                  height: THelperFunctions.screenWidth(context) * 0.1,
                                  child: TextFormField(
                                    controller: _quantityController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(TSizes.sm),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        // Validate input doesn't exceed stock quantity
                                        int parsedValue = int.tryParse(value) ?? 0;
                                        if (parsedValue > widget.product.stockQuantity) {
                                          TSnackBar.warningSnackBar(context,
                                              message: "Số lượng không đượt vượt quá ${widget.product.stockQuantity}");
                                          _quantityController.text = widget.product.stockQuantity.toString();
                                          parsedValue = widget.product.stockQuantity;
                                        }
                                        _isEditing = true;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: TSizes.sm / 2),
                                // Increment button
                                GestureDetector(
                                  onTap: _incrementQuantity,
                                  child: TRoundedIcon(
                                    icon: Iconsax.add,
                                    width: 40,
                                    backgroundColor: TColors.primary.withOpacity(0.05),
                                    height: 40,
                                  ),
                                ),
                                if (_isEditing)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.save,
                                      size: 25,
                                      color: TColors.primary,
                                    ),
                                    onPressed: _saveQuantity,
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
