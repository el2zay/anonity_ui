import 'package:anonity/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeThemePage extends StatefulWidget {
  const ChangeThemePage({super.key});

  @override
  State<ChangeThemePage> createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends State<ChangeThemePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Changer le thème"),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          CheckboxListTile(
            activeColor: Colors.transparent,
            title: const Text(
              "Automatique",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            value: theme == 0,
            onChanged: (bool? value) async {
              setState(() {
                theme = 0;
              });

              prefs.setInt('theme', 0);
              themeProvider.setThemeMode(ThemeMode.system);
            },
          ),
          CheckboxListTile(
            title: const Text(
              "Clair",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            value: theme == 1,
            onChanged: (bool? value) async {
              setState(() {
                theme = 1;
              });

              prefs.setInt('theme', 1);
              themeProvider.setThemeMode(ThemeMode.light);
            },
          ),
          CheckboxListTile(
            activeColor: Colors.transparent,
            title: const Text(
              "Sombre",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            value: theme == 2,
            onChanged: (bool? value) async {
              setState(() {
                theme = 2;
              });

              prefs.setInt('theme', 2);
              themeProvider.setThemeMode(ThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }
}
