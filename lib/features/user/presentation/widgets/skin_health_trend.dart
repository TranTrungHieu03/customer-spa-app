import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';

/// A custom chart that compares skin age with real age
class SkinAgeComparisonChart extends StatefulWidget {
  /// Title of the chart
  final String title;

  /// The person's real age
  final double realAge;

  /// The assessed age of their skin
  final double skinAge;

  /// Primary color for the chart
  final Color skinAgeColor;

  /// Secondary color for comparison
  final Color realAgeColor;

  /// Optional description text
  final String? description;

  /// Animation duration
  final Duration animationDuration;

  const SkinAgeComparisonChart({
    Key? key,
    required this.title,
    required this.realAge,
    required this.skinAge,
    this.skinAgeColor = const Color(0xFF6200EA),
    this.realAgeColor = const Color(0xFF4CAF50),
    this.description,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<SkinAgeComparisonChart> createState() => _SkinAgeComparisonChartState();
}

class _SkinAgeComparisonChartState extends State<SkinAgeComparisonChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.update_real_age),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      goProfile();

                      return;
                    },
                    child: Text(AppLocalizations.of(context)!.edit))
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the difference between skin age and real age
    final ageDifference = widget.skinAge - widget.realAge;
    final displayText = ageDifference >= 0 ? '+${ageDifference.toStringAsFixed(1)}' : '${ageDifference.toStringAsFixed(1)}';

    // Determine status message
    String statusMessage;
    Color statusColor;

    if (ageDifference <= -5) {
      statusMessage = AppLocalizations.of(context)!.skin_status_excellent;
      statusColor = Colors.green.shade700;
    } else if (ageDifference < 0) {
      statusMessage = AppLocalizations.of(context)!.skin_status_good;
      statusColor = Colors.green;
    } else if (ageDifference < 3) {
      statusMessage = AppLocalizations.of(context)!.skin_status_matched;
      statusColor = Colors.blue;
    } else if (ageDifference < 7) {
      statusMessage = AppLocalizations.of(context)!.skin_status_aging;
      statusColor = Colors.orange;
    } else {
      statusMessage = AppLocalizations.of(context)!.skin_status_attention;
      statusColor = Colors.red;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TRoundedIcon(
                    icon: Iconsax.info_circle,
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                  )
                ],
              ),
              if (widget.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAgeIndicator(AppLocalizations.of(context)!.real_age, widget.realAge, widget.realAgeColor),
                  _buildDifference(ageDifference, displayText, statusColor),
                  _buildAgeIndicator(AppLocalizations.of(context)!.skin_age, widget.skinAge, widget.skinAgeColor),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  statusMessage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0, left: 12.0),
                  child: _buildChart(_animationController.value),
                ),
              ),
              const SizedBox(height: 16),
              _buildLegend(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAgeIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifference(double difference, String displayText, Color statusColor) {
    final IconData icon = difference >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            Icon(
              icon,
              color: statusColor,
              size: 24,
            ),
            Text(
              displayText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChart(double animationValue) {
    // Calculate the min and max for y-axis
    final minAge = math.min(widget.realAge, widget.skinAge) - 5;
    final maxAge = math.max(widget.realAge, widget.skinAge) + 5;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: maxAge,
        minY: math.max(0, minAge),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            left: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                String text = '';
                if (value == 0) text = AppLocalizations.of(context)!.real_age;
                if (value == 1) text = AppLocalizations.of(context)!.skin_age;

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: widget.realAge * animationValue,
                color: widget.realAgeColor,
                width: 60,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: widget.skinAge * animationValue,
                color: widget.skinAgeColor,
                width: 60,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(widget.realAgeColor, AppLocalizations.of(context)!.real_age),
        const SizedBox(width: 24),
        _legendItem(widget.skinAgeColor, AppLocalizations.of(context)!.skin_age),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
