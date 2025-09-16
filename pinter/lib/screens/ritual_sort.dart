import 'package:flutter/material.dart';
import 'package:ritual/model/ritual.dart';
import 'package:ritual/services/boxes.dart';
import 'package:ritual/services/constants.dart';

class RitualSort extends StatefulWidget {
  const RitualSort({super.key});

  @override
  State<RitualSort> createState() => _RitualSortState();
}

class _RitualSortState extends State<RitualSort> {
  @override
  Widget build(BuildContext context) {
    // Data from caller page
    Map data = ModalRoute.of(context)?.settings.arguments as Map;

    final List content = Boxes.getBox().values.toList().cast<Ritual>();

    List<Ritual> habitsOfRitual = [];

    // Get the habits of the ritual
    for (Ritual r in content) {
      if (r.url.contains(data['ritual'].url) &&
          r.type != Constants.typeRitual) {
        habitsOfRitual.add(r);
      }
    }

    // Sort the habits by position
    habitsOfRitual.sort((a, b) => a.position!.compareTo(b.position!));

    // Build the widget
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Sort ${data['ritual'].url.toString().replaceFirst("/", "")}"),
          centerTitle: true,
        ),
        body: ReorderableListView(
          buildDefaultDragHandles: false,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            for (int index = 0; index < habitsOfRitual.length; index += 1)
              ReorderableDragStartListener(
                key: Key('$index'),
                index: index,
                child: ListTile(
                  key: Key('$index'),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Habit card text
                      Text(habitsOfRitual[index].url.replaceFirst(
                          "${data['ritual'].url.toString()}/", "")),
                      // Reorder handle icon
                      const Icon(Icons.drag_indicator_sharp),
                    ],
                  ),
                ),
              )
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Ritual item = habitsOfRitual.removeAt(oldIndex);
              habitsOfRitual.insert(newIndex, item);

              final box = Boxes.getBox();

              // Update positions
              for (int i = 0; i < habitsOfRitual.length; i++) {
                habitsOfRitual[i].position = i;

              // Save position to Hive
              Ritual r = box.get(habitsOfRitual[i].key)!;
              r.position = i;
              r.save();
              }            
            });
          },
        ));
  }
}
