import 'dart:convert';
import 'dart:io' show Platform;

import 'package:anonity/pages/empty_token.dart';
import 'package:anonity/pages/home.dart';
import 'package:anonity/src/utils/theme_utils.dart';
import 'package:flutter/cupertino.dart';
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
late String fontFamily;
late int align;
late int onTap;
late int onDoubleTap;
late int onLongPress;
bool isBookmarkPage = false;

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
  fontFamily = await getFontFamily();
  align = await getAlign();
  onTap = await getOnTap();
  onDoubleTap = await getOnDoubleTap();
  onLongPress = await getOnLongPress();

  final lightTheme = getAppSpecificTheme(false);
  final darkTheme = getAppSpecificTheme(true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TokenProvider>(
          create: (context) => TokenProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer2<TokenProvider, ThemeProvider>(
        builder: (context, tokenProvider, themeProvider, child) {
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

class TokenProvider extends ChangeNotifier {
  String token = "";

  void setToken(newToken) {
    token = newToken;
    notifyListeners();
  }
}

Route betterPush(Widget page, Offset offset, {bool fullscreenDialog = false}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (offset == const Offset(-1.0, 0.0)) {
            if (details.primaryDelta! < -10) {
              Navigator.pop(context);
            }
          } else if (offset == const Offset(1.0, 0.0)) {
            if (details.primaryDelta! > 10) {
              Navigator.pop(context);
            }
          }
        },
        child: page,
      );
    },
    fullscreenDialog: fullscreenDialog,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = offset;
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

Future<String> getFontFamily() async {
  final prefs = await SharedPreferences.getInstance();
  final fontFamily = prefs.getString('fontFamily');

  return fontFamily ?? "Roboto";
}

Future<int> getAlign() async {
  final prefs = await SharedPreferences.getInstance();
  final align = prefs.getInt('align');

  return align ?? 0;
}

Future<int> getOnTap() async {
  final prefs = await SharedPreferences.getInstance();
  final onTap = prefs.getInt('onTap');

  return onTap ?? 2;
}

Future<int> getOnDoubleTap() async {
  final prefs = await SharedPreferences.getInstance();
  final onDoubleTap = prefs.getInt('onDoubleTap');

  return onDoubleTap ?? 0;
}

Future<int> getOnLongPress() async {
  final prefs = await SharedPreferences.getInstance();
  final onLongPress = prefs.getInt('onLongPress');

  return onLongPress ?? 1;
}

void showSnackBar(BuildContext context, String message, IconData icon) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
      // Margin width selon la taille de l'écran
      margin: MediaQuery.of(context).size.width > 500
          ? const EdgeInsets.only(left: 70, right: 70, bottom: 20)
          : const EdgeInsets.only(left: 20, right: 20, bottom: 20),
    ),
  );
}

Widget loader({color}) {
  return Platform.isIOS
      ? Center(
          child: CupertinoActivityIndicator(
            radius: 20,
            color: color,
          ),
        )
      : Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        );
}
