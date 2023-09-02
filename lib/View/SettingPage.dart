import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/Controller/DataController.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReorderableListView Sample')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              color: Colors.black12,
            ),
            CafePriorityListWidget(),
          ],
        ),
      ),
    );
  }
}

class CafePriorityListWidget extends StatefulWidget {
  const CafePriorityListWidget({super.key});

  @override
  State<CafePriorityListWidget> createState() =>_CafePriorityListWidgetState ();
}

class _CafePriorityListWidgetState extends State<CafePriorityListWidget> {
  late final List<String> _items;
  final DataController _dataController = DataController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _items = _dataController.cafeList;
    print("hawing");
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    // final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return ReorderableListView(
      shrinkWrap: true,
      primary: false,
      header: Text("식당 순서 설정"),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        for (int index = 0; index < _items.length; index += 1)
          ListTile(
            key: Key('$index'),
            title: Text(_items[index]),
            trailing: ReorderableDragStartListener(
                index: index, child: const Icon(Icons.drag_handle)),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final String item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
          _dataController.updateCafePriority(_items);
        });
      },
    );
  }
}
