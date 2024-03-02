// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:anonity/src/utils/common_utils.dart';
import 'package:anonity/pages/draft.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isButtonDisabled = true;
  bool titleMessage = true;
  bool expressionMessage = true;

  final ageController = TextEditingController();
  final titleController = TextEditingController();
  final expressionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ageController.addListener(updateButtonState);
    titleController.addListener(updateButtonState);
    expressionController.addListener(updateButtonState);
  }

  // Dispose
  @override
  void dispose() {
    ageController.dispose();
    titleController.dispose();
    expressionController.dispose();
    super.dispose();
  }

  void updateButtonState() {
    setState(() {
      isButtonDisabled = ageController.text.isEmpty ||
          titleController.text.replaceAll(RegExp(r'[\s\u200E]'), '').length <
              10 ||
          expressionController.text
                  .replaceAll(RegExp(r'[\s\u200E]'), '')
                  .length <
              70;

      titleMessage =
          titleController.text.replaceAll(RegExp(r'[\s\u200E]'), '').length <
              10;
      expressionMessage = expressionController.text
              .replaceAll(RegExp(r'[\s\u200E]'), '')
              .length <
          70;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (expressionController.text.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog.adaptive(
                    title: const Text("Quitter"),
                    content: const Text(
                      "Tu es sur le point de quitter sans publier ton message. Souhaites-tu l'enregistrer dans les brouillons ?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          List<dynamic> dynamicList =
                              GetStorage().read('drafts') ?? [];

                          List<String> drafts = dynamicList
                              .map((item) => item.toString())
                              .toList();

                          Map<String, String> newDraft = {
                            'age': ageController.text,
                            'title': titleController.text,
                            'expression': expressionController.text,
                          };
                          drafts.add(json.encode(newDraft));

                          await GetStorage().write('drafts', drafts);

                          Navigator.pop(context);
                          Navigator.pop(context);
                          showSnackBar(
                              context,
                              "Ta Dénonciation a bien été enregistrée",
                              Icons.check, "Voir");
                        },
                        child: Text("Enregistrer", style: TextStyle(
                            color: defaultTargetPlatform == TargetPlatform.iOS
                                ? Colors.blue[500]
                                : null)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Quitter", style: TextStyle(
                            color: defaultTargetPlatform == TargetPlatform.iOS
                                ? Colors.red
                                : null)),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  builder: (context) {
                    return const DraftPage();
                  },
                ).then((value) {
                  if (value != null) {
                    Map<String, dynamic> returnedData = value;
                    setState(() {
                      ageController.text = returnedData["age"];
                      titleController.text = returnedData["title"];
                      expressionController.text = returnedData["expression"];
                    });
                  }
                });
              },
              child: const Text("Brouillons")),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              const Text(
                "Âge",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                  ),
                  child: TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(fontSize: 21),
                    textAlign: TextAlign.center,
                    maxLength: 2,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) =>
                        null,
                  ),
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
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLength: 45,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              if (titleMessage)
                RichText(
                  textAlign: TextAlign.center,
                  strutStyle: const StrutStyle(fontSize: 25.0),
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.blue[400],
                        ),
                      ),
                      TextSpan(
                          text: '\t10 lettres minimum.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[400],
                          )),
                    ],
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
                  controller: expressionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLength: 5000,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              if (expressionMessage)
                RichText(
                  textAlign: TextAlign.center,
                  strutStyle: const StrutStyle(fontSize: 25.0),
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.blue[400],
                        ),
                      ),
                      TextSpan(
                          text: '\t70 lettres minimum.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[400],
                          )),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isButtonDisabled
            ? null
            : () async {
                await postData(context, ageController.text,
                    titleController.text, expressionController.text);
              },
        backgroundColor: isButtonDisabled
            ? Theme.of(context).brightness == Brightness.light
                ? Colors.grey[500]
                : Colors.grey[800]
            : Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: Icon(
          Icons.check,
          size: 35,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}