// ignore_for_file: use_build_context_synchronously

import 'package:denonceur/src/requests.dart';
import 'package:flutter/material.dart';

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
                maxLength: 45,
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
                await postData(context, _ageController.text, _titleController.text,
                    _expressionController.text);
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
