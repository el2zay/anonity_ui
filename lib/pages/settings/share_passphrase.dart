import 'package:anonity/main.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class SharePassphrase extends StatelessWidget {
  const SharePassphrase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: QrImageView(
              data: passphrase,
              version: QrVersions.auto,
              size: 200,
              gapless: false,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: passphrase));

              showSnackBar(
                  context, "La passphrase a été copiée.", LucideIcons.copy);
            },
            child: const Text("Copier la passphrase"),
          )
        ],
      ),
    );
  }
}
