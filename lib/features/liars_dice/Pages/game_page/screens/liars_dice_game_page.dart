import 'package:dice/features/liars_dice/Pages/game_page/widgets/claim/claim_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/localization_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/game/dice_placeholder.dart';
import '../widgets/game/game_action_buttons.dart';
import '../widgets/game/turn_header.dart';

class LiarsDiceGamePage extends StatelessWidget {
  const LiarsDiceGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    // UI-only placeholders
    final String currentPlayerName = 'Player 1';
    final bool isDiceHidden = true;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              TurnHeader(
                text: t.translate(
                  'player_turn',
                  params: {'player': currentPlayerName},
                ),
              ),

              SizedBox(height: 32.h),

              Expanded(
                child: Center(
                  child: DicePlaceholder(
                    hidden: isDiceHidden,
                    hiddenText: t.translate('dice_hidden'),
                    shownText: t.translate('dice_shown'),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              GameActionButtons(
                rollLabel: t.translate('roll_dice'),
                claimLabel: t.translate('claim'),
                liarLabel: t.translate('liar'),
                onRoll: () {},
                onClaim: () {
                  showClaimSelector(context: context);
                },
                onLiar: () {
                  Navigator.pushNamed(context, '/liars_dice_reveal');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
