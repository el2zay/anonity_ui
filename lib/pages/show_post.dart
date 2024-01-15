import 'package:anonity/main.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void _saveAlign(int alignment) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('align', alignment);
  }

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
                  _buildTextSizeMenu(),
                  PopupMenuItem(
                    value: 2,
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
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  align = 0;
                                  _saveAlign(align);
                                });
                              },
                              icon: Icon(
                                LucideIcons.alignLeft,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(align == 0 ? 0.5 : 1),
                                size: 20,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  align = 2;
                                  _saveAlign(align);
                                });
                              },
                              icon: Icon(
                                LucideIcons.alignCenter,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(align == 2 ? 0.5 : 1),
                                size: 20,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  align = 1;
                                  _saveAlign(align);
                                });
                              },
                              icon: Icon(
                                LucideIcons.alignRight,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(align == 1 ? 0.5 : 1),
                                size: 20,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  align = 3;
                                  _saveAlign(align);
                                });
                              },
                              icon: Icon(
                                LucideIcons.alignJustify,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(align == 3 ? 0.5 : 1),
                                size: 20,
                              )),
                        ],
                      )),
                  PopupMenuItem(
                    value: 3,
                    child: Icon(
                      LucideIcons.baseline,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
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
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.values[align],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem _buildTextSizeMenu() {
    return PopupMenuItem(
      child: Column(
        children: [
          const SizedBox(height: 10),
          TextSizeSlider(
            initialFontSize: fontSize,
            onChanged: (value) {
              setState(() {
                fontSize = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class TextSizeSlider extends StatefulWidget {
  final double initialFontSize;
  final ValueChanged<double> onChanged;

  const TextSizeSlider({
    super.key,
    required this.initialFontSize,
    required this.onChanged,
  });

  @override
  createState() => _TextSizeSliderState();
}

class _TextSizeSliderState extends State<TextSizeSlider> {
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

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
              widget.onChanged(value);
            },
            onChangeEnd: (value) async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setDouble("fontSize", value);
            },
          ),
        ),
        Text("${_fontSize.toInt()} pt"),
      ],
    );
  }
}
