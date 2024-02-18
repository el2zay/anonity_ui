import 'package:anonity/src/utils/common_utils.dart';
import 'package:anonity/pages/empty_token.dart';
import 'package:anonity/pages/home.dart';
import 'package:anonity/pages/reader.dart';
import 'package:anonity/src/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/foundation.dart';

bool isBookmarkPage = false;
final lightTheme = getAppSpecificTheme(false);
final darkTheme = getAppSpecificTheme(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  runApp(Phoenix(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = GetStorage().read('theme') ?? 0;
    final id = postId();
    return ChangeNotifierProvider(
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
            routes: {
              '/': (context) => (GetStorage().read('token') == "" ||
                          GetStorage().read('token') == null) &&
                      !kIsWeb
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
