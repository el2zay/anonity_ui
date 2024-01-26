import 'package:anonity/main.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetReaderPage extends StatefulWidget {
  const SetReaderPage({super.key});

  @override
  State<SetReaderPage> createState() => _SetReaderPageState();
}

class _SetReaderPageState extends State<SetReaderPage> {
  bool showFonts = false;
  @override
  Widget build(BuildContext context) {
    return showFonts ? fontsWidget(context) : themesSettingsWidget(context);
  }

  Widget themesSettingsWidget(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thèmes et réglages",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextSizeSlider(
              initialFontSize: fontSize,
              onChanged: (value) {
                setState(() {
                  fontSize = value;
                });
              },
            ),
            const SizedBox(height: 15),
            const Text("Alignement"),
            const SizedBox(height: 10),
            const Alignment(),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  showFonts = true;
                });
              },
              child: Row(
                children: [
                  const Text("Police"),
                  const Spacer(),
                  Text(fontFamily,
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          fontFamily: fontFamily)),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                    size: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    fontSize = 20;
                    fontFamily = "Roboto";
                    align = 0;
                  });
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setDouble("fontSize", 20);
                    prefs.setString("fontFamily", "Roboto");
                    prefs.setInt("align", 0);
                  });
                },
                icon: const Icon(Icons.replay_sharp),
                label: const Text("Réinitialiser")),
          ],
        ),
      ),
    );
  }

  Widget fontsWidget(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Police",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              showFonts = false;
            });
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: FontList(
                selectedFont: fontFamily,
                onChanged: (value) {
                  setState(() {
                    fontFamily = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Alignment extends StatefulWidget {
  const Alignment({super.key});

  @override
  State<Alignment> createState() => _AlignmentState();
}

class _AlignmentState extends State<Alignment> {
  void _saveAlign(int alignment) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('align', alignment);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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

class FontList extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String selectedFont;

  const FontList({
    super.key,
    required this.selectedFont,
    required this.onChanged,
  });

  @override
  createState() => _FontListState();
}

class _FontListState extends State<FontList> {
  late String _selectedFont;

  List<String> availableFonts = [
    'Arial',
    'Comic Sans MS',
    'Garamond',
    'Roboto',
    'Segoe UI',
    'Times New Roman',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFont = widget.selectedFont;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: false,
      itemCount: availableFonts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(availableFonts[index],
              style:
                  TextStyle(fontFamily: availableFonts[index], fontSize: 20)),
          trailing: _selectedFont == availableFonts[index]
              ? const Icon(Icons.check)
              : null,
          onTap: () async {
            setState(() {
              _selectedFont = availableFonts[index];
            });
            widget.onChanged(availableFonts[index]);
          },
        );
      },
    );
  }
}
