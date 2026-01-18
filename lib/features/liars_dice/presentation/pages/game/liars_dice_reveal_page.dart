import 'package:dice/features/liars_dice/presentation/widgets/game/reveal/reveal_actions.dart';
import 'package:dice/features/liars_dice/presentation/widgets/game/reveal/reveal_claim_summary.dart';
import 'package:dice/features/liars_dice/presentation/widgets/game/reveal/reveal_header.dart';
import 'package:dice/features/liars_dice/presentation/widgets/game/reveal/reveal_player_dice_card.dart';

import '../../../../../core/localization/localization_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../cubit/game/liars_dice_cubit.dart';
import '../../../domain/state/liars_dice_state.dart';
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
                if (result == null) return const SizedBox();

                final winner = result.playersSnapshot[result.winnerIndex];
                final loser = result.playersSnapshot[result.loserIndex];

                final onesAreWild = context
                    .read<LiarsDiceCubit>()
                    .config
                    .onesAreWild;

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 2 + result.playersSnapshot.length + 1,
                  // 2 = header + summary, + players, + 1 = actions
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    // 0 -> Header
                    if (index == 0) {
                      return RevealHeader(
                        title: t.translate('round_result'),
                        subtitle: t.translate(
                          'winner_is',
                          params: {'player': winner.name},
                        ),
                      );
                    }

                    // 1 -> Claim Summary
                    if (index == 1) {
                      return RevealClaimSummary(
                        claim: result.claim,
                        allDice: result.playersSnapshot
                            .map((p) => p.dice)
                            .toList(),
                        onesAreWild: onesAreWild,
                        claimIsTrue: result.claimIsTrue,
                      );
                    }

                    // آخر عنصر -> Actions
                    final lastIndex = 2 + result.playersSnapshot.length;
                    if (index == lastIndex) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: RevealActions(
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
                      );
                    }

                    // Players cards
                    final playerIndex = index - 2;
                    final player = result.playersSnapshot[playerIndex];

                    return RevealPlayerDiceCard(
                      playerName: player.name,
                      diceValues: player.dice,
                      isWinner: player.name == winner.name,
                      isLoser: player.name == loser.name,

                      // ✅ جديد
                      claimFace: result.claim.face,
                      onesAreWild: onesAreWild,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
