import 'package:anonity/main.dart';
import 'package:anonity/pages/set_reader.dart';
import 'package:flutter/material.dart';

class ReaderPage extends StatefulWidget {
  final String title;
  final String subject;
  final int age;
  final String postId;

  const ReaderPage({
    super.key,
    required this.title,
    required this.subject,
    required this.age,
    required this.postId,
  });

  @override
  createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            barrierColor: const Color.fromARGB(42, 0, 0, 0),
            builder: (context) {
              return const SetReaderPage();
            },
          );
        },
        child: Icon(
          Icons.more_horiz,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("${widget.title} (${widget.age} ans)",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.subject,
                  style: TextStyle(fontSize: fontSize, fontFamily: fontFamily),
                  textAlign: TextAlign.values[align],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
