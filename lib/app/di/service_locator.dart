import 'package:get_it/get_it.dart';

import '../../features/liars_dice/domain/engine/liars_dice_engine.dart';
import '../../features/liars_dice/domain/entities/game_config.dart';
import '../../features/liars_dice/domain/repositories/liars_dice_history_repo.dart';
import '../../features/liars_dice/data/datasources/local/liars_dice_history_storage.dart';
import '../../features/liars_dice/data/repositories/liars_dice_history_repo_impl.dart';

// Cubits
import '../../features/liars_dice/presentation/cubit/setup/setup_cubit.dart';
import '../../features/liars_dice/presentation/cubit/game/liars_dice_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ========== External / Local Storage ==========
  sl.registerLazySingleton<LiarsDiceHistoryStorage>(() => LiarsDiceHistoryStorage());

  // ========== Repositories ==========
  sl.registerLazySingleton<LiarsDicePresetsRepo>(
    () => LiarsDicePresetsRepoImpl(sl<LiarsDiceHistoryStorage>()),
  );

  // ========== Domain Engine Factory ==========
  // Engine محتاج config، فـ factory (مش singleton)
  sl.registerFactoryParam<LiarsDiceEngine, GameConfig, void>(
    (config, _) => LiarsDiceEngine(config: config),
  );

  // ========== Cubits ==========
  // Setup cubit بيحتاج repo
  sl.registerFactory<LiarsDiceSetupCubit>(
    () => LiarsDiceSetupCubit(sl<LiarsDicePresetsRepo>()),
  );

  // Game cubit بيحتاج playerNames + config (factoryParam)
  sl.registerFactoryParam<LiarsDiceCubit, LiarsDiceCubitParams, void>(
    (params, _) => LiarsDiceCubit(
      playerNames: params.playerNames,
      config: params.config,
    ),
  );
}

class LiarsDiceCubitParams {
  final List<String> playerNames;
  final GameConfig config;

  const LiarsDiceCubitParams({
    required this.playerNames,
    required this.config,
  });
}
