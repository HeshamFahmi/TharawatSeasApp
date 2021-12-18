import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/l10n.dart';
import 'homePage.dart';
import 'scanqr.dart';
import 'generated/locale_keys.g.dart';
import 'pageRoutes.dart';
import 'profile.dart';
import 'addAasl.dart';
import 'gaard.dart';
import 'mainScreen.dart';
import 'splashscreen.dart';
import 'constant.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        useOnlyLangCode: true,
        saveLocale: true,
        startLocale: Locale("en"),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LocaleKeys.AppName.tr(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        EasyLocalization.of(context).delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      theme: ThemeData(
        scaffoldBackgroundColor: mBackgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        PageRoutes.home: (context) => MainScreen(),
        PageRoutes.profile: (context) => Profile(),
        PageRoutes.gaard: (context) => Gaard(),
        PageRoutes.addAsal: (context) => AddAasl(),
        PageRoutes.scanqr: (context) => ScanScreen(),
        PageRoutes.homepage: (context) => HomePage()
      },
      home: SplashScreen(),
    );
  }
}
