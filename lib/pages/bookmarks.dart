import 'package:denonceur/pages/home.dart';
import 'package:denonceur/src/requests.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrés"),
      ),
      body: FutureBuilder<List<Posts>>(
        future: fetchBookMarks(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Une erreur critique est survenue, pas d'inquiétude cela vient sûrement du serveur.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text("Réessayer"),
                  )
                ],
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.bookmark,
                      color: Colors.blue,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Vous n'avez pas encore enregistré de dénonciation.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      strutStyle: const StrutStyle(fontSize: 25.0),
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: const [
                          TextSpan(
                              text:
                                  'Lorsque tu souhaites enregistrer une Dénonciation, \nclique sur le bouton',
                              style: TextStyle(fontSize: 16.0)),
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.bookmark_add_outlined),
                            ),
                          ),
                          TextSpan(
                              text: 'de la Dénonciation',
                              style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(top: 10),
                  elevation: 7,
                  shadowColor: Colors.blue,
                  child: GestureDetector(
                    onDoubleTap: () {
                      debugPrint('Double tap!');
                      // TODO: Animation de soutien
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          title: Text(
                            "${snapshot.data![index].title} (${snapshot.data![index].age} ans)",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: ExpandableText(
                            snapshot.data![index].subject.toString(),
                            expandText: 'Voir plus',
                            collapseText: '\nVoir moins',
                            maxLines: 6,
                            animation: false,
                            linkColor: Colors.blue,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint('Soutiens');
                              },
                              child: const Icon(
                                LucideIcons.heartHandshake,
                                size: 25,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Emettre une vibration
                                HapticFeedback.selectionClick();
                                await savePost(
                                    snapshot.data![index].id, context);
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.bookmark,
                                color: Colors.blue,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            );
          }
        },
      ),
    );
  }
}
