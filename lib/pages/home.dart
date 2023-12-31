import 'dart:io';

import 'package:denonceur/main.dart';
import 'package:denonceur/pages/bookmarks.dart';
import 'package:denonceur/pages/post.dart';
import 'package:denonceur/pages/settings.dart';
import 'package:denonceur/src/requests.dart';
import 'package:denonceur/src/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Définir l'icone bookmarks
Icon bookmarkIcon = const Icon(
  Icons.bookmark_add_outlined,
  size: 25,
);

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> buttonsEnabled = ValueNotifier(true);

  Future<void> _refresh() async {
    setState(() {
      checkUserConnection();
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  var activeConnection;
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.bookmark_outline),
          highlightColor: Colors.transparent,
          iconSize: 30,
          onPressed: () {
            if (buttonsEnabled.value) {
              Navigator.of(context).push(lToR(const BookmarksPage()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Suite à une erreur tu ne peux pas accéder à tes favoris pour le moment...',
                  textAlign: TextAlign.center,
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(left: 70, right: 70),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                duration: Duration(seconds: 2),
              ));
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(LucideIcons.settings),
            highlightColor: Colors.transparent,
            iconSize: 30,
          ),
        ],
        title: const Text('🔲', style: TextStyle(fontSize: 30)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: TextField(
              onChanged: (value) {
                if (value.length > 2) debugPrint(value);
              },
              decoration: InputDecoration(
                hintText: "Rechercher",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                contentPadding: const EdgeInsets.all(10),
                // Changer la couleur du fond
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.campaign, size: 35),
        onPressed: () {
          if (buttonsEnabled.value) {
            // Vérifier si les boutons sont actifs
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostPage(),
                fullscreenDialog: true,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Suite à une erreur tu ne peux pas témoigner pour le moment...',
                textAlign: TextAlign.center,
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(left: 70, right: 70),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              duration: Duration(seconds: 2),
            ));
          }
        },
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refresh,
        displacement: 5,
        color: const ColorSwatch(0xFF3F51B5, {
          50: Color(0xFFE8EAF6),
          100: Color(0xFFC5CAE9),
          200: Color(0xFF9FA8DA),
          300: Color(0xFF7986CB),
          400: Color(0xFF5C6BC0),
          500: Color(0xFF3F51B5),
          600: Color(0xFF3949AB),
          700: Color(0xFF303F9F),
          800: Color(0xFF283593),
          900: Color(0xFF1A237E),
        }),
        child: FutureBuilder<List<Posts>>(
          future: fetchPosts(context, null),
          builder: (context, AsyncSnapshot<List<Posts>> snapshot) {
            if (activeConnection == false) {
              buttonsEnabled.value = false;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off_outlined,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Impossible de se connecter à Internet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          checkUserConnection();
                        });
                      },
                      child: const Text("Réessayer"),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError &&
                snapshot.connectionState == ConnectionState.done) {
              debugPrint(snapshot.error.toString());
              buttonsEnabled.value = false;
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
                    ),
                    Text("${snapshot.error}"),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              buttonsEnabled.value = true;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (index == snapshot.data!.length - 1) {
                    return const Column(children: [
                      Text(
                        "Tu as atteint la fin de la liste.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Si tu souhaites témoigner, n'hésite pas.\nTu as juste a appuyé sur le bouton\nSache que ton témoignage est totalement anonyme et qu'il pourra permettre de t'aider mais aussi des personnes dans la même situation que toi.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ]);
                  }
                  return PostCard(
                    title: snapshot.data![index].title!,
                    subject: snapshot.data![index].subject!,
                    age: snapshot.data![index].age!,
                    postId: snapshot.data![index].id!,
                  );
                },
              );
            }
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            );
          },
        ),
      ),
    );
  }
}
