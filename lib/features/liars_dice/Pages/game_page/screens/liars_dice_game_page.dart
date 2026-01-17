import 'package:dice/features/liars_dice/Pages/game_page/widgets/claim/claim_selector_sheet.dart';
import 'package:dice/features/liars_dice/Pages/game_page/widgets/game/player_dice_view.dart';
import 'package:dice/features/liars_dice/cubit/liars_dice_cubit.dart';
import 'package:dice/features/liars_dice/cubit/liars_dice_state.dart';
import 'package:dice/features/liars_dice/models/claim_model.dart';
import 'package:dice/features/liars_dice/models/game_phase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/localization_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/game/betting_history_panel.dart';
import '../widgets/game/game_action_buttons.dart';
import '../widgets/game/turn_header.dart';

class LiarsDiceGamePage extends StatelessWidget {
  const LiarsDiceGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: BlocBuilder<LiarsDiceCubit, LiarsDiceState>(
            builder: (context, state) {
              final cubit = context.read<LiarsDiceCubit>();

              if (state.players.isEmpty) return const SizedBox();

              final safeIndex = state.currentPlayerIndex.clamp(
                0,
                state.players.length - 1,
              );

              final currentPlayer = state.players[safeIndex];

              final canRoll =
                  state.phase == GamePhase.rolling &&
                  !state.rollLocked &&
                  !state.awaitingNext;

              final canNext =
                  state.phase == GamePhase.rolling &&
                  state.awaitingNext &&
                  !state.diceAnimating;

              final canClaim =
                  state.phase == GamePhase.betting && !state.showDice;

              final canLiar =
                  state.phase == GamePhase.betting &&
                  state.currentClaim != null &&
                  !state.showDice;

              // ✅ احسبها مرة واحدة
              final maxQuantity = state.players.fold(
                0,
                (sum, p) => sum + p.dice.length,
              );

              return Column(
                children: [
                  TurnHeader(
                    text: t.translate(
                      'player_turn',
                      params: {'player': currentPlayer.name},
                    ),
                  ),
                  SizedBox(height: 32.h),

                  Expanded(
                    child: (state.phase == GamePhase.betting && !state.showDice)
                        ? BettingHistoryPanel(history: state.claimHistory)
                        : PlayerDiceView(
                            showDice: state.showDice,
                            dice: currentPlayer.dice,
                            spinToken: state.spinToken,
                            hiddenText: t.translate('dice_hidden'),
                          ),
                  ),

                  SizedBox(height: 24.h),

                  GameActionButtons(
                    rollLabel: canNext
                        ? t.translate('next')
                        : t.translate('roll_dice'),
                    claimLabel: t.translate('claim'),
                    liarLabel: t.translate('liar'),

                    onRoll: canNext
                        ? cubit.confirmRollNext
                        : (canRoll ? cubit.rollCurrentPlayer : null),

                    onClaim: canClaim
                        ? () {
                            showClaimSelector(
                              context: context,
                              currentBid: state.currentClaim,
                              onesAreWild: cubit.config.onesAreWild,
                              maxQuantity: maxQuantity,
                              onConfirm: (quantity, face) {
                                cubit.makeClaim(
                                  ClaimModel(quantity: quantity, face: face),
                                );
                              },
                            );
                          }
                        : null,

                    onLiar: canLiar
                        ? () {
                            cubit.callLiar();
                            Navigator.pushNamed(
                              context,
                              '/liars_dice_reveal',
                              arguments: cubit,
                            );
                          }
                        : null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
