// ignore_for_file: use_build_context_synchronously

import 'package:anonity/src/widgets/common_widgets.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:anonity/src/widgets/image_picker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String errorMessage = '';
  bool showLoading = false;

  @override
  void dispose() {
    errorMessage = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !showLoading,
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Signaler un bug"),
            centerTitle: true,
            automaticallyImplyLeading: showLoading ? false : true,
            leading: showLoading
                ? null
                : IconButton(
                    icon: arrowBack(),
                    onPressed: () {
                      if (_titleController.text.isNotEmpty ||
                          _descriptionController.text.isNotEmpty ||
                          _emailController.text.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog.adaptive(
                              title: const Text('Attention'),
                              content: const Text(
                                  "En quittant cette page, tu perdras toutes les informations saisies. Es-tu sûr de vouloir quitter cette page ?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Rester', style: TextStyle(
                            color: defaultTargetPlatform == TargetPlatform.iOS
                                ? Colors.blue[500]
                                : null)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child:  Text('Quitter', style: TextStyle(
                            color: defaultTargetPlatform == TargetPlatform.iOS
                                ? Colors.red
                                : null)),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  )),
        body: showLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: Column(
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                            maxLength: 100,
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Titre',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tu dois renseigner un titre.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                            maxLength: 5000,
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tu dois renseigner une description.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Adresse mail',
                              hintText: 'example@example.com',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onEditingComplete: () {
                              // TODO: Vérifier l'e-mail
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tu dois renseigner une adresse mail.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Column(
                                children: [
                                  Text(
                                    'Ajouter des images',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Tu peux ajouter jusqu'à 3 images.",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ImagePickerWidget(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (errorMessage.isNotEmpty)
                            Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red[800],
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (getImagesPath()!.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Erreur'),
                                        content: const Text(
                                            "Tu dois ajouter au moins une image pour envoyer ton rapport de bug.\r"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    showLoading = true;
                                  });
                                  reportActions(context);
                                }
                              }
                            },
                            child: const Text('Envoyer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void reportActions(BuildContext context) async {
    var bugReportFunc = await bugReport(
      context,
      _titleController.text,
      _descriptionController.text,
      _userController.text,
      _emailController.text,
      getImagesPath()![0],
      getImagesPath()![1],
      getImagesPath()![2],
    );

    setState(() {
      errorMessage = bugReportFunc;
    });

    setState(
      () {
        showLoading = false;
      },
    );

    if (bugReportFunc == '') Navigator.pop(context);
  }
}
