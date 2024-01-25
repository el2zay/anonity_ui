import 'package:flutter/material.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actions'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Tap : "),
            Text("Double Tap : "),
            Text("Triple Tap : "),
            Text("Long Press : "),
          ],
        ),
      ),
    );
  }
}
