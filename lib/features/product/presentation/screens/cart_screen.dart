import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/inherited/purchasing_data.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
import 'package:spa_mobile/features/user/presentation/widgets/product_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.controller});

  final PurchasingDataController controller;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TAppbar(
          title: Text(
            "Cart",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          showBackArrow: true,
        ),
        body: BlocBuilder<ListBranchesBloc, ListBranchesState>(
          builder: (context, branchState) {
            return BlocConsumer<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoaded && branchState is ListBranchesLoaded) {
                  return TProductCart(
                    products: state.products,
                    controller: widget.controller,
                    branches: branchState.branches,
                  );
                } else if (state is CartLoading || branchState is ListBranchesLoading) {
                  return const TLoader();
                }
                return const SizedBox();
              },
              listener: (_, state) {
                if (state is CartSuccess) {
                  TSnackBar.successSnackBar(context, message: state.message);
                } else if (state is CartError) {
                  TSnackBar.errorSnackBar(context, message: state.message);
                }
              },
            );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(GetCartProductsEvent());
    context.read<ListBranchesBloc>().add(GetListBranchesEvent());
  }
}
