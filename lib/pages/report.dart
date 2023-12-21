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
      appBar: AppBar(),
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
              const SizedBox(height: 30),
              // TODO: Pouvoir inclure des captures
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
