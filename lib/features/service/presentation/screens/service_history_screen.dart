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
import 'package:spa_mobile/features/service/presentation/bloc/list_appointment/list_appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/status_bar_service.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: BlocConsumer<ListAppointmentBloc, ListAppointmentState>(
        listener: (context, state) {
          if (state is ListAppointmentError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: TAppbar(
              leadingOnPressed: () => goHome(),
              leadingIcon: Iconsax.arrow_left,
              title: Text(
                AppLocalizations.of(context)!.history_book,
                style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
              ),
            ),
            body: NestedScrollView(
              body: const Padding(
                padding: EdgeInsets.all(TSizes.sm / 2),
                child: TabBarView(
                  children: [
                    TStatusTabService(
                      status: "pending",
                    ),
                    TStatusTabService(
                      status: "arrived",
                    ),
                    TStatusTabService(
                      status: "completed",
                    ),
                    TStatusTabService(
                      status: "cancel",
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
                          tabs: ["Pending", "Completed", "Arrived", "Cancel"].map((category) => Tab(child: Text(category))).toList()))
                ];
              },
            ),
          );
        },
      ),
    );
  }
}
