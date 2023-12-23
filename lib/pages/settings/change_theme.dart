import 'package:denonceur/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThemePage extends StatefulWidget {
  const ChangeThemePage({super.key});

  @override
  State<ChangeThemePage> createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends State<ChangeThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Changer le thème"),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text(
              "Automatique",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            value: theme == 0,
            onChanged: (bool? value) async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setInt('theme', 0);
              setState(() {
                theme = 0;
              });
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
              final prefs = await SharedPreferences.getInstance();
              prefs.setInt('theme', 1);
              setState(() {
                theme = 1;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              "Sombre",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            value: theme == 2,
            onChanged: (bool? value) async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setInt('theme', 2);
              setState(() {
                theme = 2;
              });
            },
          ),
          // TODO: Mettre a jour le thème sans devoir redémarrer l'application
          const Text("Tu devras redémarrer l'application pour que les changement soit effectif")
        ],
      ),
    );
  }
}
