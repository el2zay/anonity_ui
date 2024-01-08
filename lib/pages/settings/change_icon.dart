import 'package:anonity/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeIconPage extends StatefulWidget {
  const ChangeIconPage({super.key});

  @override
  State<ChangeIconPage> createState() => _ChangeIconPageState();
}

class _ChangeIconPageState extends State<ChangeIconPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Changer l'icône"),
      ),
      body: ListView(
        children: [
          buildListTile("", "Anonity", 0),
          const SizedBox(height: 20),
          buildListTile("assets/icons/instagram.png", "Instagram", 1),
          const SizedBox(height: 20),
          buildListTile("assets/icons/x.png", "𝕏", 2),
          const SizedBox(height: 20),
          buildListTile("assets/icons/threads.png", "Threads", 3),
          const SizedBox(height: 20),
          buildListTile("assets/icons/tiktok.png", "Tiktok", 4),
          const SizedBox(height: 20),
          buildListTile("assets/icons/whatsapp.png", "WhatsApp", 5),
          const SizedBox(height: 20),
          buildListTile("assets/icons/telegram.png", "Telegram", 6),
          const SizedBox(height: 20),
          buildListTile("assets/icons/signal.png", "Signal", 7),
          const SizedBox(height: 20),
          buildListTile("assets/icons/snapchat.png", "Snapchat", 8),
          const SizedBox(height: 20),
          buildListTile("assets/icons/discord.png", "Discord", 9),
          const SizedBox(height: 20),
          buildListTile("assets/icons/bereal.png", "BeReal", 10),
          const SizedBox(height: 20),
          buildListTile("assets/icons/netflix.png", "Netflix", 11),
          const SizedBox(height: 20),
          buildListTile("assets/icons/spotify.png", "Spotify", 12),
          const SizedBox(height: 20),
          buildListTile("assets/icons/amazon.png", "Amazon", 14),
          const SizedBox(height: 20),
          buildListTile("assets/icons/duolingo.png", "Duolingo", 15),
          const SizedBox(height: 20),
          buildListTile("assets/icons/github.png", "Github", 16),
          const SizedBox(height: 20),
          buildListTile("assets/icons/google.png", "Google", 17),
          const SizedBox(height: 20),
          buildListTile("assets/icons/papillon.png", "Papillon", 18),
          const SizedBox(height: 20),
          buildListTile("assets/icons/paypal.png", "PayPal", 19),
          const SizedBox(height: 20),
          buildListTile("assets/icons/free.png", "Free", 20),
        ],
      ),
    );
  }

  Widget buildListTile(String imagePath, String title, int index) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(imagePath, width: 50),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      onTap: () async {
        setState(() {
          icon = index;
        });
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('icon', index);
      },
      trailing: Checkbox(
        value: icon == index,
        onChanged: (bool? value) {
          setState(() {
            icon = index;
          });
        },
        activeColor: Colors.blue[600],
        checkColor: Colors.transparent,
        shape: const CircleBorder(),
      ),
    );
  }
}
