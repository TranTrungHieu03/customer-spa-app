import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/common/widgets/tabbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_order/list_order_bloc.dart';
import 'package:spa_mobile/features/product/presentation/widgets/status_bar.dart';
import 'package:spa_mobile/init_dependencies.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListOrderBloc(getHistoryProduct: serviceLocator()),
      child: DefaultTabController(
        length: 4,
        child: BlocListener<ListOrderBloc, ListOrderState>(
          listener: (context, state) {
            if (state is ListOrderError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          child: BlocBuilder<ListOrderBloc, ListOrderState>(
            builder: (context, state) {
              return Scaffold(
                appBar: TAppbar(
                  leadingOnPressed: () => goHome(),
                  leadingIcon: Iconsax.arrow_left,
                  title: Text(
                    AppLocalizations.of(context)!.order_history,
                    style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
                  ),
                ),
                body: NestedScrollView(
                  body: const Padding(
                    padding: EdgeInsets.all(TSizes.sm / 2),
                    child: TabBarView(
                      children: [
                        TStatusBarProduct(
                          status: "pending",
                        ),
                        TStatusBarProduct(
                          status: "shipping",
                        ),
                        TStatusBarProduct(
                          status: "completed",
                        ),
                        TStatusBarProduct(
                          status: "cancelled",
                        ),
                      ],
                    ),
                  ),
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
                          bottom: TTabBar(
                              isScroll: true,
                              tabs: [
                                AppLocalizations.of(context)!.pending,
                                AppLocalizations.of(context)!.delivered,
                                AppLocalizations.of(context)!.completed,
                                AppLocalizations.of(context)!.cancelled
                              ].map((category) => Tab(child: Text(category))).toList()))
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
