import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/shared/widgets/advanced_shimmer.dart';
import 'package:phone_management_system_admin/shared/widgets/shimmer_chart.dart';
import 'package:phone_management_system_admin/shared/widgets/shimmer_list_tile.dart';

Widget advancedShimmerDashboard() {
  return CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: AdvancedShimmer(
                height: 90,
                width: double.infinity,
                radius: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AdvancedShimmer(
                      height: 80,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AdvancedShimmer(
                      height: 80,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AdvancedShimmer(
                      height: 80,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: const Column(
                  children: [
                    AdvancedShimmer(height: 16, width: 120),
                    SizedBox(height: 20),
                    ShimmerChart(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: const Column(
                  children: [
                    AdvancedShimmer(height: 16, width: 160),
                    SizedBox(height: 14),
                    ShimmerListTile(),
                    ShimmerListTile(),
                    ShimmerListTile(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child:
                          AdvancedShimmer(height: 90, width: double.infinity)),
                  SizedBox(width: 10),
                  Expanded(
                      child:
                          AdvancedShimmer(height: 90, width: double.infinity)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: const Column(
                  children: [
                    AdvancedShimmer(height: 16, width: 150),
                    SizedBox(height: 14),
                    ShimmerListTile(),
                    ShimmerListTile(),
                    ShimmerListTile(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
