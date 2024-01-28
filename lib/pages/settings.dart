// ignore_for_file: use_build_context_synchronously
import 'dart:io' show Platform;

import 'package:anonity/main.dart';
import 'package:anonity/pages/empty_token.dart';
import 'package:anonity/pages/report.dart';
import 'package:anonity/pages/settings/actions.dart';
import 'package:anonity/pages/settings/change_icon.dart';
import 'package:anonity/pages/settings/change_theme.dart';
import 'package:anonity/pages/settings/delete_data.dart';
import 'package:anonity/pages/settings/share_passphrase.dart';
import 'package:anonity/pages/settings/receive_passphrase.dart';
import 'package:anonity/src/utils/theme_utils.dart';
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
              Navigator.of(context).push(
                betterPush(
                  const ReportPage(),
                  const Offset(1.0, 0.0),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                showSnackBar(
                    context,
                    "Notifications ${value! ? "activées" : "désactivées"}",
                    Icons.notifications);
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
              Navigator.of(context).push(
                betterPush(
                  const ChangeThemePage(),
                  const Offset(1.0, 0.0),
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
            onPressed: () {
              Navigator.of(context).push(
                  betterPush(const ChangeIconPage(), const Offset(1.0, 0.0)));
            },
            child:
                const Text("Changer l'icône", style: TextStyle(fontSize: 18)),
          ),

          const SizedBox(height: 5),

          const Text(
              "Tu peux changer l'icône de l'application pour la faire passer pour une autre application.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15)),

          const SizedBox(height: 40),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                fixedSize: const Size.fromHeight(55)),
            onPressed: () {
              Navigator.of(context).push(
                  betterPush(const ActionsPage(), const Offset(1.0, 0.0)));
            },
            child: const Text("Personnaliser les actions",
                style: TextStyle(fontSize: 18)),
          ),

          const SizedBox(height: 5),

          const Text(
              "Tu peux personnaliser les actions sur les posts pour pouvoir les faires comme tu le souhaites et plus rapidement.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15)),

          const SizedBox(height: 40),

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
              double maxHeight = MediaQuery.of(context).size.height * 0.7;
              if (maxHeight > 300) {
                maxHeight = 300;
              }

              showModalBottomSheet(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                useSafeArea: true,
                isScrollControlled: true,
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
                  return AlertDialog.adaptive(
                    title: const Text("Se déconnecter"),
                    content: const Text(
                        "Tu vas être déconnecté de ton compte. Tu pourras te reconnecter plus tard avec ta passphrase."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Annuler",
                            style: TextStyle(
                                color:
                                    Platform.isIOS ? Colors.blue[500] : null)),
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
                        child: Text("Se déconnecter",
                            // Si on est sur iOS afficher en rouge
                            style: TextStyle(
                                color: Platform.isIOS ? Colors.red : null)),
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
              Navigator.of(context).push(
                  betterPush(const DeleteDataPage(), const Offset(1.0, 0.0)));
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
