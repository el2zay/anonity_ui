import 'package:flutter/material.dart';

ThemeData getCheckboxListTileThemeData(Brightness brightness) {
  Color? tileColor = brightness == Brightness.dark
      ? const Color.fromRGBO(40, 39, 44, 1)
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
      primaryColor: Colors.white,
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
        filled: false,
        fillColor: Color.fromRGBO(29, 32, 35, 1),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      // Card noire
      cardTheme: const CardTheme(
        color: Colors.black,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.white),
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
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: Colors.grey[200],
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      // Card blanche
      cardTheme: const CardTheme(
        color: Colors.white,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.black),
        fillColor: MaterialStateProperty.all(Colors.white),
      ),
      useMaterial3: true,
    );
  }
}
