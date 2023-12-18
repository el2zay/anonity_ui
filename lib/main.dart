import 'dart:convert';

import 'package:denonceur/pages/empty_token.dart';
import 'package:denonceur/pages/home.dart';
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

final lightTheme = ThemeData(
  brightness: Brightness.light,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey[800],
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white70),
      // Texte en noir
      foregroundColor: MaterialStateProperty.all(Colors.black),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.grey),
  // Ajout du thème pour CheckboxListTile
  useMaterial3: true,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  scaffoldBackgroundColor: Colors.black,
  // le fond des listes soit en noir
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
  ),
  // App Bar en noir
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    // Couleur des icones en noir
    foregroundColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
      // Texte en noir
      foregroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
    ),
  ),
  // Mettre les icons button en gris
  iconTheme: IconThemeData(color: Colors.blueGrey[400]),
  // focusBorder des textfield en blanc
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey[900],
    contentTextStyle: const TextStyle(color: Colors.white),
  ),
  // listTileTheme: ListTileThemeData(
  //   tileColor: Colors.grey[900],
  //   shape: const RoundedRectangleBorder(
  //     borderRadius: BorderRadius.all(
  //       Radius.circular(15),
  //     ),
  //   ),
  // ),
  useMaterial3: true,
);

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
