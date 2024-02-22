import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({super.key});

  @override
  State<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  Future<List> getDrafts() async {
    List<String> drafts = GetStorage().read('drafts') ?? [];
    return drafts.map((draft) => json.decode(draft)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brouillons'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RawScrollbar(
        thumbColor: Colors.grey[600],
        radius: const Radius.circular(20),
        thickness: 5,
        interactive: true,
        timeToFade: const Duration(seconds: 3),
        fadeDuration: const Duration(milliseconds: 300),
        child: ListView(
          children: [
            FutureBuilder(
              future: getDrafts(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.data != null) {
                  return Column(
                    children: snapshot.data!.map((draft) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "${draft['title'] ?? ""} (${draft['age'] ?? ""} ans)",
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
                                List<String> drafts =
                                    GetStorage().read('drafts') ?? [];
                                drafts.remove(json.encode(draft));
                                GetStorage().write('drafts', drafts);

                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                        subtitle: Text(
                          draft['expression'] ?? "",
                        ),
                        onTap: () {
                          Navigator.pop(context, {
                            "title": draft['title'],
                            "expression": draft['expression'],
                            "age": draft['age']
                          });
                        },
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(
                      child: Text(
                    "Tu n'as pas de brouillons.",
                    textAlign: TextAlign.center,
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
