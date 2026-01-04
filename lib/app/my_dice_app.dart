import 'package:dice/core/helper/localization_helper.dart';
import 'package:dice/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class MyDiceApp extends StatelessWidget {
  const MyDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Dice Spinner',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            LocalizationHelper.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
