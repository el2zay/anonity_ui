import 'dart:convert';

import 'package:anonity/pages/empty_token.dart';
import 'package:anonity/pages/home.dart';
import 'package:anonity/src/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

late String passphrase;
late String token;
late bool notif;
late int theme;
late int icon;
late double fontSize;
late int align;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  token = (await getToken())!;
  notif = await getNotif();
  passphrase = await getPassphrase();
  theme = await getTheme();
  icon = await getIcon();
  fontSize = await getFontSize();
  align = await getAlign();

  final lightTheme = getAppSpecificTheme(false);
  final darkTheme = getAppSpecificTheme(true);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          ThemeMode initialThemeMode = theme == 0
              ? ThemeMode.system
              : theme == 1
                  ? ThemeMode.light
                  : ThemeMode.dark;
          if (themeProvider.themeMode != ThemeMode.system) {
            initialThemeMode = themeProvider.themeMode;
          }

          return MaterialApp(
            title: 'Anonity',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: initialThemeMode,
            home: token == "" && !kIsWeb
                ? const EmptyTokenPage()
                : const HomePage(),
          );
        },
      ),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// Route qui permet de charger la page de la gauche vers la droite
Route lToR(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  return token ?? "";
}

Future<bool> getNotif() async {
  final prefs = await SharedPreferences.getInstance();
  final notif = prefs.getBool('notif');

  return notif ?? false;
}

Future<String> getPassphrase() async {
  if (token == "") {
    return "";
  }

  var tokenSplit = token.split('.')[1];
  var tokenSplitDecode = json.decode(
    utf8.decode(base64.decode(base64.normalize(tokenSplit))),
  );
  var passphrase = tokenSplitDecode['passphrase'];
  return passphrase ?? "";
}

Future<int> getTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final theme = prefs.getInt('theme');

  return theme ?? 0;
}

Future<int> getIcon() async {
  final prefs = await SharedPreferences.getInstance();
  final icon = prefs.getInt('icon');

  return icon ?? 0;
}

Future<double> getFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  final fontSize = prefs.getDouble('fontSize');

  return fontSize ?? 20;
}

Future<int> getAlign() async {
  final prefs = await SharedPreferences.getInstance();
  final align = prefs.getInt('align');

  return align ?? 0;
}
