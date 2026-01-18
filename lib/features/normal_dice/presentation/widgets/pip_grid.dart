import 'package:flutter/material.dart';

class PipGrid extends StatelessWidget {
  final List<int> filledIndices;
  final Color pipColor;

  const PipGrid({
    super.key,
    required this.filledIndices,
    required this.pipColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;

        // ✅ spacing نسبي من حجم النرد (بدل 8.w)
        final spacing = (size * 0.08).clamp(2.0, 10.0);
        final blur = (size * 0.10).clamp(2.0, 10.0);
        final yOffset = (size * 0.03).clamp(1.0, 4.0);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final isFilled = filledIndices.contains(index);

            return AnimatedScale(
              scale: isFilled ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pipColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: blur,
                      offset: Offset(0, yOffset),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
