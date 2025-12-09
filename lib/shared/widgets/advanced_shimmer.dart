import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdvancedShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const AdvancedShimmer({
    super.key,
    required this.height,
    required this.width,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Circle shimmer
class CircleShimmer extends StatelessWidget {
  final double size;

  const CircleShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
