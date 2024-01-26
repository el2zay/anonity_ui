import 'package:anonity/main.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

enum IconLabel {
  support('Support', LucideIcons.heartHandshake),
  bookmark(
    'Enregistrer',
    Icons.bookmark,
  ),
  reader('Lecture', LucideIcons.bookOpen),
  heart('Rien', Icons.not_interested_sharp);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _ActionsPageState extends State<ActionsPage> {
  final TextEditingController iconController = TextEditingController();
  IconLabel? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: buildDropdownMenu(
                  labelText: "Tap : ",
                  initialValue: IconLabel.support,
                  onSelected: (IconLabel? icon) {},
                  valueToUpdate: onTap,
                  key: "onTap"),
            ),
            buildDropdownMenu(
                labelText: "Double Tap : ",
                initialValue: IconLabel.support,
                onSelected: (IconLabel? icon) {},
                valueToUpdate: onDoubleTap,
                key: "onDoubleTap"),
            buildDropdownMenu(
                labelText: "Long Press : ",
                initialValue: IconLabel.support,
                onSelected: (IconLabel? icon) {},
                valueToUpdate: onLongPress,
                key: "onLongPress"),
            ElevatedButton.icon(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setInt('onTap', 2);
                prefs.setInt('onDoubleTap', 0);
                prefs.setInt('onLongPress', 1);
                setState(() {
                  onTap = 2;
                  onDoubleTap = 0;
                  onLongPress = 1;
                });
              },
              icon: const Icon(Icons.replay_sharp),
              label: const Text("Réinitialiser"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownMenu(
      {required String labelText,
      required IconLabel initialValue,
      required Function(IconLabel?) onSelected,
      required int valueToUpdate,
      required String key}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(labelText),
        DropdownMenu<IconLabel>(
          initialSelection: IconLabel.values[valueToUpdate],
          onSelected: (IconLabel? icon) async {
            setState(() {
              selectedIcon = icon;
              valueToUpdate = selectedIcon!.index;
            });
            final prefs = await SharedPreferences.getInstance();
            prefs.setInt(key, selectedIcon!.index);
          },
          dropdownMenuEntries:
              IconLabel.values.map<DropdownMenuEntry<IconLabel>>(
            (IconLabel icon) {
              return DropdownMenuEntry<IconLabel>(
                value: icon,
                label: icon.label,
                leadingIcon: Icon(icon.icon),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
