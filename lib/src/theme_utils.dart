import 'package:flutter/material.dart';

ThemeData getCheckboxListTileThemeData(Brightness brightness) {
  Color? tileColor = brightness == Brightness.dark
      ? Colors.grey[900]
      : const Color.fromRGBO(223, 221, 226, 1);

  Color? textColor =
      brightness == Brightness.dark ? Colors.white : Colors.black;

  return ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    listTileTheme: ListTileThemeData(
      tileColor: tileColor,
      textColor: textColor,
    ),
  );
}

ThemeData getAppSpecificTheme(bool isDarkMode) {
  if (isDarkMode) {
    return ThemeData(
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
      useMaterial3: true,
    );
  } else {
    return ThemeData(
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
      useMaterial3: true,
    );
  }
}
