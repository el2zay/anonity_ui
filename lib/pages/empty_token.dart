// ignore_for_file: use_build_context_synchronously

import 'package:anonity/main.dart';
import 'package:anonity/pages/home.dart';
import 'package:anonity/pages/settings/receive_passphrase.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmptyTokenPage extends StatefulWidget {
  const EmptyTokenPage({super.key});

  @override
  State<EmptyTokenPage> createState() => _EmptyTokenPageState();
}

class _EmptyTokenPageState extends State<EmptyTokenPage> {
  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.indigo, Colors.black],
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/splash.png',
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const Text(
                "Bienvenue dans Anonity !",
                style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Merci d'avoir télécharger l'application !",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(height: 70),
              ElevatedButton(
                onPressed: () async {
                  var newToken = await register(context);

                  if (newToken != null) {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('token', newToken);
                    tokenProvider.setToken(newToken);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 115)),
                child: const Text(
                  "M'INSCRIRE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReceivePassphrasePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: const Text(
                  "TU AS TA PASSPHRASE ? SE CONNECTER",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
