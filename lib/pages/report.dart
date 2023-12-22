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
              // TODO: Pouvoir inclure des captures
              Card(
                elevation: 7,
                shadowColor: Colors.blue,
                child: Container(
                  margin: const EdgeInsets.all(100),
                  child: const Column(
                    children: [
                      Text("Ajouter une capture d'écran",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
