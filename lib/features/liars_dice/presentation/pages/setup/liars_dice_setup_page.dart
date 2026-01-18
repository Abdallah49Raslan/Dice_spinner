import 'package:dice/app/di/service_locator.dart';
import 'package:dice/features/liars_dice/presentation/models/liars_dice_setup_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/localization_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../cubit/setup/setup_cubit.dart';
import '../../cubit/setup/setup_state.dart';

// widgets
import '../../widgets/setup/player_names_list.dart';
import '../../widgets/setup/players_count_picker.dart';
import '../../widgets/setup/recent_presets_section.dart';
import '../../widgets/setup/setup_title.dart';
import '../../widgets/setup/start_game_button.dart';

class LiarsDiceSetupPage extends StatelessWidget {
  const LiarsDiceSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    String defaultName(int index) {
      return t.translate('player_n', params: {'number': '${index + 1}'});
    }

    return BlocProvider(
       create: (_) => sl<LiarsDiceSetupCubit>()..init(initialCount: 2, defaultName: defaultName),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: BlocBuilder<LiarsDiceSetupCubit, LiarsDiceSetupState>(
              builder: (context, state) {
                final cubit = context.read<LiarsDiceSetupCubit>();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SetupTitle(text: t.translate('players_setup')),
                    SizedBox(height: 24.h),
                    PlayersCountPicker(
                      label: t.translate('number_of_players'),
                      selectedCount: state.playersCount,
                      onChanged: (count) => cubit.setPlayersCount(
                        count,
                        defaultName: defaultName,
                      ),
                      min: 2,
                      max: 6,
                    ),
                    SizedBox(height: 22.h),

                    if (!state.loadingPresets && state.presets.isNotEmpty)
                      RecentPresetsSection(
                        presets: state.presets,
                        onUse: (players) => cubit.applyPreset(
                          players,
                          defaultName: defaultName,
                        ),
                        onDelete: (index) => cubit.deletePreset(index),
                        onClearAll: () => cubit.clearAllPresets(),
                      ),

                    if (!state.loadingPresets && state.presets.isNotEmpty)
                      SizedBox(height: 22.h),

                    PlayerNamesList(
                      label: t.translate('player_names'),
                      names: state.names,
                      hintBuilder: (i) => defaultName(i),
                      onNameChanged: (i, v) => cubit.setName(i, v),
                    ),

                    SizedBox(height: 16.h),

                    StartGameButton(
                      text: t.translate('start_game'),
                      onPressed: () async {
                        final players = state.names
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();

                        if (players.length < 2) return;

                        await cubit.saveCurrentPreset();

                        if (!context.mounted) return;

                        Navigator.pushNamed(
                          context,
                          '/liars_dice_levels',
                          arguments: LiarsDiceSetupArgs(players: players),
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
