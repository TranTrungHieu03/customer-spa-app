import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/user/domain/usecases/list_skinhealth.dart';
import 'package:spa_mobile/features/user/presentation/bloc/list_skinhealth/list_skinhealth_bloc.dart';
import 'package:spa_mobile/features/user/presentation/widgets/custom_skin_health_chart.dart';
import 'package:spa_mobile/features/user/presentation/widgets/skin_condition_chart.dart';
import 'package:spa_mobile/features/user/presentation/widgets/skin_health_trend.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key, required this.userId});

  final int userId;

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final now = DateTime.now();
  UserModel? user;

  void _getUser() async {
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (jsonDecode(userJson) != null) {
      user = UserModel.fromJson(jsonDecode(userJson));
      setState(() {
        user = UserModel.fromJson(jsonDecode(userJson));
      });
    } else {
      goLoginNotBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int ageReal = DateTime.now().year - (user?.birthDate?.year ?? DateTime.now().year);

    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
      ),
      body: BlocListener<ListSkinhealthBloc, ListSkinhealthState>(
        listener: (context, state) {
          if (state is ListSkinhealthError) {
            TSnackBar.errorSnackBar(context, message: state.message);
          }
        },
        child: BlocBuilder<ListSkinhealthBloc, ListSkinhealthState>(
          builder: (context, state) {
            if (state is ListSkinhealthLoaded) {
              if (state.data.isEmpty || !state.data.any((x) => x.skinHealth.images != null)) {
                return Center(
                    child: SizedBox(
                  child: Text(AppLocalizations.of(context)!.scan_face_to_view_stats),
                ));
              }
              final skinHealthLastest = state.data.firstWhere((x) => x.skinHealth.images != null).skinHealth;
              final lastItems = state.data.where((x) => x.skinHealth.images != null).toList()
                ..sort((a, b) => a.skinHealth.createdDate!.compareTo(b.skinHealth.createdDate!));

              final top10Items = lastItems.take(min(lastItems.length, 10)).toList();

              return Padding(
                padding: const EdgeInsets.all(TSizes.sm),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //overview of nearest
                      SkinHealthRadialChart(
                        title: AppLocalizations.of(context)!.skin_face_overview,
                        description: AppLocalizations.of(context)!.based_on_latest_scan,
                        dataPoints: [
                          SkinHealthDataPoint(
                              label: AppLocalizations.of(context)!.acne,
                              value: normalizeAcne(skinHealthLastest.acne.rectangle.length,
                                  skinHealthLastest.closedComedones.rectangle.length, skinHealthLastest.blackhead.value)),
                          SkinHealthDataPoint(
                              label: AppLocalizations.of(context)!.wrinkles,
                              value: normalizeWinkle(skinHealthLastest.foreheadWrinkle.value, skinHealthLastest.crowsFeet.value,
                                  skinHealthLastest.glabellaWrinkle.value, skinHealthLastest.nasolabialFold.value)),
                          SkinHealthDataPoint(
                              label: AppLocalizations.of(context)!.spots,
                              value: normalizeSpot(skinHealthLastest.skinSpot.rectangle.length)),
                          SkinHealthDataPoint(
                              label: AppLocalizations.of(context)!.pores,
                              value: normalizePore(skinHealthLastest.poresLeftCheek.value, skinHealthLastest.poresRightCheek.value,
                                  skinHealthLastest.poresJaw.value, skinHealthLastest.poresForehead.value)),
                        ],
                        colorScheme: const [
                          Color(0xFF6200EA), // Deep Purple
                          Color(0xFF00BFA5), // Teal
                          Color(0xFFFFAB00), // Amber
                          Color(0xFFE53935), // Red
                        ],
                      ),
                      //real age and stage age
                      SkinAgeComparisonChart(
                        title: AppLocalizations.of(context)!.skin_age_compare,
                        realAge: ageReal.toDouble(),
                        skinAge: skinHealthLastest.skinAge.value.toDouble(),
                        description: AppLocalizations.of(context)!.skin_age_chart_description,
                        skinAgeColor: const Color(0xFF6200EA),
                        // Purple
                        realAgeColor: const Color(0xFF4CAF50), // Green
                      ),
                      SkinConditionChart(
                        scanData: top10Items
                            .map((e) => SkinScanData(
                                date: e.skinHealth?.createdDate?.toLocal().add(Duration(hours: 7)) ?? DateTime.now(),
                                closedAcne: e.skinHealth.closedComedones.rectangle.length,
                                acne: e.skinHealth.acne.rectangle.length,
                                blackheadLevel: e.skinHealth.blackhead.value))
                            .toList(),
                      )
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    context.read<ListSkinhealthBloc>().add(GetListSkinHealthEvent(GetListSkinHealthParams(widget.userId)));
  }
}
