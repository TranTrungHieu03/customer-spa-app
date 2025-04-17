import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/common/widgets/grid_layout.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/order_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_history_order_routine.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/list_order_routine/list_order_routine_bloc.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/presentation/widgets/product_price.dart';
import 'package:spa_mobile/features/service/presentation/widgets/order_horizontal_shimmer_card.dart';

class TStatusBarOrderRoutine extends StatefulWidget {
  const TStatusBarOrderRoutine({super.key, required this.status});

  final String status;

  @override
  State<TStatusBarOrderRoutine> createState() => _TStatusBarOrderRoutineState();
}

class _TStatusBarOrderRoutineState extends State<TStatusBarOrderRoutine> with AutomaticKeepAliveClientMixin {
  List<OrderRoutineModel> orders = [];
  PaginationModel pagination = PaginationModel.isEmty();
  bool isLoading = false;
  late ScrollController _scrollController;
  String lgCode = 'vi';
  UserModel? user;

  Future<void> _loadLanguageAndInit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lgCode = prefs.getString('language_code') ?? "vi";
    });
  }

  Future<void> _loadUserTemp() async {
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (jsonDecode(userJson) != null) {
      user = UserModel.fromJson(jsonDecode(userJson));
    } else {
      goLoginNotBack();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadLanguageAndInit();
    _loadUserTemp();
    _scrollController = ScrollController();
    context.read<ListOrderRoutineBloc>().add(GetHistoryOrderRoutineEvent(GetHistoryOrderRoutineParams(page: 1, status: widget.status)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.sm),
      child: Container(
        margin: EdgeInsets.all(TSizes.sm),
        child: BlocListener<ListOrderRoutineBloc, ListOrderRoutineState>(
          listener: (context, state) {
            if (state is ListOrderRoutineError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          child: BlocBuilder<ListOrderRoutineBloc, ListOrderRoutineState>(builder: (context, state) {
            if (state is ListOrderRoutineLoaded) {
              if (widget.status == "pending") {
                orders = state.pending;
                pagination = state.paginationPending;
                isLoading = state.isLoadingMorePending;
              } else if (widget.status == "completed") {
                orders = state.completed;
                pagination = state.paginationCompleted;
                isLoading = state.isLoadingMoreCompleted;
              } else {
                orders = state.cancelled;
                pagination = state.paginationCancelled;
                isLoading = state.isLoadingMoreCancelled;
              }

              if (orders.isEmpty) {
                return const Center(child: Text('Do not have any order here!'));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification && _scrollController.position.extentAfter < 100) {
                    if (!isLoading && pagination.page < pagination.totalPage) {
                      context
                          .read<ListOrderRoutineBloc>()
                          .add(GetHistoryOrderRoutineEvent(GetHistoryOrderRoutineParams(page: pagination.page + 1, status: widget.status)));
                    }
                  }
                  return false;
                },
                child: ListView.separated(
                    controller: _scrollController,
                    itemCount: orders.length + 1,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: TSizes.md,
                      );
                    },
                    itemBuilder: (context, index) {
                      if (index == orders.length) {
                        return isLoading ? const TOrderHorizontalShimmer() : const SizedBox.shrink();
                      } else {
                        final order = orders[index];
                        final routine = order.routine;
                        return TRoundedContainer(
                          padding: const EdgeInsets.all(TSizes.sm),
                          child: GestureDetector(
                            // onTap: () => goBookingDetail(orders[index].orderId, isBack: true),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(routine.name, style: Theme.of(context).textTheme.titleLarge),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(routine.description),
                                    ],
                                  ),
                                  onTap: () {
                                    goTrackingRoutineDetail(routine.skincareRoutineId, user?.userId ?? 0);
                                  },
                                ),

                              ],
                            ),
                          ),
                        );
                      }
                    }),
              );
            } else if (state is ListOrderRoutineLoading) {
              return TGridLayout(
                  itemCount: 4,
                  mainAxisExtent: 150,
                  itemBuilder: (_, __) {
                    return const TOrderHorizontalShimmer();
                  });
            }
            return const Center(child: Text('Do not have any order here!'));
          }),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
