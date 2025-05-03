import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/home/data/models/notification_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_all_notification.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read_all.dart';
import 'package:spa_mobile/features/home/presentation/blocs/list_notification/list_notification_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/notification/notification_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.userId});

  final int userId;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ScrollController _scrollController;
  final Set<int> _readNotificationIds = {};

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      final currentState = context.read<ListNotificationBloc>().state;
      if (currentState is ListNotificationLoaded &&
          !currentState.isLoadingMore &&
          currentState.pagination.page < currentState.pagination.totalPage) {
        context.read<ListNotificationBloc>().add(GetAllNotificationEvent(
            GetAllNotificationParams(userId: widget.userId, pageIndex: currentState.pagination.page + 1, pageSize: 10)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationUpdatedAll) {
          context.read<ListNotificationBloc>().add(ResetNotificationEvent());
          context
              .read<ListNotificationBloc>()
              .add(GetAllNotificationEvent(GetAllNotificationParams(userId: widget.userId, pageIndex: 1, pageSize: 10)));
        }
      },
      child: Scaffold(
          appBar: TAppbar(
            title: Text('Thông báo'),
            showBackArrow: false,
            leadingIcon: Iconsax.arrow_left,
            leadingOnPressed: () => goHome(),
          ),
          body: Padding(
            padding: EdgeInsets.all(TSizes.xs),
            child: BlocBuilder<ListNotificationBloc, ListNotificationState>(builder: (context, state) {
              if (state is ListNotificationLoaded) {
                if (state.notifications.isEmpty) {
                  return _buildEmptyState();
                } else {
                  return Column(
                    children: [
                      if (state.notifications.any((a) => a.isRead == false)) _buildHeader(state.notifications),
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: state.notifications.length + 2,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            if (index == state.notifications.length || index == state.notifications.length + 1) {
                              return state.isLoadingMore
                                  ? TShimmerEffect(width: THelperFunctions.screenWidth(context), height: TSizes.shimmerMd)
                                  : const SizedBox();
                            }
                            return _buildNotificationItem(state.notifications[index]);
                          },
                        ),
                      ),
                    ],
                  );
                }
              } else if (state is ListNotificationLoading) {
                return const TLoader();
              } else if (state is ListNotificationError) {
                return Text(state.message);
              }
              return const SizedBox();
            }),
          )),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Không có thông báo nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn sẽ nhận được thông báo khi có cập nhật mới',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<NotificationModel> notifications) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            context.read<NotificationBloc>().add(MarkAsReadAllEvent(MarkAsReadAllParams(widget.userId)));
          },
          child: const Text('Đánh dấu tất cả đã đọc'),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    final isRead = notification.isRead || _readNotificationIds.contains(notification.notificationId);
    return InkWell(
      onTap: () {
        if (!isRead) {
          context.read<NotificationBloc>().add(MarkAsReadEvent(MarkAsReadParams(notification.notificationId)));
          setState(() {
            _readNotificationIds.add(notification.notificationId);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TSizes.sm, horizontal: TSizes.md),
        color: isRead ? Colors.transparent : Colors.blue[50],
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6, right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isRead ? Colors.transparent : Colors.blue,
                        ),
                      ),
                      Text(
                        formatDateTime(notification.createdDate.add(Duration(hours: 7))),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);
    context.read<ListNotificationBloc>().add(ResetNotificationEvent());
    context
        .read<ListNotificationBloc>()
        .add(GetAllNotificationEvent(GetAllNotificationParams(userId: widget.userId, pageIndex: 1, pageSize: 10)));
  }
}
