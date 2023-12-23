// ignore_for_file: use_build_context_synchronously

import 'package:denonceur/main.dart';
import 'package:denonceur/pages/empty_token.dart';
import 'package:denonceur/pages/report.dart';
import 'package:denonceur/pages/settings/change_theme.dart';
import 'package:denonceur/pages/settings/delete_data.dart';
import 'package:denonceur/pages/settings/share_passphrase.dart';
import 'package:denonceur/pages/settings/receive_passphrase.dart';
import 'package:denonceur/src/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isChecked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportPage(),
                ),
              );
            },
            icon: const Icon(Icons.bug_report_outlined),
            highlightColor: Colors.transparent,
            iconSize: 30,
          ),
        ],
      ),

      // Faire une liste de paramètre
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          Theme(
            data: getCheckboxListTileThemeData(
              Theme.of(context).brightness,
            ),
            child: CheckboxListTile(
              title: const Text(
                "Notifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              value: notif,
              onChanged: (bool? value) async {
                setState(() {
                  notif = value!;
                });
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('notif', isChecked);
              },
              activeColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 5),

          const Text(
              "Tu ne recevras des notifications que lorsque quelqu'un exprime son soutien à une de tes Dénonciations.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15)),

          const SizedBox(height: 40),

          // Bouton pour changer le thème
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                fixedSize: const Size.fromHeight(55)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeThemePage(),
                ),
              );
            },
            child: const Text(
              "Changer le thème",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 5),

          const Text(
              "Tu peux changer le thème de l'application pour qu'elle soit plus adaptée à ton utilisation.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15)),

          const SizedBox(height: 40),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                fixedSize: const Size.fromHeight(55)),
            onPressed: () {},
            child: const Text("Déguiser l'application",
                style: TextStyle(fontSize: 18)),
          ),

          const SizedBox(height: 5),

          const Text(
              "Tu peux changer l'icône de l'application pour la faire passer pour une autre application.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15)),

          const SizedBox(height: 40),

          // Bouton
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(fixedSize: const Size.fromHeight(55)),
            onPressed: () {
              showModalBottomSheet(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.86,
                ),
                isScrollControlled: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.0),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                builder: (BuildContext context) {
                  return const ReceivePassphrasePage();
                },
              );
            },
            child: const Text("Recevoir une passphrase",
                style: TextStyle(fontSize: 18)),
          ),

          const SizedBox(height: 5),

          const Text(
              "Tu peux recevoir la passphrase d'un autre appareil pour pouvoir te connecter sans perdre ce que tu as enregistré.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15)),

          const SizedBox(height: 40),

          // Bouton pour récupérer sa passphrase
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(fixedSize: const Size.fromHeight(55)),
            onPressed: () {
              // Afficher une petite popup qui vient du bas de l'écran
              showModalBottomSheet(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.36,
                ),
                isScrollControlled: false,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.0),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                builder: (BuildContext context) {
                  return const SharePassphrase();
                },
              );
            },
            child: const Text("Récupérer ma passphrase",
                style: TextStyle(fontSize: 18)),
          ),

          const SizedBox(height: 4),

          const Text(
              "Tu peux récupérer ta passphrase pour transférer tes données sur un autre appareil et les synchroniser.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15)),

          const SizedBox(height: 40),

          // Button se déconnecter
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                fixedSize: const Size.fromHeight(55)),
            onPressed: () {
              // Afficher une popup au centre de l'écran avec un bouton pour confirmer
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Se déconnecter"),
                    content: const Text(
                        "Tu vas être déconnecté de ton compte. Tu pourras te reconnecter plus tard avec ta passphrase."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Annuler"),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Supprimer le token
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('token');

                          // Afficher la page EmptyTokenPage et ne pas pouvoir la fermer
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmptyTokenPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text("Se déconnecter"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("Se déconnecter",
                style: TextStyle(color: Colors.red, fontSize: 18)),
          ),

          const SizedBox(height: 40),

          // Bouton supprimer mes données
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                fixedSize: const Size.fromHeight(55)),
            onPressed: () {
              // Afficher la page de suppression des données de bas en haut
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeleteDataPage(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: const Text("Supprimer mes données",
                style: TextStyle(color: Colors.red, fontSize: 18)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
