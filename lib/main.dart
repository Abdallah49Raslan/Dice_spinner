// ignore_for_file: depend_on_referenced_packages
import 'package:dice/app/app_routes.dart';
import 'package:dice/app/my_dice_app.dart';
import 'package:dice/features/normal_dice/cubit/dice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Hive init using app documents directory
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(
    BlocProvider(
      create: (_) => DiceCubit(),
      child: MyDiceApp(appRouter: AppRouter()),
    ),
  );
}
