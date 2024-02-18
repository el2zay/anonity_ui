import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

Widget loader({color}) {
  return defaultTargetPlatform == TargetPlatform.iOS
      ? Center(
          child: CupertinoActivityIndicator(
            radius: 20,
            color: color,
          ),
        )
      : Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        );
}

Widget arrowBack() {
  return defaultTargetPlatform == TargetPlatform.iOS
      ? const Icon(
          Icons.arrow_back_ios,
        )
      : const Icon(
          Icons.arrow_back,
        );
}