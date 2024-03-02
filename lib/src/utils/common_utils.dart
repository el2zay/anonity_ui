import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

Route betterPush(Widget page, Offset offset, {bool fullscreenDialog = false}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (offset == const Offset(-1.0, 0.0)) {
            if (details.primaryDelta! < -10) {
              Navigator.pop(context);
            }
          } else if (offset == const Offset(1.0, 0.0)) {
            if (details.primaryDelta! > 10) {
              Navigator.pop(context);
            }
          }
        },
        child: page,
      );
    },
    fullscreenDialog: fullscreenDialog,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = offset;
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

String postId() {
  if (kIsWeb) {
    String? path = Uri.base.path;

    List<String> pathSegments = path.split('/');
    if (pathSegments[1] == 'post' && pathSegments[2] != "") {
      String postId = pathSegments[2];

      return postId;
    }
  }
  return "";
}

String getPassphrase() {
  if (GetStorage().read('token') == null || GetStorage().read('token') == "") {
    return "";
  }

  var tokenSplit = GetStorage().read('token').split('.')[1];
  var tokenSplitDecode = json.decode(
    utf8.decode(base64.decode(base64.normalize(tokenSplit))),
  );
  var passphrase = tokenSplitDecode['passphrase'];
  return passphrase ?? "";
}

void showSnackBar(BuildContext context, String message, IconData icon,
    [String? action]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      duration: const Duration(milliseconds: 2500),
      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      // action: action != null
      //     ? SnackBarAction(
      //         label: action,
      //         textColor: Colors.blue,
      //         onPressed: () {
      //           if (action == "Voir") {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => const PostPage(
      //                 ),
      //                 fullscreenDialog: true,
      //               ),
      //             );
      //             showModalBottomSheet(
      //               context: context,
      //               isScrollControlled: true,
      //               constraints: BoxConstraints(
      //                 maxHeight: MediaQuery.of(context).size.height * 0.9,
      //               ),
      //               builder: (context) {
      //                 return const DraftPage();
      //               },
      //             );
      //           }
      //         },
      //       )
      //     : null,
    ),
  );
}
