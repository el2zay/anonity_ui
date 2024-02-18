import 'package:anonity/src/widgets/common_widgets.dart';
import 'package:anonity/pages/set_reader.dart';
import 'package:anonity/src/utils/requests_utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReaderPage extends StatefulWidget {
  String? title;
  String? subject;
  int? age;
  String postId;

  ReaderPage({
    required this.postId,
    this.title,
    this.subject,
    this.age,
    super.key,
  });

  @override
  createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  void ifId() async {
    var post = await fetchPostId(widget.postId);
    setState(() {
      widget.title = post[0];
      widget.subject = post[1];
      widget.age = post[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == null || widget.subject == null || widget.age == null) {
      ifId();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: arrowBack(),
          onPressed: Navigator.of(context).pop,
        ),
      ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("${widget.title ?? "Titre null"} (${widget.age ?? 0} ans)",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.subject ?? "le sujet est null",
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
