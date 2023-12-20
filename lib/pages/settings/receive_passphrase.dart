import 'package:denonceur/pages/home.dart';
import 'package:denonceur/src/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceivePassphrasePage extends StatefulWidget {
  const ReceivePassphrasePage({super.key});

  @override
  State<ReceivePassphrasePage> createState() => _ReceivePassphrasePageState();
}

String errorMessage = '';

class _ReceivePassphrasePageState extends State<ReceivePassphrasePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController _passphraseController = TextEditingController();
  List<String> wordsInPassphrase = [];

  Barcode? result;
  QRViewController? controller;
  bool showScanner = true;
  bool isButtonDisabled = true;

  late Widget scannerWidget;

  @override
  void dispose() {
    errorMessage = '';
    super.dispose();
  }

  void updateButtonState() {
    setState(() {
      // Ignorer l'espace vide à la fin si il y en a un
      if (wordsInPassphrase.last == '') {
        wordsInPassphrase.removeLast();
      }
      if (wordsInPassphrase.length != 50) {
        isButtonDisabled = true;
      } else {
        isButtonDisabled = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Créer le widget du scanner une fois dans initState
    scannerWidget = createScannerWidget();
  }

  Widget createScannerWidget() {
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        setState(() {
          this.controller = controller;
        });
        controller.scannedDataStream.listen((scanData) async {
          // Print le text du QR code
          await loginer(context, scanData.code);
        });
      },
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderColor: Colors.white,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Mettre une croix pour fermer la page
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: showScanner ? buildScannerWidget() : buildClosedScannerWidget(),
    );
  }

  Widget buildScannerWidget() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: isButtonDisabled
            ? null
            : () async {
                await loginer(context, _passphraseController.text);
              },
        backgroundColor: isButtonDisabled
            ? Theme.of(context).brightness == Brightness.light
                ? Colors.grey[500]
                : Colors.grey[800]
            : Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: const Icon(Icons.check, size: 35),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                errorMessage = '';
                showScanner = false;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(
                  top: 60, bottom: 60, left: 80, right: 80),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flash_on,
                  size: 40,
                ),
                SizedBox(height: 30),
                Text(
                  'Afficher le scanner',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _passphraseController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: 'Entre ta passphrase.',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            autocorrect: false,
            maxLines: 7,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              setState(() {
                wordsInPassphrase = value.split(' ');
                errorMessage = '';
              });
              updateButtonState();
            },
          ),
          const SizedBox(height: 10),
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red[800],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildClosedScannerWidget() {
    return Expanded(
      flex: 5,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: scannerWidget,
          ),
          if (errorMessage.isNotEmpty)
            Positioned(
              bottom: 80,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showScanner = true;
                    errorMessage = '';
                  });
                  FocusScope.of(context).unfocus();
                },
                child: const Text('Fermer le scanner'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginer(context, text) async {
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
    var loginFunc = await login(context, text);

    final prefs = await SharedPreferences.getInstance();

    if (loginFunc[1] == true) {
      prefs.setString('token', loginFunc[0]);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pop(context);
      setState(() {
        errorMessage = loginFunc[0];
      });
    }
  }
}
