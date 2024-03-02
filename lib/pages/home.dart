import 'dart:io';

import 'package:anonity/src/utils/common_utils.dart';
import 'package:anonity/src/widgets/common_widgets.dart';
import 'package:anonity/pages/bookmarks.dart';
import 'package:anonity/pages/post.dart';
import 'package:anonity/pages/settings.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:anonity/src/widgets/post_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  AsyncSnapshot<List<Posts>>? _snapshot;
  ValueNotifier<bool> buttonsEnabled = ValueNotifier(true);
  final _scrollController = ScrollController();
  List<Posts> _posts = [];
  String _postIds = "";
  Future<List<Posts>>? _postsFuture;
  bool _isLoading = false;

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = fetchPosts(context, _postIds);
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_loadMorePosts);
    _postsFuture = fetchPosts(context, _postIds);
    _postsFuture?.then((initialPosts) {
      _posts = initialPosts;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_loadMorePosts);
  }

  void _loadMorePosts() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      var newPostIds = "$_postIds,${_posts.map((post) => post.id).join(",")}";
      var newPosts = await fetchPosts(context, newPostIds);

      setState(() {
        _posts = [..._posts, ...newPosts];
        _postsFuture = Future.value(_posts);
        _isLoading = false;

        _postIds = newPostIds;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_snapshot!.hasError) {
      Phoenix.rebirth(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double maxWidth =
          kIsWeb && constraints.maxWidth > 1000 ? 1000 : constraints.maxWidth;
      double screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
        appBar: AppBar(
          leading: kIsWeb
              ? null
              : IconButton(
                  icon: const Icon(Icons.bookmark_outline),
                  highlightColor: Colors.transparent,
                  iconSize: 30,
                  onPressed: () {
                    if (buttonsEnabled.value) {
                      Navigator.of(context).push(betterPush(
                          const BookmarksPage(), const Offset(-1.0, 0.0)));
                    } else {
                      showSnackBar(
                          context,
                          "Suite à une erreur tu ne peux pas accéder à tes favoris pour le moment...",
                          Icons.error);
                    }
                  },
                ),
          actions: kIsWeb
              ? [
                  IconButton(
                    // Bouton refresh
                    onPressed: () {
                      _refresh();
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: "rafraichir",
                  )
                ]
              : [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(betterPush(
                          const SettingsPage(), const Offset(1.0, 0.0)));
                    },
                    icon: const Icon(LucideIcons.settings),
                    highlightColor: Colors.transparent,
                    iconSize: 30,
                  ),
                ],
          title: Image.asset(
            "assets/icons/anonity.png",
            fit: BoxFit.contain,
            height: 40,
          ),
          centerTitle: true,
          bottom: kIsWeb
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: screenWidth >= 768
                              ? screenWidth * 0.7
                              : double.infinity,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Rechercher",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              contentPadding: const EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
        ),
        floatingActionButton: kIsWeb
            ? null
            : FloatingActionButton(
                child: Icon(
                  Icons.campaign,
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
                    showSnackBar(
                        context,
                        "Suite à une erreur tu ne peux pas témoigner pour le moment...",
                        Icons.error);
                  }
                },
              ),
        body: RefreshIndicator.adaptive(
          onRefresh: _refresh,
          displacement: 5,
          child: FutureBuilder<List<Posts>>(
            future: _postsFuture,
            builder: (context, AsyncSnapshot<List<Posts>> snapshot) {
              _snapshot = snapshot;
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
                            Phoenix.rebirth(context);
                          });
                        },
                        child: const Text("Réessayer"),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError &&
                  snapshot.connectionState == ConnectionState.done) {
                setState(() {});
                if (snapshot.hasError) {
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
                            Phoenix.rebirth(context);
                          },
                          child: const Text("Réessayer"),
                        ),
                      ],
                    ),
                  );
                }
              } else if (snapshot.hasData) {
                buttonsEnabled.value = true;
                return RawScrollbar(
                  thumbColor: Colors.grey[600],
                  radius: const Radius.circular(20),
                  thickness: 5,
                  interactive: true,
                  timeToFade: const Duration(seconds: 3),
                  fadeDuration: const Duration(milliseconds: 300),
                  controller: _scrollController,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (index == snapshot.data!.length - 1) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CupertinoActivityIndicator(
                                  radius: 10,
                                ),
                              ),
                            );
                          }
                          // TODO: Rajouter ce message à la fin
                          // return const Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: Column(
                          //     children: [
                          //       Text(
                          //         "Tu as atteint la fin de la liste.",
                          //         style: TextStyle(
                          //           fontSize: 20,
                          //           fontWeight: FontWeight.w700,
                          //         ),
                          //       ),
                          //       SizedBox(height: 15),
                          //       Text(
                          //         "Si tu souhaites témoigner, n'hésite pas.\nTu as juste a appuyé sur le bouton\nSache que ton témoignage est totalement anonyme et qu'il pourra permettre de t'aider mais aussi des personnes dans la même situation que toi.",
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //         textAlign: TextAlign.center,
                          //       )
                          //     ],
                          //   ),
                          // );
                          return PostCard(
                            title: snapshot.data![index].title!,
                            subject: snapshot.data![index].subject!,
                            age: snapshot.data![index].age!,
                            postId: snapshot.data![index].id!,
                            onRemoveFromBookmarks: (String postId) {},
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
              return loader();
            },
          ),
        ),
      );
    });
  }
}
