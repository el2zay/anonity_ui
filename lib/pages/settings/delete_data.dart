import 'dart:async';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteDataPage extends StatefulWidget {
  const DeleteDataPage({super.key});

  @override
  State<DeleteDataPage> createState() => _DeleteDataPageState();
}

var labelDanger = "Je comprends, et souhaite supprimer mes données.";
var sec = 7;
dynamic timer;
var isClicked = false;

class _DeleteDataPageState extends State<DeleteDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Supprimer tes données",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "En supprimant tes données, toutes tes Dénonciations seront supprimées, mais aussi tes favoris sur tous les appareils avec la même passphrase.\nCette action est irréversible et tu ne pourras pas récupérer tes données après cela.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                backgroundColor:
                    isClicked ? Colors.white : const Color(0xFFD0342C),
              ),
              child: Text(
                labelDanger,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isClicked ? Colors.black : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                setState(() {
                  if (labelDanger ==
                      "Je comprends, et souhaite supprimer mes données.") {
                    labelDanger = "Annuler $sec";
                  } else {
                    labelDanger =
                        "Je comprends, et souhaite supprimer mes données.";
                  }
                  isClicked = !isClicked;
                });
                if (isClicked) {
                  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    setState(() {
                      sec--;
                      labelDanger = "Annuler $sec";
                    });
                    if (sec == 0) {
                      setState(() {
                        isClicked = false;
                        labelDanger =
                            "Je comprends, et souhaite supprimer mes données.";
                        sec = 7;
                      });
                      timer.cancel();
                      const CupertinoActivityIndicator();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CupertinoActivityIndicator(
                              radius: 20,
                              color: Color(0xFFD0342C),
                            ),
                          );
                        },
                      );
                      deleteDatas(context);
                    }
                  });
                } else if (!isClicked) {
                  setState(() {
                    isClicked = false;
                    labelDanger =
                        "Je comprends, et souhaite supprimer mes données.";
                    sec = 7;
                  });
                  timer.cancel();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
