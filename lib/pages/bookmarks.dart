import 'package:anonity/main.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:anonity/src/widgets/common_widgets.dart';
import 'package:anonity/src/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  void initState() {
    isBookmarkPage = true;
    super.initState();
  }

  @override
  void dispose() {
    isBookmarkPage = false;
    super.dispose();
  }

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
                      "Vous n'avez pas encore enregistré de Dénonciation.",
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
            return RawScrollbar(
              thumbColor: Colors.grey[600],
              radius: const Radius.circular(20),
              thickness: 5,
              interactive: true,
              timeToFade: const Duration(seconds: 3),
              fadeDuration: const Duration(milliseconds: 300),
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    title: snapshot.data![index].title!,
                    subject: snapshot.data![index].subject!,
                    age: snapshot.data![index].age!,
                    postId: snapshot.data![index].id!,
                    onRemoveFromBookmarks: (String postId) {
                      setState(() {
                        snapshot.data!
                            .removeWhere((element) => element.id == postId);
                      });
                    },
                  );
                },
              ),
            );
          } else {
            return loader();
          }
        },
      ),
    );
  }
}
