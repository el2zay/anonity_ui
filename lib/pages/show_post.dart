import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

double _fontSize = 20;

class ShowPostPage extends StatefulWidget {
  final String title;
  final String subject;
  final int age;
  final String postId;

  const ShowPostPage({
    super.key,
    required this.title,
    required this.subject,
    required this.age,
    required this.postId,
  });

  @override
  createState() => _ShowPostPageState();
}

class _ShowPostPageState extends State<ShowPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "Plus",
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 20, 100),
                items: [
                  const PopupMenuItem(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        TextSizeSlider(),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const SizedBox(height: 10),
                          Image.asset(
                            "assets/font.png",
                            color: Theme.of(context).primaryColor,
                            width: 25,
                          ),
                          const SizedBox(width: 10),
                          const Text("Changer la police"),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).primaryColor,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Icon(
                      LucideIcons.baseline,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Icon(
                      LucideIcons.palette,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${widget.title} (${widget.age} ans)",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Text(
                widget.subject,
                style: TextStyle(fontSize: _fontSize),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextSizeSlider extends StatefulWidget {
  const TextSizeSlider({super.key});

  @override
  createState() => _TextSizeSliderState();
}

class _TextSizeSliderState extends State<TextSizeSlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/text-size.png",
          color: Theme.of(context).primaryColor,
          width: 25,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Slider.adaptive(
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).primaryColor.withOpacity(0.5),
            value: _fontSize,
            min: 10,
            max: 40,
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
        ),
        Text("${_fontSize.toInt()} pt"),
      ],
    );
  }
}
