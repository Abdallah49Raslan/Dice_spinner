import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.w,
        crossAxisSpacing: 8.w,
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
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
