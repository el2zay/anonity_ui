// ignore_for_file: use_build_context_synchronously

import 'package:anonity/main.dart';
import 'package:anonity/pages/reader.dart';
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
    checkStatus();
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
  }

  Future<void> checkStatus() async {
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
          if (onDoubleTap == 0) await supportsPost(context, widget.postId);
          if (onDoubleTap == 1) await savePost(context, widget.postId);
          if (onDoubleTap == 2) {
            Navigator.of(context).push(betterPush(
                ReaderPage(
                  title: widget.title,
                  subject: widget.subject,
                  age: widget.age,
                  postId: widget.postId,
                ),
                const Offset(1.0, 0.0)));
          }
          checkStatus();
        },
        onLongPress: () async {
          HapticFeedback.selectionClick();
          if (onLongPress == 0) await supportsPost(context, widget.postId);
          if (onLongPress == 1) await savePost(context, widget.postId);
          if (onLongPress == 2) {
            Navigator.of(context).push(betterPush(
                ReaderPage(
                  title: widget.title,
                  subject: widget.subject,
                  age: widget.age,
                  postId: widget.postId,
                ),
                const Offset(1.0, 0.0)));
          }
          checkStatus();
        },
        onTap: () async {
          if (onTap == 0) await supportsPost(context, widget.postId);
          if (onTap == 1) await savePost(context, widget.postId);
          if (onTap == 2) {
            Navigator.of(context).push(betterPush(
                ReaderPage(
                  title: widget.title,
                  subject: widget.subject,
                  age: widget.age,
                  postId: widget.postId,
                ),
                const Offset(1.0, 0.0)));
          }
          checkStatus();
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
                          checkStatus();
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
                          checkStatus();
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
