import 'package:dice/core/helper/localization_helper.dart';
import 'package:dice/core/theme/app_colors.dart';
import 'package:dice/features/liars_dice/Pages/game_page/widgets/reveal/reveal_actions.dart';
import 'package:dice/features/liars_dice/Pages/game_page/widgets/reveal/reveal_header.dart';
import 'package:dice/features/liars_dice/Pages/game_page/widgets/reveal/reveal_player_dice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiarsDiceRevealPage extends StatelessWidget {
  const LiarsDiceRevealPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    // UI-only dummy data
    final players = ['Player 1', 'Player 2', 'Player 3'];
    final diceValues = [3, 6, 2];
    final winner = 'Player 1';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              RevealHeader(
                title: t.translate('round_result'),
                subtitle: t.translate('winner_is', params: {'player': winner}),
              ),

              SizedBox(height: 32.h),

              Expanded(
                child: ListView.separated(
                  itemCount: players.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    return RevealPlayerDiceCard(
                      playerName: players[index],
                      diceValue: diceValues[index],
                    );
                  },
                ),
              ),

              SizedBox(height: 24.h),

              RevealActions(
                nextRoundLabel: t.translate('next_round'),
                endGameLabel: t.translate('end_game'),
                onNextRound: () {},
                onEndGame: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
