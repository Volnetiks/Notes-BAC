import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bac_note/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bac_note/utils/secrets.dart' as secrets;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode? savedThemeMode = await AdaptiveTheme.getThemeMode();
  // runApp(MyApp(savedThemeMode: savedThemeMode));¨
  await SentryFlutter.init((options) {
    options.dsn = secrets.SENTRY_TOKEN;
    options.tracesSampleRate = 1.0;
  },
      appRunner: () => runApp(MyApp(
            savedThemeMode: savedThemeMode,
          )));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, required this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return AdaptiveTheme(
        light: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          brightness: Brightness.light,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.purple,
          ),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.black,
          unselectedWidgetColor: const Color.fromRGBO(235, 235, 235, 1),
          disabledColor: Colors.grey.shade500,
          fontFamily: 'SFUI',
        ),
        dark: ThemeData.dark().copyWith(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.white,
          unselectedWidgetColor: const Color.fromRGBO(46, 46, 46, 6),
          disabledColor: const Color.fromRGBO(182, 182, 182, 50),
          brightness: Brightness.light,
          textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'SFUI'),
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Notes BAC',
            theme: theme,
            darkTheme: darkTheme,
            home: const LoginPage()));
  }
}
