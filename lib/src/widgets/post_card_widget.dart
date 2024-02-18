// ignore_for_file: use_build_context_synchronously

import 'package:anonity/main.dart';
import 'package:anonity/src/utils/common_utils.dart';
import 'package:anonity/pages/reader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:share_plus/share_plus.dart';

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
  final Function(String postId) onRemoveFromBookmarks;

  const PostCard({
    super.key,
    required this.title,
    required this.subject,
    required this.age,
    required this.postId,
    required this.onRemoveFromBookmarks,
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
    checkStatus(context);
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
  }

  Future<void> checkStatus(context) async {
    if (isMounted) {
      List supportsIds = await fetchSupports(context);
      List bookmarksIds = await fetchBookmarksIds(context);
      if (isMounted) {
        setState(() {
          isSupported = supportsIds.contains(widget.postId);
          isBookmarked = bookmarksIds.contains(widget.postId);
        });
      }
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
          HapticFeedback.lightImpact();
          await supportsPost(context, widget.postId);
          checkStatus(context);
        },
        onLongPress: () async {
          HapticFeedback.selectionClick();
          await savePost(context, widget.postId);
          checkStatus(context);
        },
        onTap: () async {
          Navigator.of(context).push(betterPush(
              ReaderPage(
                title: widget.title,
                subject: widget.subject,
                age: widget.age,
                postId: widget.postId,
              ),
              const Offset(1.0, 0.0)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "${widget.title} (${widget.age} ans)",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () async {
                      if (kIsWeb) {
                        await Clipboard.setData(ClipboardData(
                            text: 'https://app.anonity.fr/${widget.postId}'));
                        showSnackBar(context, 'Lien copié', LucideIcons.link);
                      } else {
                        final result = await Share.shareWithResult(
                            'https://app.anonity.fr/${widget.postId}',
                            subject: widget.title);

                        if (result.status == ShareResultStatus.success) {
                          showSnackBar(context, 'Merci pour ton partage',
                              LucideIcons.heartHandshake);
                        }
                      }
                    },
                    icon: kIsWeb
                        ? const Icon(LucideIcons.link2, size: 16)
                        : const Icon(
                            LucideIcons.share,
                            size: 16,
                          ),
                  )
                ],
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
                          checkStatus(context);
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
                          if (isBookmarkPage) {
                            setState(() {
                              widget.onRemoveFromBookmarks(widget.postId);
                            });
                          }
                          checkStatus(context);
                        },
                        child: isBookmarkPage
                            ? const Icon(
                                Icons.bookmark,
                                size: 25,
                                color: Colors.blue,
                              )
                            : isBookmarked
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
