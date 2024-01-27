import 'dart:convert';
import 'package:anonity/main.dart';
import 'package:anonity/pages/empty_token.dart';
import 'package:anonity/src/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
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
    showSnackBar(context, "Une erreur est survenue : ${response.reasonPhrase}",
        Icons.error);
    return [];
  }
}

Future<List> fetchBookmarksIds(context) async {
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
    final List ids = data.map((e) => e['id']).toList();
    return ids;
  } else if (response.statusCode == 400) {
    return [];
  } else {
    showSnackBar(context, "Une erreur est survenue : ${response.reasonPhrase}",
        Icons.error);
    return [];
  }
}

Future<List> fetchSupports(context) async {
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
    final List ids = data.map((e) => e['id']).toList();
    return ids;
  } else if (response.statusCode == 400) {
    return [];
  } else {
    showSnackBar(context, "Une erreur est survenue : ${response.reasonPhrase}",
        Icons.error);
    return [];
  }
}

Future<List<Posts>> fetchPosts(context, postIds) async {
  final response = await http
      .get(Uri.parse('${dotenv.env['API_REQUEST']!}/posts?ids=$postIds'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> data = jsonData['data'];
    return data.map((e) => Posts.fromJson(e)).toList();
  } else {
    return [];
  }
}

Future<void> postData(context, age, title, expression) async {
  var request =
      http.Request('POST', Uri.parse('${dotenv.env['API_REQUEST']!}/posts'));
  request.body = jsonEncode({
    'age': age,
    'title': title,
    'body': expression,
  });
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });

  final response = await request.send();

  if (response.statusCode == 200) {
    showSnackBar(context, "Merci pour ta dénonciation !", LucideIcons.heart);
  } else {
    // TODO: Conserver la dénonciation en cache pour la renvoyer plus tard
    showSnackBar(
        context,
        "Suite à une erreur ta dénonciation sera envoyée plus tard.",
        Icons.info_rounded);
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
    return showSnackBar(context,
        "Une erreur est survenue : ${response.reasonPhrase}", Icons.error);
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
    return showSnackBar(context,
        "Une erreur est survenue : ${response.reasonPhrase}", Icons.error);
  }
}

Future register(context) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['API_REQUEST']!}/register'),
  );
  final Map<String, dynamic> jsonData = json.decode(response.body);

  if (response.statusCode == 200 && jsonData['success'] == true) {
    final String token = jsonData['message'];
    return token;
  } else {
    return showSnackBar(context,
        "Une erreur est survenue : ${response.reasonPhrase}", Icons.error);
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
    showSnackBar(context, "Merci pour ton rapport de bug !", Icons.error);
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
    return showSnackBar(context,
        "Une erreur est survenue : ${response.reasonPhrase}", Icons.error);
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
