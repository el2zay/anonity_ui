// ignore_for_file: use_build_context_synchronously

import 'package:anonity/pages/show_post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:expandable_text/expandable_text.dart';

class Posts {
  String? title;
  String? subject;
  int? age;
  String? id;

  Posts({
    this.title,
    this.subject,
    this.age,
    this.id,
  });

  Posts.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        subject = json['body'],
        age = json['age'] as int?,
        id = json['id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = subject;
    data['age'] = age;
    data['id'] = id;
    return data;
  }
}

class PostCard extends StatefulWidget {
  final String title;
  final String subject;
  final int age;
  final String postId;

  const PostCard({
    super.key,
    required this.title,
    required this.subject,
    required this.age,
    required this.postId,
  });

  @override
  createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isMounted = false;
  bool isSupported = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    isMounted = true;
    checkSupportStatus();
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
  }

  Future<void> checkSupportStatus() async {
    List supportsIds = await fetchSupports(context);
    List bookmarksIds = await fetchBookmarksIds(context);
    if (isMounted) {
      setState(() {
        isSupported = supportsIds.contains(widget.postId);
        isBookmarked = bookmarksIds.contains(widget.postId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 18),
      elevation: 0.5,
      shadowColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: GestureDetector(
        onDoubleTap: () async {
          HapticFeedback.selectionClick();
          HapticFeedback.selectionClick();
          await supportsPost(context, widget.postId);
          checkSupportStatus();
          // TODO: Animation de soutien
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowPostPage(
                title: widget.title,
                subject: widget.subject,
                age: widget.age,
                postId: widget.postId,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                "${widget.title} (${widget.age} ans)",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              subtitle: ExpandableText(
                widget.subject,
                expandText: 'Voir plus',
                collapseText: '\nVoir moins',
                maxLines: 6,
                animation: false,
                linkColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 15),
            kIsWeb
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          debugPrint('Soutiens');
                        },
                        onTap: () async {
                          HapticFeedback.selectionClick();
                          await supportsPost(context, widget.postId);
                          checkSupportStatus();
                        },
                        child: isSupported
                            ? Image.asset(
                                "assets/heart-handshake.png",
                                height: 25,
                                width: 25,
                              )
                            : const Icon(
                                LucideIcons.heartHandshake,
                                size: 25,
                              ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          HapticFeedback.selectionClick();
                          await savePost(context, widget.postId);
                          checkSupportStatus();
                        },
                        child: isBookmarked
                            ? const Icon(
                                Icons.bookmark,
                                size: 25,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.bookmark_add_outlined,
                                size: 25,
                              ),
                      ),
                    ],
                  ),
            const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}
