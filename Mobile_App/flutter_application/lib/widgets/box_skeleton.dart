import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BoxSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final bool shimmer;

  const BoxSkeleton({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: Colors.grey, borderRadius: borderRadius),
    );

    if (!shimmer) return box;

    return Shimmer(
      duration: const Duration(milliseconds: 1500),
      interval: const Duration(milliseconds: 300),
      color: Colors.grey.shade300,
      colorOpacity: 0.6,
      child: box,
    );
  }
}
