// ignore_for_file: use_build_context_synchronously

import 'package:denonceur/pages/home.dart';
import 'package:denonceur/pages/settings/receive_passphrase.dart';
import 'package:denonceur/src/requests.dart';
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
      appBar: AppBar(
        title: const Text('🔲', style: TextStyle(fontSize: 30)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
          const SizedBox(height: 40),
            const Text(
              "Bienvenue sur Dénonceur !",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 150),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReceivePassphrasePage()),
                );
              },
              child: const Text(
                "J'ai déjà une passphrase",
                style: TextStyle(fontSize: 20),
              ),
            ),
          const SizedBox(height: 10),
            const Text(
                "Tu peux récupérer ta passphrase pour transférer tes données sur un autre appareil et les synchroniser.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15)),
          const SizedBox(height: 40),
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
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }
              },
              child: const Text(
                "Je n'ai pas de passphrase",
                style: TextStyle(fontSize: 20),
              ),
            ),
          const SizedBox(height: 10),
            const Text(
                "Lors de la création de ta passphrase tu n'as pas besoin de donner une information personnelle.\nPour t'identifier, une passphrase te sera attribuée.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
