import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/shimmer.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_channel_by_appointment.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_user_chat_info.dart';
import 'package:spa_mobile/features/home/presentation/blocs/channel/channel_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/user_chat/user_chat_bloc.dart';
import 'package:spa_mobile/features/service/domain/usecases/cancel_appointment_detail.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment_detail.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment_feedback.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment_feedback/appointment_feedback_bloc.dart';
import 'package:spa_mobile/features/service/presentation/widgets/qr_checkin.dart';
import 'package:spa_mobile/init_dependencies.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key, required this.appointmentId, this.isEnableUpdateAll = false});

  final String appointmentId;
  final bool isEnableUpdateAll;


  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  String lgCode = 'vi';
  int? userId;
  UserChatModel? userChatModel;

  Future<void> _loadLanguageAndInit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lgCode = prefs.getString('language_code') ?? "vi";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguageAndInit();
    _loadLocalData();
  }

  void _loadLocalData() async {
    final jsonUserChat = await LocalStorage.getData(LocalStorageKey.userChat);
    if (jsonUserChat != null && jsonUserChat.isNotEmpty) {
      try {
        userChatModel = UserChatModel.fromJson(jsonDecode(jsonUserChat));
      } catch (e) {
        debugPrint('Lỗi parsing userChatModel: $e');
        goLoginNotBack();
      }
      return;
    }

    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        userId = UserModel.fromJson(jsonDecode(userJson)).userId;
        context.read<UserChatBloc>().add(GetUserChatInfoEvent(GetUserChatInfoParams(userId ?? 0)));
      } catch (e) {
        goLoginNotBack();
      }
    } else {
      goLoginNotBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: Text(AppLocalizations.of(context)!.appointment_detail),
        showBackArrow: true,
        actions: [
          TRoundedIcon(
            icon: Iconsax.home_2,
            onPressed: () => goHome(),
          )
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppointmentBloc(
                getAppointment: serviceLocator(),
                cancelOrder: serviceLocator(),
                createAppointment: serviceLocator(),
                updateAppointment: serviceLocator(),
                cancelAppointmentDetail: serviceLocator(),
                updateAppointmentRoutine: serviceLocator(),
                getAppointmentDetail: serviceLocator())
              ..add(GetAppointmentDetailEvent(GetAppointmentDetailParams(appointmentId: widget.appointmentId))),
          ),
          BlocProvider(
              create: (context) => AppointmentFeedbackBloc(getFeedback: serviceLocator())
                ..add(GetAppointmentFeedbackEvent(GetFeedbackParams(appointmentId: widget.appointmentId)))),
          BlocProvider(
              create: (context) => ChannelBloc(getChannel: serviceLocator(), getChannelByAppointment: serviceLocator())
                ..add(GetChannelByAppointmentEvent(GetChannelByAppointmentParams(widget.appointmentId))))
        ],
        child: BlocListener<AppointmentBloc, AppointmentState>(
          listener: (context, state) {
            if (state is CancelAppointmentDetailSuccess) {
              TSnackBar.successSnackBar(context, message: state.message);
              goHome();
            } else if (state is AppointmentError) {
              TSnackBar.errorSnackBar(context, message: state.message);
            }
          },
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              if (state is AppointmentLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AppointmentDetailLoaded) {
                final appointment = state.appointment;
                return Padding(
                    padding: const EdgeInsets.all(TSizes.sm),
                    child: SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.hourglass_empty,
                                color: TColors.primary,
                              ),
                              const SizedBox(
                                width: TSizes.sm,
                              ),
                              Text(
                                appointment.status.toLowerCase() == 'pending'
                                    ? AppLocalizations.of(context)!.pending
                                    : appointment.status.toLowerCase() == 'arrived'
                                        ? AppLocalizations.of(context)!.arrived
                                        : appointment.status.toLowerCase() == 'completed'
                                            ? AppLocalizations.of(context)!.completed
                                            : AppLocalizations.of(context)!.cancelled,
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
                          ),
                          if (appointment.status.toLowerCase() == 'pending')
                            Align(
                              alignment: Alignment.centerRight,
                              child: TRoundedIcon(
                                icon: Icons.qr_code_scanner_rounded,
                                color: TColors.primary,
                                size: 30,
                                onPressed: () => _showModelQR(context, appointment.appointmentId),
                              ),
                            ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Trao đổi với chuyên viên"),
                            BlocBuilder<ChannelBloc, ChannelState>(
                              builder: (context, state) {
                                if (state is ChannelLoaded) {
                                  return TRoundedIcon(
                                    icon: Iconsax.message,
                                    color: TColors.primary,
                                    size: 30,
                                    onPressed: () => goChatRoom(state.channel.id, userChatModel?.id ?? ""),
                                  );
                                } else if (state is ChannelLoading) {
                                  return const TShimmerEffect(width: TSizes.shimmerSx * 1, height: TSizes.shimmerSm * 0.7);
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.building,
                            color: TColors.primary,
                          ),
                          const SizedBox(
                            width: TSizes.sm,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.branch?.branchName ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                appointment.branch?.branchAddress ?? "",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.calendar_1,
                            color: TColors.primary,
                          ),
                          const SizedBox(
                            width: TSizes.sm,
                          ),
                          Text(
                            DateFormat('EEEE, dd MMMM yyyy', lgCode).format(appointment.appointmentsTime).toString(),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.clock,
                            color: TColors.primary,
                          ),
                          const SizedBox(
                            width: TSizes.sm,
                          ),
                          Text(
                            "${DateFormat('HH:mm', lgCode).format(appointment.appointmentsTime).toString()} - "
                            "${DateFormat('HH:mm', lgCode).format(appointment.appointmentEndTime).toString()}",
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      (appointment.staff?.roleId != 3)
                          ? TRoundedContainer(
                              padding: const EdgeInsets.all(TSizes.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.specialist_information,
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
                                  const SizedBox(
                                    height: TSizes.sm,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Iconsax.user,
                                        size: 17,
                                      ),
                                      const SizedBox(
                                        width: TSizes.sm,
                                      ),
                                      Text(
                                        appointment.staff?.staffInfo?.fullName ?? "",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Iconsax.call,
                                        size: 17,
                                      ),
                                      const SizedBox(
                                        width: TSizes.sm,
                                      ),
                                      Text(
                                        appointment.staff?.staffInfo?.phoneNumber ?? "",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {},
                                  child:
                                      Text(AppLocalizations.of(context)!.choose_specialist, style: Theme.of(context).textTheme.labelLarge)),
                            ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      TRoundedContainer(
                        padding: const EdgeInsets.all(TSizes.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.service_information,
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            Text(
                              appointment.service.name ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.duration),
                                const SizedBox(
                                  width: TSizes.sm,
                                ),
                                Text(
                                  '${appointment.service.duration} ${AppLocalizations.of(context)!.minutes}' ?? "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Text(
                              appointment.service.description ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.step),
                                const SizedBox(
                                  width: TSizes.sm,
                                ),
                                Text(
                                  '${appointment.service.steps} ' ?? "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      TRoundedContainer(
                        padding: const EdgeInsets.all(TSizes.sm),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(AppLocalizations.of(context)!.tracking_information, style: Theme.of(context).textTheme.bodyLarge),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.before_image),
                              SizedBox(width: TSizes.sm),
                              Text(AppLocalizations.of(context)!.after_image),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildImageBox(context: context, isBefore: true),
                              _buildImageBox(context: context, isBefore: false),
                            ],
                          ),
                        ]),
                      ),
                      (state.appointment.status.toLowerCase() == "pending")
                          ? TextButton(
                              onPressed: () {
                                // _showModalCancel(context, order.orderId);
                                context
                                    .read<AppointmentBloc>()
                                    .add(CancelAppointmentDetailEvent(CancelAppointmentDetailParams(widget.appointmentId)));
                              },
                              child: Text(
                                AppLocalizations.of(context)!.cancel_appointment,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: TColors.darkGrey),
                              ))
                          : const SizedBox()
                    ])));
              } else if (state is AppointmentError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageBox({required BuildContext context, required bool isBefore}) {
    return BlocListener<AppointmentFeedbackBloc, AppointmentFeedbackState>(
      listener: (context, state) {
        if (state is AppointmentFeedbackError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      child: BlocBuilder<AppointmentFeedbackBloc, AppointmentFeedbackState>(
        builder: (context, feedbackState) {
          AppLogger.info('Feedback state: $feedbackState');
          if (feedbackState is AppointmentFeedbackLoaded) {
            final imageUrl = isBefore ? feedbackState.feedback?.imageBefore : feedbackState.feedback?.imageAfter;

            if (imageUrl != null && imageUrl.isNotEmpty) {
              return _buildNetworkImage(context, imageUrl);
            } else {
              return Text(
                'Chua co hinh anh' ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              );
            }
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildNetworkImage(BuildContext context, String url) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: THelperFunctions.screenHeight(context) * 0.3,
      ),
      child: Container(
        width: THelperFunctions.screenWidth(context) * 0.4,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
          borderRadius: BorderRadius.circular(TSizes.md),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.md),
          child: Image.network(url, fit: BoxFit.cover),
        ),
      ),
    );
  }

  void _showModelQR(BuildContext context, int id) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.all(TSizes.spacebtwSections), child: TQrCheckIn(id: id.toString(), time: DateTime.now())),
            ],
          ),
        );
      },
    );
  }
}
