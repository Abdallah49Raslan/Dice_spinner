import 'package:dice/core/helper/localization_helper.dart';
import 'package:dice/core/theme/app_colors.dart';
import 'package:dice/features/liars_dice/Pages/game_page/widgets/reveal/reveal_actions.dart';
import 'package:dice/features/liars_dice/Pages/game_page/widgets/reveal/reveal_header.dart';
import 'package:dice/features/liars_dice/Pages/game_page/widgets/reveal/reveal_player_dice_card.dart';
import 'package:dice/features/liars_dice/cubit/liars_dice_cubit.dart';
import 'package:dice/features/liars_dice/cubit/liars_dice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiarsDiceRevealPage extends StatelessWidget {
  const LiarsDiceRevealPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: BlocListener<LiarsDiceCubit, LiarsDiceState>(
            listenWhen: (prev, curr) =>
                prev.players.length != curr.players.length &&
                curr.players.length == 1,
            listener: (context, state) {
              Navigator.pushReplacementNamed(
                context,
                '/liars_dice_winner',
                arguments: context.read<LiarsDiceCubit>(),
              );
            },
            child: BlocBuilder<LiarsDiceCubit, LiarsDiceState>(
              builder: (context, state) {
                final result = state.lastRoundResult;

                if (result == null) {
                  return const SizedBox();
                }

                final winner = result.playersSnapshot[result.winnerIndex];
                final loser = result.playersSnapshot[result.loserIndex];

                return Column(
                  children: [
                    RevealHeader(
                      title: t.translate('round_result'),
                      subtitle: t.translate(
                        'winner_is',
                        params: {'player': winner.name},
                      ),
                    ),

                    SizedBox(height: 32.h),

                    Expanded(
                      child: ListView.separated(
                        itemCount: result.playersSnapshot.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final player = result.playersSnapshot[index];

                          return RevealPlayerDiceCard(
                            playerName: player.name,
                            diceValues: player.dice,
                            isWinner: player.name == winner.name,
                            isLoser: player.name == loser.name,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24.h),

                    RevealActions(
                      nextRoundLabel: t.translate('next_round'),
                      endGameLabel: t.translate('end_game'),
                      onNextRound: () {
                        context.read<LiarsDiceCubit>().nextRound();
                        Navigator.pop(context);
                      },
                      onEndGame: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
