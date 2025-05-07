import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';

class SkinConditionChart extends StatefulWidget {
  const SkinConditionChart({super.key, required this.scanData});

  final List<SkinScanData> scanData;

  @override
  State<SkinConditionChart> createState() => _SkinConditionChartState();
}

class _SkinConditionChartState extends State<SkinConditionChart> with TickerProviderStateMixin {
  late List<SkinScanData> scanData;
  late int maxAcne;
  late int maxCloseAcne;

  int _selectedTabIndex = 0;
  late TabController _tabController;
  final List<String> _tabs = ['Tổng quan', 'Mụn ẩn', 'Mụn trứng cá', 'Mụn đầu đen'];

  @override
  void initState() {
    super.initState();
    scanData = widget.scanData;
    maxAcne = widget.scanData.map((e) => e.acne).reduce((a, b) => a > b ? a : b);
    maxCloseAcne = widget.scanData.map((e) => e.closedAcne).reduce((a, b) => a > b ? a : b);
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.acne_title,
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
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            AppLocalizations.of(context)!.acne_overview_description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        _buildTabBar(),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSelectedChart(),
          ),
        ),
        const SizedBox(height: 20),
        _buildLegend(),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      // Cho phép full screen nếu cần
      builder: (BuildContext context) {
        return Padding(padding: const EdgeInsets.all(16.0), child: Text(AppLocalizations.of(context)!.acne_detail));
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: TColors.primary,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildSelectedChart() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildCombinedChart();
      case 1:
        return _buildClosedAcneChart();
      case 2:
        return _buildAcneChart();
      case 3:
        return _buildBlackheadChart();
      default:
        return _buildCombinedChart();
    }
  }

  Widget _buildCombinedChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < scanData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('dd/MM').format(scanData[value.toInt()].date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: scanData.length - 1,
        minY: 0,
        maxY: max(maxCloseAcne.toDouble(), maxAcne.toDouble()),
        lineBarsData: [
          // Mụn ẩn
          LineChartBarData(
            spots: List.generate(
              scanData.length,
              (index) => FlSpot(index.toDouble(), scanData[index].closedAcne.toDouble()),
            ),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          // Mụn trứng cá
          LineChartBarData(
            spots: List.generate(
              scanData.length,
              (index) => FlSpot(index.toDouble(), scanData[index].acne.toDouble()),
            ),
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          // Mụn đầu đen
          LineChartBarData(
            spots: List.generate(
              scanData.length,
              (index) => FlSpot(index.toDouble(), scanData[index].blackheadLevel.toDouble()),
            ),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedAcneChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxCloseAcne.toDouble(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.blueAccent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${scanData[group.x.toInt()].closedAcne} mụn\n',
                const TextStyle(color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                    text: DateFormat('dd/MM/yyyy').format(scanData[group.x.toInt()].date),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= 0 && value.toInt() < scanData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('dd/MM').format(scanData[value.toInt()].date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(value.toInt().toString()),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            top: BorderSide(color: Colors.black12),
            right: BorderSide(color: Colors.black12),
            left: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12),
          ),
        ),
        barGroups: List.generate(
          scanData.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: scanData[index].closedAcne.toDouble(),
                color: Colors.blue,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcneChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxAcne.toDouble(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.redAccent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${scanData[group.x.toInt()].acne} mụn\n',
                const TextStyle(color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                    text: DateFormat('dd/MM/yyyy').format(scanData[group.x.toInt()].date),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= 0 && value.toInt() < scanData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('dd/MM').format(scanData[value.toInt()].date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(value.toInt().toString()),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            top: BorderSide(color: Colors.black12),
            right: BorderSide(color: Colors.black12),
            left: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12),
          ),
        ),
        barGroups: List.generate(
          scanData.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: scanData[index].acne.toDouble(),
                color: Colors.red,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlackheadChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < scanData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('dd/MM').format(scanData[value.toInt()].date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                String title = '';
                switch (value.toInt()) {
                  case 0:
                    title = 'Không';
                    break;
                  case 1:
                    title = 'Nhẹ';
                    break;
                  case 2:
                    title = 'Vừa';
                    break;
                  case 3:
                    title = 'Nặng';
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 50,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: scanData.length - 1,
        minY: 0,
        maxY: 3,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              scanData.length,
              (index) => FlSpot(index.toDouble(), scanData[index].blackheadLevel.toDouble()),
            ),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 20,
        alignment: WrapAlignment.center,
        children: [
          _legendItem(AppLocalizations.of(context)!.closedComedones, Colors.blue),
          _legendItem(AppLocalizations.of(context)!.acne, Colors.red),
          _legendItem(AppLocalizations.of(context)!.blackHead, Colors.green),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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

class SkinScanData {
  final DateTime date; // Ngày quét
  final int closedAcne; // Số lượng mụn ẩn
  final int acne; // Số lượng mụn trứng cá
  final int blackheadLevel; // Mức độ mụn đầu đen (0-3)

  SkinScanData({
    required this.date,
    required this.closedAcne,
    required this.acne,
    required this.blackheadLevel,
  });
}
