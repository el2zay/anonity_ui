import 'dart:convert';

import 'package:anonity/pages/empty_token.dart';
import 'package:anonity/pages/home.dart';
import 'package:anonity/pages/reader.dart';
import 'package:anonity/src/utils/theme_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/foundation.dart';

late SharedPreferences prefs;
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
final lightTheme = getAppSpecificTheme(false);
final darkTheme = getAppSpecificTheme(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
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

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final id = postId();
    return MultiProvider(
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
            routes: {
              '/': (context) => token == "" && !kIsWeb
                  ? const EmptyTokenPage()
                  : const HomePage(),
              '/post': (context) => ReaderPage(
                    postId: id,
                  ),
            },
          );
        },
      ),
    );
  }
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

String postId() {
  if (kIsWeb) {
    String? path = Uri.base.path;

    List<String> pathSegments = path.split('/');
    if (pathSegments[1] == 'post' && pathSegments[2] != "") {
      String postId = pathSegments[2];

      return postId;
    }
  }
  return "";
}

Future<String?> getToken() async {
  final token = prefs.getString('token');

  return token ?? "";
}

Future<bool> getNotif() async {
  final notif = prefs.getBool('notif');

  return notif ?? true;
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
  final theme = prefs.getInt('theme');

  return theme ?? 0;
}

Future<int> getIcon() async {
  final icon = prefs.getInt('icon');

  return icon ?? 0;
}

Future<double> getFontSize() async {
  final fontSize = prefs.getDouble('fontSize');

  return fontSize ?? 20;
}

Future<String> getFontFamily() async {
  final fontFamily = prefs.getString('fontFamily');

  return fontFamily ?? "Roboto";
}

Future<int> getAlign() async {
  final align = prefs.getInt('align');

  return align ?? 0;
}

Future<int> getOnTap() async {
  final onTap = prefs.getInt('onTap');

  return onTap ?? 2;
}

Future<int> getOnDoubleTap() async {
  final onDoubleTap = prefs.getInt('onDoubleTap');

  return onDoubleTap ?? 0;
}

Future<int> getOnLongPress() async {
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
          Flexible(
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
      duration: const Duration(seconds: 1),
      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    ),
  );
}

Widget loader({color}) {
  return defaultTargetPlatform == TargetPlatform.iOS
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

Widget arrowBack() {
  return defaultTargetPlatform == TargetPlatform.iOS
      ? const Icon(
          Icons.arrow_back_ios,
        )
      : const Icon(
          Icons.arrow_back,
        );
}
