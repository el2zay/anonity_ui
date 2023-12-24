import 'package:denonceur/src/widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signaler un bug"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                decoration: const InputDecoration(
                  labelText: 'Adresse mail',
                  hintText: 'example@example.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tu dois renseigner une adresse mail.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              Card(
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
              const SizedBox(height: 45),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Envoyer'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
