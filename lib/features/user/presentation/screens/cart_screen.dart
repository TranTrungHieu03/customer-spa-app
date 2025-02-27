import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/tabbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/service/presentation/widgets/status_bar_service.dart';
import 'package:spa_mobile/features/user/presentation/widgets/product_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.isProduct});

  final bool isProduct;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.isProduct ? 0 : 1,
      length: 2,
      child: Scaffold(
        appBar: TAppbar(
          showBackArrow: true,
          title: Text("Giỏ hàng của bạn"),
          actions: [
            TRoundedIcon(
              icon: Iconsax.home,
              onPressed: () => {goHome()},
            )
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                expandedHeight: 0,
                flexibleSpace: const Padding(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                ),
                backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.black : TColors.white,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Align(
                    alignment: Alignment.center,
                    child: TTabBar(
                      isScroll: false,
                      tabs: ["Product", "Service"].map((category) => Tab(child: Text(category))).toList(),
                    ),
                  ),
                ),
              )
            ];
          },
          body: const Padding(
            padding: EdgeInsets.all(TSizes.sm / 2),
            child: TabBarView(
              children: [
                TProductCart(),
                // TStatusTabService(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
