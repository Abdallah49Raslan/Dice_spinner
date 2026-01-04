import 'package:dice/app/app_routes.dart';
import 'package:dice/core/helper/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDiceApp extends StatelessWidget {
  const MyDiceApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dice Spinner',

          // 👇 routing هنا
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: '/',

          localizationsDelegates: const [
            LocalizationHelper.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
        );
      },
    );
  }
}
