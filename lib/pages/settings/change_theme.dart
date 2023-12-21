import 'package:flutter/material.dart';

class ChangeThemePage extends StatelessWidget {
  const ChangeThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Changer le thème"),
      ),
      body: const Center(
        child: Text("Bientôt disponible"),
      ),
    );
  }
}
