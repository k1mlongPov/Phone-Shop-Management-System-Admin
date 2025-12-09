import 'package:flutter/material.dart';
import 'advanced_shimmer.dart';

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: const Row(
        children: [
          CircleShimmer(size: 40),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdvancedShimmer(height: 12, width: 140),
                SizedBox(height: 6),
                AdvancedShimmer(height: 10, width: 90),
              ],
            ),
          ),
          SizedBox(width: 12),
          AdvancedShimmer(height: 12, width: 40),
        ],
      ),
    );
  }
}
