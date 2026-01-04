// import 'package:dice/core/helper/localization_helper.dart';
// import 'package:dice/core/theme/app_colors.dart';
// import 'package:dice/features/liars_dice/widgets/dice_card.dart';
// import 'package:dice/features/liars_dice/widgets/primary_button.dart';
// import 'package:dice/features/liars_dice/widgets/secondary_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class LiarsDiceEasyPage extends StatelessWidget {
//   const LiarsDiceEasyPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final t = LocalizationHelper.of(context);

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackground,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(24.w),
//           child: Column(
//             children: [
//               // 🔹 Turn Indicator
//               Text(
//                 t.translate('player_turn', params: {'player': '1'}),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               SizedBox(height: 40.h),

//               // 🎲 Dice Area
//               Expanded(
//                 child: Center(
//                   child: DiceCard(text: t.translate('dice_hidden')),
//                 ),
//               ),

//               SizedBox(height: 24.h),

//               // 🔘 Action Buttons
//               Column(
//                 children: [
//                   PrimaryButton(label: t.translate('roll_dice'), onTap: () {}),

//                   SizedBox(height: 12.h),

//                   Row(
//                     children: [
//                       Expanded(
//                         child: SecondaryButton(
//                           label: t.translate('claim'),
//                           onTap: () {},
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Expanded(
//                         child: SecondaryButton(
//                           label: t.translate('liar'),
//                           onTap: () {},
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
