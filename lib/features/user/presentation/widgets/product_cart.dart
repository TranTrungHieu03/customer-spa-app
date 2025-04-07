import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/rounded_image.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
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
  final List<BranchModel> branches;

  const TProductCart({super.key, required this.controller, required this.products, required this.branches});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckboxCartCubit(products),
      child: Scaffold(
        body: BlocBuilder<CheckboxCartCubit, CheckboxCartState>(
          builder: (context, state) {
            if (state is CheckboxCartInitial) {
              return ListView.separated(
                itemCount: state.branchGroups.length,
                separatorBuilder: (_, __) => const SizedBox(height: TSizes.md),
                itemBuilder: (context, groupIndex) {
                  final branchGroup = state.branchGroups[groupIndex];
                  return _buildBranchGroup(
                      context, branchGroup, branches.firstWhere((x) => x.branchId == branchGroup.branchId).branchName, state);
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        bottomNavigationBar: BlocBuilder<CheckboxCartCubit, CheckboxCartState>(
          builder: (context, state) {
            if (state is CheckboxCartInitial) {
              // Collect all selected product IDs
              final List<int> selectedProductIds = [];
              for (var group in state.branchGroups) {
                for (var item in group.items) {
                  if (item.status) {
                    selectedProductIds.add(item.id);
                  }
                }
              }

              // Find the product details for the selected IDs
              final selectedProducts = products.where((product) => selectedProductIds.contains(product.product.productBranchId)).toList();

              // Calculate total price
              // double totalPrice = selectedProducts.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
// Trong BlocBuilder của bottomNavigationBar
              final totalPrice = state.branchGroups.fold(0.0, (sum, group) {
                return sum +
                    group.items.fold(0.0, (groupSum, item) {
                      if (item.status) {
                        final product = products.firstWhere(
                          (p) => p.product.productBranchId == item.id,
                          orElse: () => throw Exception('Product not found'),
                        );
                        return groupSum + (product.product.price * item.quantity);
                      }
                      return groupSum;
                    });
              });
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
                        TProductPriceText(price: totalPrice.toStringAsFixed(2)),
                        const SizedBox(width: TSizes.md),
                        ElevatedButton(
                          onPressed: selectedProducts.isNotEmpty
                              ? () {
                                  final List<ProductQuantity> checkoutItems = state.branchGroups.expand((group) {
                                    return group.items.where((item) => item.status).map((item) {
                                      final product = products.firstWhere(
                                        (p) => p.product.productBranchId == item.id,
                                        orElse: () => throw Exception('Product not found'),
                                      );
                                      return ProductQuantity(
                                        quantity: item.quantity, // Lấy quantity từ Cubit thay vì từ productCart
                                        productBranchId: item.id,
                                        product: product.product,
                                      );
                                    });
                                  }).toList();
                                  //get list id branch choose
                                  final selectedBranchIds = checkoutItems.map((item) => item.product.branchId).toSet();
                                  if (selectedBranchIds.length > 1) {
                                    TSnackBar.infoSnackBar(context, message: "Vui lòng cập nhật thông tin địa chỉ để mua hàng");
                                    return;
                                  }

                                  controller.updateProducts(checkoutItems);
                                  if (controller.user?.wardCode == 0 || controller.user?.district == 0) {
                                    goProfile();
                                    TSnackBar.infoSnackBar(context, message: "Mỗi đơn hàng chỉ được mua từ một chi nhánh");
                                    return;
                                  }
                                  goCheckout(controller);
                                  AppLogger.info(branches.firstWhere((x) => x.branchId == checkoutItems.first.product.branchId).branchId);
                                  controller.updateBranch(branches.firstWhere((x) => x.branchId == checkoutItems.first.product.branchId));
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

  Widget _buildBranchGroup(BuildContext context, CartBranchGroup branchGroup, String branchName, CheckboxCartInitial state) {
    // Find the brand name from the first product in the group

    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Branch header with checkbox
          Padding(
            padding: const EdgeInsets.all(TSizes.sm),
            child: Row(
              children: [
                Checkbox(
                  value: branchGroup.isGroupSelected,
                  onChanged: (bool? newValue) {
                    context.read<CheckboxCartCubit>().toggleBranchGroup(branchGroup.branchId, newValue ?? false);
                  },
                ),
                const Icon(Iconsax.shop),
                const SizedBox(width: TSizes.spacebtwItems / 2),
                Text(
                  branchName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Branch items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: branchGroup.items.length,
            itemBuilder: (context, itemIndex) {
              final cartItem = branchGroup.items[itemIndex];
              // Find the corresponding product model
              final productCartModel = products.firstWhere(
                (p) => p.product.productBranchId == cartItem.id,
                orElse: () => throw Exception('Product not found for ID: ${cartItem.id}'),
              );

              return Dismissible(
                key: Key(cartItem.id.toString()),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  // Hiển thị dialog xác nhận nếu cần
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Xác nhận"),
                      content: Text("Bạn có chắc muốn xóa sản phẩm này?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Xóa"),
                        ),
                      ],
                      backgroundColor: TColors.white,
                    ),
                  );
                },
                onDismissed: (direction) {
                  // 1. Gửi event xóa đến CartBloc
                  context.read<CartBloc>().add(RemoveProductFromCartEvent(ids: [cartItem.id.toString()]));

                  // 2. Cập nhật UI ngay lập tức bằng cách loại bỏ item khỏi danh sách
                  final cubit = context.read<CheckboxCartCubit>();
                  cubit.deleteItem(cartItem.id);

                  TSnackBar.successSnackBar(context, message: "Xóa sản phẩm thành công");
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
                child: TProductCartItem(
                  product: productCartModel.product,
                  quantity: productCartModel.quantity,
                  isSelected: cartItem.status,
                  onToggleSelection: (bool value) {
                    context.read<CheckboxCartCubit>().toggleItemCheckbox(cartItem.id, value);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TProductCartItem extends StatefulWidget {
  final ProductModel product;
  final int quantity;
  final bool isSelected;
  final Function(bool) onToggleSelection;

  const TProductCartItem({
    super.key,
    required this.product,
    required this.quantity,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  _TProductCartItemState createState() => _TProductCartItemState();
}

class _TProductCartItemState extends State<TProductCartItem> {
  late TextEditingController _quantityController;
  Timer? _debounce;
  late int quantity;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.quantity.toString());
    quantity = widget.quantity;
    // _quantityController.addListener(() {
    //   setState(() {
    //     quantity = int.tryParse(_quantityController.text) ?? 1;
    //   });
    // });
  }

  @override
  void didUpdateWidget(TProductCartItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Chỉ cập nhật nếu quantity từ widget khác với hiện tại
    if (oldWidget.quantity != widget.quantity && widget.quantity != quantity) {
      quantity = widget.quantity;
      _quantityController.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _incrementQuantity() {
    int currentQuantity = int.tryParse(_quantityController.text) ?? 0;
    if (currentQuantity < widget.product.stockQuantity) {
      setState(() {
        currentQuantity++;
        _quantityController.text = currentQuantity.toString();
        quantity = currentQuantity;
      });
      onChangeQuantity();
    } else {
      TSnackBar.warningSnackBar(context, message: "Số lượng không đượt vượt quá ${widget.product.stockQuantity}");
    }
  }

  void _decrementQuantity() {
    int currentQuantity = int.tryParse(_quantityController.text) ?? 0;
    if (currentQuantity > 1) {
      setState(() {
        currentQuantity--;
        _quantityController.text = currentQuantity.toString();
        quantity = currentQuantity;
      });
      AppLogger.info(currentQuantity);
      AppLogger.info(_quantityController.text);

      onChangeQuantity();
    } else {
      TSnackBar.warningSnackBar(context, message: "Bạn có chắc muốn xóa sản phẩm này");
    }
  }

  void onChangeQuantity() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _saveQuantity();
    });
  }

  void _saveQuantity() {
    final newQuantity = int.tryParse(_quantityController.text) ?? quantity;
    if (newQuantity > 0 && newQuantity < 1000) {
      setState(() {
        quantity = newQuantity;
      });

      // Cập nhật trong Cubit
      context.read<CheckboxCartCubit>().updateProductQuantity(
            widget.product.productBranchId,
            newQuantity,
          );

      // Gửi event cập nhật lên server
      context.read<CartBloc>().add(UpdateProductToCartEvent(
            params: AddProductCartParams(
              userId: 0,
              productId: widget.product.productBranchId,
              quantity: newQuantity,
              operation: 2,
            ),
          ));
    } else {
      // Nếu không hợp lệ, reset về giá trị cũ
      _quantityController.text = quantity.toString();
      context.read<CheckboxCartCubit>().updateProductQuantity(
            widget.product.productBranchId,
            quantity,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số lượng hợp lệ (1-999)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm / 2, vertical: TSizes.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox for item selection
          Checkbox(
            value: widget.isSelected,
            onChanged: (bool? newValue) {
              widget.onToggleSelection(newValue ?? false);
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
                        onTap: int.parse(_quantityController.text) > 0 ? _decrementQuantity : null,
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
                          onChanged: (value) {
                            setState(() {
                              // Validate input doesn't exceed stock quantity
                              int parsedValue = int.tryParse(value) ?? 0;
                              if (parsedValue > widget.product.stockQuantity) {
                                TSnackBar.warningSnackBar(context, message: "Số lượng không đượt vượt quá ${widget.product.stockQuantity}");
                                _quantityController.text = widget.product.stockQuantity.toString();

                                parsedValue = widget.product.stockQuantity;
                              }
                              onChangeQuantity();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: TSizes.sm / 2),
                      // Increment button
                      GestureDetector(
                        onTap: int.parse(_quantityController.text) < widget.product.stockQuantity ? _incrementQuantity : () {},
                        child: TRoundedIcon(
                          icon: Iconsax.add,
                          width: 40,
                          backgroundColor: TColors.primary.withOpacity(0.05),
                          height: 40,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
