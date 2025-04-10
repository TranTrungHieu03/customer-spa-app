import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/common/widgets/tabbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_order_routine/list_order_routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_order_routine/list_order_routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_order_routine/list_order_routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_routine/list_routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/widget/status_tab_order_routine.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';

class RoutineHistoryScreen extends StatefulWidget {
  const RoutineHistoryScreen({super.key});

  @override
  State<RoutineHistoryScreen> createState() => _RoutineHistoryScreenState();
}

class _RoutineHistoryScreenState extends State<RoutineHistoryScreen> {
  late int userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (userJson != null) {
      userId = UserModel.fromJson(jsonDecode(userJson)).userId;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: BlocConsumer<ListOrderRoutineBloc, ListOrderRoutineState>(
        listener: (context, state) {
          if (state is ListOrderRoutineError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: TAppbar(
              leadingOnPressed: () => goHome(),
              leadingIcon: Iconsax.arrow_left,
              title: Text(
                'Lịch sử gói liệu trình',
                style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
              ),
            ),
            body: NestedScrollView(
              body: const Padding(
                padding: EdgeInsets.all(TSizes.sm / 2),
                child: TabBarView(
                  children: [
                    TStatusBarOrderRoutine(status: "pending"),
                    TStatusBarOrderRoutine(status: "completed"),
                    TStatusBarOrderRoutine(status: "cancelled"),
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
                      tabs: ["Đang chờ", "Đã hoàn thành", "Đã hủy"].map((category) => Tab(child: Text(category))).toList(),
                    ),
                  )
                ];
              },
            ),
          );
        },
      ),
    );
  }
}
