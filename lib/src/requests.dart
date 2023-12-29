import 'dart:convert';

import 'package:denonceur/main.dart';
import 'package:denonceur/pages/empty_token.dart';
import 'package:denonceur/src/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
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

Future<List<Posts>> fetchSupports(context) async {
  final response =
      await http.get(Uri.parse('${dotenv.env['API_REQUEST']!}/supports'),
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

Future<List<Posts>> fetchPosts(context, postIds) async {
  final response =
      await http.get(Uri.parse('${dotenv.env['API_REQUEST']!}/posts?ids=$postIds'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> data = jsonData['data'];

    return data.map((e) => Posts.fromJson(e)).toList();
  } else {
    showSnackBar(context, "Une erreur est survenue : ${response.reasonPhrase}");
    return [];
  }
}

Future<void> postData(context, age, title, expression) async {
  var request =
      http.Request('POST', Uri.parse('https://denonceurapi.oriondev.fr/posts'));
  request.body = jsonEncode({
    'age': age,
    'title': title,
    'body': expression,
  });
  request.headers.addAll({
    'Authorization':
        'Bearer $token',
    'Content-Type': 'application/json',
  });

  final response = await request.send();

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Merci pour ta dénonciation !",
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 70, right: 70),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      duration: Duration(seconds: 2),
    ));
  } else {
    // TODO: Conserver la dénonciation en cache pour la renvoyer plus tard
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Une erreur est survenue lors de l'envoi de votre dénonciation.",
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 70, right: 70),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      duration: Duration(seconds: 2),
    ));
  }
}

Future<void> savePost(context, id) async {
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

Future<void> supportsPost(context, id) async {
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

Future bugReport(
    context, title, description, user, email, path1, path2, path3) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('${dotenv.env['API_REQUEST']!}/bugs'));
  request.fields.addAll({
    'title': title,
    'description': description,
    'user': user,
    'email': email
  });
  if (path1 != [] && path1 != null) {
    request.files.add(await http.MultipartFile.fromPath('screenshot1', path1));
  }
  if (path2 != null) {
    request.files.add(await http.MultipartFile.fromPath('screenshot2', path2));
  }
  if (path3 != null) {
    request.files.add(await http.MultipartFile.fromPath('screenshot3', path3));
  }

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // Print ce qui a été envoyer
    showSnackBar(context, "Merci pour ton rapport de bug !");
  } else {
    // Récupérer "message" dans le body
    final String responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> jsonData = json.decode(responseBody);
    final String message = jsonData['message'];
    return message;
  }
  return "";
}

Future<void> deleteDatas(context) async {
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
