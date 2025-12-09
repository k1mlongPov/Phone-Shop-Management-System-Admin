import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:phone_management_system_admin/features/dashboard/logic/dashboard_controller.dart';
import 'package:phone_management_system_admin/features/dashboard/presentation/widgets/section_title.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

Widget salesChartSection(DashboardController c) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "Sales Comparison",
          subtitle: "Phones vs Accessories (7 days)",
          icon: Icons.bar_chart_rounded,
        ),
        SizedBox(height: 12.h),
        SalesComparisonChart(
          phone: c.phoneRevenue7Days,
          accessory: c.accessoryRevenue7Days,
        ),
      ],
    ),
  );
}

class SalesComparisonChart extends StatelessWidget {
  final List<double> phone;
  final List<double> accessory;

  bool get isEmpty => phone.isEmpty || accessory.isEmpty;

  const SalesComparisonChart({
    super.key,
    required this.phone,
    required this.accessory,
  });

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat("#,##0.00");
    if (isEmpty) {
      return const Center(
        child: Text(
          "No revenue data",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final barGroups = List.generate(phone.length, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 6,
        barRods: [
          BarChartRodData(
            toY: phone[index],
            color: AppColors.kPrimary,
            width: 9,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: accessory[index],
            color: Colors.orange.shade400,
            width: 9,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    return Container(
      padding: EdgeInsets.fromLTRB(12.r, 16.r, 12.r, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.kWhite,
      ),
      child: AspectRatio(
        aspectRatio: 1.8,
        child: BarChart(
          BarChartData(
            maxY: _findMax(phone, accessory) * 1.3,
            alignment: BarChartAlignment.spaceAround,
            borderData: FlBorderData(show: false),

            gridData:
                FlGridData(show: true, horizontalInterval: _idealInterval()),

            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return ReusableText(
                      text: "\$${value.toInt()}",
                      style: appStyle(12, AppColors.kGray, FontWeight.normal),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    const days = [
                      "Mon",
                      "Tue",
                      "Wed",
                      "Thu",
                      "Fri",
                      "Sat",
                      "Sun"
                    ];
                    return ReusableText(
                      text: days[value.toInt()],
                      style: appStyle(12, AppColors.kGray, FontWeight.normal),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
            ),

            // Touch
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.black.withOpacity(0.75),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final isPhone = rodIndex == 0;
                  final label = isPhone ? "Phone" : "Accessory";
                  final revenue = rod.toY;

                  return BarTooltipItem(
                    "$label: \$${f.format(revenue)}",
                    appStyle(13, AppColors.kWhite, FontWeight.normal),
                  );
                },
              ),
            ),

            barGroups: barGroups,
          ),
        ),
      ),
    );
  }

  double _idealInterval() {
    final maxVal = _findMax(phone, accessory);
    if (maxVal <= 100) return 20;
    if (maxVal <= 500) return 100;
    if (maxVal <= 1000) return 200;
    return maxVal / 5;
  }

  double _findMax(List<double> a, List<double> b) {
    return [...a, ...b].reduce((v1, v2) => v1 > v2 ? v1 : v2);
  }
}
