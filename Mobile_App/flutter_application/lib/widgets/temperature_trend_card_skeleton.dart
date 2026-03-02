import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TemperatureTrendCardSkeleton extends StatelessWidget {
  const TemperatureTrendCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(
                duration: const Duration(milliseconds: 1500),
                interval: const Duration(milliseconds: 300),
                color: Colors.grey.shade300,
                colorOpacity: 0.6,
                child: Container(
                  width: 140,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Shimmer(
                duration: const Duration(milliseconds: 1500),
                interval: const Duration(milliseconds: 300),
                color: Colors.grey.shade300,
                colorOpacity: 0.6,
                child: Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Temperature labels skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) => 
              Shimmer(
                duration: const Duration(milliseconds: 1500),
                interval: const Duration(milliseconds: 300),
                color: Colors.grey.shade300,
                colorOpacity: 0.6,
                child: Column(
                  children: [
                    Container(
                      width: 30,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 25,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Chart skeleton
          SizedBox(
            height: 100,
            child: Shimmer(
              duration: const Duration(milliseconds: 1500),
              interval: const Duration(milliseconds: 300),
              color: Colors.grey.shade300,
              colorOpacity: 0.6,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
