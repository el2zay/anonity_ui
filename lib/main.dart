import 'dart:convert';

import 'package:denonceur/pages/empty_token.dart';
import 'package:denonceur/pages/home.dart';
import 'package:denonceur/src/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String passphrase;
late String token;
late bool notif;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  token = (await getToken())!;
  notif = await getNotif();
  passphrase = await getPassphrase();

  final lightTheme = getAppSpecificTheme(false);
  final darkTheme = getAppSpecificTheme(true);
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MaterialApp(
        title: 'Denonceur',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: token == "" ? const EmptyTokenPage() : const HomePage(),
      ),
    ),
  );
  // Mode portrait seulement
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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

// Route qui permet de charger la page de la droite vers la gauche
Route rToL(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
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
