import 'package:dice/features/liars_dice/Pages/game_page/widgets/claim/claim_selector_sheet.dart';
import 'package:dice/features/liars_dice/cubit/liars_dice_cubit.dart';
import 'package:dice/features/liars_dice/cubit/liars_dice_state.dart';
import 'package:dice/features/liars_dice/models/claim_model.dart';
import 'package:dice/features/liars_dice/models/game_phase.dart';
import 'package:dice/features/liars_dice/widgets/animated_dice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/localization_helper.dart';
import '../../../../../core/theme/app_colors.dart';
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
              final currentPlayer = state.players[state.currentPlayerIndex];

              final bool isDiceHidden = state.phase != GamePhase.rolling;
              final bool canRoll = state.phase == GamePhase.rolling;
              final bool canClaim =
                  state.phase == GamePhase.betting && !state.showDice;

              final bool canLiar =
                  state.phase == GamePhase.betting &&
                  state.currentClaim != null &&
                  !state.showDice;

              return Column(
                children: [
                  // 🔁 Turn Header
                  TurnHeader(
                    text: t.translate(
                      'player_turn',
                      params: {'player': currentPlayer.name},
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // 🎲 Dice Area (placeholder مؤقت)
                  Expanded(
                    child: Center(
                      child: state.showDice
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: currentPlayer.dice.map((value) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                  ),
                                  child: AnimatedDiceView(
                                    face: value,
                                    spinToken: state.spinToken,
                                    // يتغير مع كل رول
                                    size: 72.w,
                                  ),
                                );
                              }).toList(),
                            )
                          : Text(
                              t.translate('dice_hidden'),
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16.sp,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // 🎮 Action Buttons
                  GameActionButtons(
                    rollLabel: t.translate('roll_dice'),
                    claimLabel: t.translate('claim'),
                    liarLabel: t.translate('liar'),

                    // 🎲 Roll (لكل لاعب لوحده)
                    onRoll: canRoll
                        ? () {
                            cubit.rollCurrentPlayer();
                          }
                        : null,

                    // 📣 Claim
                    onClaim: canClaim
                        ? () {
                            showClaimSelector(
                              context: context,
                              currentBid: state.currentClaim,
                              isHardLevel: context
                                  .read<LiarsDiceCubit>()
                                  .config
                                  .onesAreWild,
                              maxQuantity: state.players.fold(
                                0,
                                (sum, p) => sum + p.dice.length,
                              ),
                              onConfirm: (quantity, face) {
                                cubit.makeClaim(
                                  ClaimModel(quantity: quantity, face: face),
                                );
                              },
                            );
                          }
                        : null,

                    // 🚨 Liar
                    onLiar: canLiar
                        ? () {
                            cubit.callLiar();
                            Navigator.pushNamed(
                              context,
                              '/liars_dice_reveal',
                              arguments: context.read<LiarsDiceCubit>(),
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
