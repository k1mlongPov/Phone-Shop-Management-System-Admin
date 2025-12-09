import 'package:flutter/material.dart';
import 'advanced_shimmer.dart';

class ShimmerChart extends StatelessWidget {
  const ShimmerChart({super.key});

  @override
  Widget build(BuildContext context) {
    final bars = [50.0, 80.0, 40.0, 90.0, 70.0, 60.0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: bars
          .map(
            (h) => AdvancedShimmer(
              height: h,
              width: 12,
              radius: 6,
            ),
          )
          .toList(),
    );
  }
}
