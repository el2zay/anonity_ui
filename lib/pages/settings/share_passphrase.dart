import 'package:anonity/main.dart';
import 'package:flutter/material.dart';
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
              // TODO: Afficher un message de succès avec une animation de check
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'La passphrase a été copiée !',
                  textAlign: TextAlign.center,
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(left: 70, right: 70),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                duration: Duration(seconds: 2),
              ));
            },
            child: const Text("Copier la passphrase"),
          )
        ],
      ),
    );
  }
}
