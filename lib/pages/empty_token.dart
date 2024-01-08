// ignore_for_file: use_build_context_synchronously

import 'package:anonity/pages/home.dart';
import 'package:anonity/pages/settings/receive_passphrase.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmptyTokenPage extends StatefulWidget {
  const EmptyTokenPage({super.key});

  @override
  State<EmptyTokenPage> createState() => _EmptyTokenPageState();
}

class _EmptyTokenPageState extends State<EmptyTokenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            left: false,
            top: false,
            right: false,
            bottom: false,
            minimum: const EdgeInsets.only(top: 100.0),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Bienvenue sur Anonity !",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ReceivePassphrasePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text(
                      "J'ai déjà une passphrase",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CupertinoActivityIndicator(
                              radius: 20,
                            ),
                          );
                        },
                      );
                      var newToken = await register(context);

                      final prefs = await SharedPreferences.getInstance();
                      if (newToken != null) {
                        prefs.setString('token', newToken);
                        // Afficher la page HomePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text(
                      "Je n'ai pas de passphrase",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
