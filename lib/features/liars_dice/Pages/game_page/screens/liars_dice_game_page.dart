import 'dart:math' as math;

import 'package:dice/core/constants/dice_constants.dart';
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

              if (state.players.isEmpty) {
                return const SizedBox();
              }

              final safeIndex = state.currentPlayerIndex.clamp(
                0,
                state.players.length - 1,
              );

              final currentPlayer = state.players[safeIndex];

              final bool canRoll =
                  state.phase == GamePhase.rolling &&
                  !state.rollLocked &&
                  !state.awaitingNext;

              final bool canNext =
                  state.phase == GamePhase.rolling && state.awaitingNext;

              final bool canClaim =
                  state.phase == GamePhase.betting && !state.showDice;

              final bool canLiar =
                  state.phase == GamePhase.betting &&
                  state.currentClaim != null &&
                  !state.showDice;

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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (!state.showDice) {
                          return Center(
                            child: Text(
                              t.translate('dice_hidden'),
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16.sp,
                              ),
                            ),
                          );
                        }

                        final diceCount = currentPlayer.dice.length;
                        final spacing = 12.w;
                        final availableWidth = constraints.maxWidth;

                        final maxPerDice = diceCount > 0
                            ? (availableWidth - (spacing * (diceCount - 1))) /
                                  diceCount
                            : availableWidth;

                        final desired =
                            availableWidth * DiceConstants.diceSizeRatio;

                        final diceSize = math.min(
                          math.min(maxPerDice, desired),
                          110.w,
                        );

                        final rng = math.Random(); // ✅ واحد ثابت لكل build

                        return Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: spacing,
                            runSpacing: spacing,
                            children: currentPlayer.dice.map((value) {
                              return AnimatedDiceView(
                                face: value, // ✅ الوجه النهائي الحقيقي
                                spinToken:
                                    state.spinToken, // ✅ يشغل spin عند التغيير
                                size: diceSize, // ✅ Responsive

                                showBackground:
                                    true, // ✅ علشان الألوان تظهر من DiceConstants
                                showLabel: false,

                                // ✅ أثناء اللف: وجوه عشوائية
                                tickFacePicker: () =>
                                    rng.nextInt(DiceConstants.facesCount) +
                                    DiceConstants.minFace,
                              );
                            }).toList(),
                          ),
                        );
                      },
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
                        ? () => cubit.confirmRollNext()
                        : (canRoll ? () => cubit.rollCurrentPlayer() : null),

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
