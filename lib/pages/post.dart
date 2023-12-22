// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _expressionController = TextEditingController();
  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _ageController.addListener(updateButtonState);
    _titleController.addListener(updateButtonState);
    _expressionController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _titleController.dispose();
    _expressionController.dispose();
    super.dispose();
  }

  void updateButtonState() {
    setState(() {
      if (_ageController.text.isEmpty ||
          _titleController.text.isEmpty ||
          _expressionController.text.length < 70) {
        isButtonDisabled = true;
      } else {
        isButtonDisabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Lorsque l'on clic sur le bouton retour, on ferme le clavier
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Âge",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 145, right: 145, bottom: 20),
              child: TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(fontSize: 21),
                textAlign: TextAlign.center,
                maxLength: 2,
                keyboardType: TextInputType.number,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Titre",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLength: 30,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Exprime toi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _expressionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLength: 5000,
                // TODO Ne pas pouvoir sauter plus de 2 lignes à la fois

                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isButtonDisabled
            ? null
            : () async {
                await postData(_ageController.text, _titleController.text,
                    _expressionController.text, context);
                Navigator.pop(context);
              },
        backgroundColor: isButtonDisabled
            ? Theme.of(context).brightness == Brightness.light
                ? Colors.grey[500]
                : Colors.grey[800]
            : Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: const Icon(Icons.check, size: 35),
      ),
    );
  }
}

Future<void> postData(age, title, expression, context) async {
  var request =
      http.Request('POST', Uri.parse('https://denonceurapi.oriondev.fr/posts'));
  request.body = jsonEncode({
    'age': age,
    'title': title,
    'body': expression,
  });
  request.headers.addAll({
    'Authorization':
        'Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJwYXNzcGhyYXNlIjoiZmlicm9jaW1lbnRzIHJldGFpbGxhdGVzIGFmZnJ1aXRhdCBkdWxjaWZpZXJhaXQgZGVzaW50b3hpcXVleiByZWNvbHRhc3NlIHNpZmZsZXMgZmx1b3J1cmVzIHBvdGFzc2VyYWkgZGlhbGVjdGFsaXNlZSBnb3VybWVlcyBjaGF0b3lhc3NlbnQgaW5uZXJ2ZWUgZ2FzcGlsbGVyYWkgcmV0YWJsaXJhaXMgc3VycGF5ZXMgbWFnb3VpbGxlcmV6IGVsYWJvcmVyIHRlcm5pc3NleiBwZXJjZXJhaSBmb3JsaWduaWV6IGVwYXVsYXRlcyBtb3JhbGlzb25zIGF0dGFjaGVzLWNhc2VzIGV2YW5nZWxpc2F0IHNvY2lvZ3JhbW1lcyBhZ29uaXNzZXogYXNzdW1lcmFzIGNhcmF2YW5pZXIgZW5nb3VsZXJhaXMga2lsb21ldHJlcmFpIHJlZm91bGVyZW50IGRlY2hpcmlvbnMgYmFkaWdlb25uZXMgcGFsdWNoZSBkZW1vYmlsaXNlciBlbWJyYXF1ZWVzIGVudHJldG9pc2FtZXMgcmVvcmdhbmlzZXJpb25zIGRlZ291cGlsbGVyaW9ucyBkZXZlcm5pcmlleiBidXJpbmFzc2lleiBjbGFwZXJhcyBnYWJhcmRpbmVzIHJlZm91aWxsaWV6IGV0cmFuZ2xlcm9udCBiZWxldHRlIGNyb3V0b25zIHJlcGxpc3Nhc3NlcyBzb21tZWlsbGVyb250ICJ9.D8PStxRakWgYR22dli4itP9z8yNxslEg56m1pPCONKDO48-Gt1CAtXYPLkyZ16cQt3yedGD4tEC7PP9CteNsug',
    'Content-Type': 'application/json',
  });

  final response = await request.send();

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Merci pour ta dénonciation !",
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 70, right: 70),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      duration: Duration(seconds: 2),
    ));
  } else {
    // TODO: Conserver la dénonciation en cache pour la renvoyer plus tard
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Une erreur est survenue lors de l'envoi de votre dénonciation.",
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 70, right: 70),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      duration: Duration(seconds: 2),
    ));
  }
}
