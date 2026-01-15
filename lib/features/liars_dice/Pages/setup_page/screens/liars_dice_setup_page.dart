import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/localization_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../models/liars_dice_setup_args.dart';
import '../widgets/player_name_field.dart';
import '../widgets/players_count_chip.dart';

class LiarsDiceSetupPage extends StatefulWidget {
  const LiarsDiceSetupPage({super.key});

  @override
  State<LiarsDiceSetupPage> createState() => _LiarsDiceSetupPageState();
}

class _LiarsDiceSetupPageState extends State<LiarsDiceSetupPage> {
  int playersCount = 2;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    controllers = List.generate(
      playersCount,
      (index) => TextEditingController(text: 'Player ${index + 1}'),
    );
  }

  void _updatePlayersCount(int count) {
    setState(() {
      playersCount = count;
      _disposeControllers();
      _initControllers();
    });
  }

  void _disposeControllers() {
    for (final c in controllers) {
      c.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.translate('players_setup'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24.h),

              Text(
                t.translate('number_of_players'),
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),

              SizedBox(height: 12.h),

              Wrap(
                spacing: 12.w,
                children: List.generate(
                  5, // 2 → 6
                  (index) {
                    final value = index + 2;
                    return PlayersCountChip(
                      value: value,
                      selected: playersCount == value,
                      onTap: () => _updatePlayersCount(value),
                    );
                  },
                ),
              ),

              SizedBox(height: 30.h),

              Text(
                t.translate('player_names'),
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),

              SizedBox(height: 16.h),

              Expanded(
                child: ListView.separated(
                  itemCount: playersCount,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return PlayerNameField(
                      controller: controllers[index],
                      hint: t.translate(
                        'player_n',
                        params: {'number': '${index + 1}'},
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16.h),

              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    final players = controllers
                        .map((c) => c.text.trim())
                        .where((name) => name.isNotEmpty)
                        .toList();

                    if (players.length < 2) {
                      // ممكن SnackBar بعدين
                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      '/liars_dice_levels',
                      arguments: LiarsDiceSetupArgs(players: players),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    t.translate('start_game'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
