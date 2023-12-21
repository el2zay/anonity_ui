import 'dart:convert';

import 'package:denonceur/main.dart';
import 'package:denonceur/pages/empty_token.dart';
import 'package:flutter/material.dart';
import 'package:denonceur/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Posts>> fetchBookMarks(context) async {
  final response =
      await http.get(Uri.parse('${dotenv.env['API_REQUEST']!}/bookmarks'),
          // Ajouter le token
          headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> data = jsonData['data'];

    return data.map((e) => Posts.fromJson(e)).toList();
  } else if (response.statusCode == 400) {
    return [];
  } else {
    showSnackBar(context, "Une erreur est survenue : ${response.reasonPhrase}");
    return [];
  }
}

Future<List<Posts>> fetchPosts(context) async {
  final response =
      await http.get(Uri.parse('${dotenv.env['API_REQUEST']!}/posts'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> data = jsonData['data'];

    return data.map((e) => Posts.fromJson(e)).toList();
  } else {
    showSnackBar(context, "Une erreur est survenue : ${response.reasonPhrase}");
    return [];
  }
}

Future<void> savePost(id, context) async {
  var request = http.Request(
      'POST', Uri.parse('${dotenv.env['API_REQUEST']!}/bookmarks'));
  request.body = jsonEncode({
    "id": id,
  });
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });
  final response = await request.send();

  if (response.statusCode != 200) {
    return showSnackBar(
        context, "Une erreur est survenue : ${response.reasonPhrase}");
  }
}

Future<void> supportsPost(id, context) async {
  var request =
      http.Request('POST', Uri.parse('${dotenv.env['API_REQUEST']!}/supports'));
  request.body = jsonEncode({
    "id": id,
  });
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });
  final response = await request.send();

  if (response.statusCode != 200) {
    return showSnackBar(
        context, "Une erreur est survenue : ${response.reasonPhrase}");
  }
}

Future<String?> register(context) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['API_REQUEST']!}/register'),
  );
  final Map<String, dynamic> jsonData = json.decode(response.body);

  if (response.statusCode == 200 && jsonData['success'] == true) {
    final String token = jsonData['message'];
    return token;
  } else {
    return "Une erreur est survenue : ${response.reasonPhrase}";
  }
}

Future<List> login(context, newPassphrase) async {
  if (newPassphrase == passphrase) {
    return ["Mais c'est déjà ta passphrase 👀", false];
  }
  var request =
      http.Request('POST', Uri.parse('${dotenv.env['API_REQUEST']!}/login'));
  request.body = jsonEncode({"passphrase": newPassphrase});
  request.headers.addAll({
    'Content-Type': 'application/json',
  });

  final response = await request.send();

  if (response.statusCode == 200) {
    final String responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> jsonData = json.decode(responseBody);

    final String token = jsonData['message'];

    return [token, true];
  } else if (response.statusCode == 400) {
    return ["La passphrase est incorrecte.", false];
  } else {
    return ["Une erreur est survenue : ${response.reasonPhrase}", false];
  }
}

Future<void> deleteDatas(context) async {
  debugPrint(token);
  final http.Response response = await http.delete(
    Uri.parse('${dotenv.env['API_REQUEST']!}/deleteAllMyDatas'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );
  // Récupérer success dans le body
  final Map<String, dynamic> jsonData = json.decode(response.body);
  final bool success = jsonData['success'];
  if (response.statusCode != 200 || success == false) {
    return showSnackBar(
        context, "Une erreur est survenue : ${response.reasonPhrase}");
  } else {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const EmptyTokenPage(),
      ),
      (route) => false,
    );
    // Supprimer le token
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 80, right: 80),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      duration: const Duration(seconds: 2),
    ),
  );
}
