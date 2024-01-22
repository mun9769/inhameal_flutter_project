import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/Controller/data_controller.dart';
import '../constants/static_variable.dart';
import 'component/custom_reorderable_list_view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.parentSetState});

  final VoidCallback parentSetState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CafePriorityListWidget(
              parentSetState: parentSetState,
            ),
            Container(
              height: 20,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}

class CafePriorityListWidget extends StatefulWidget {
  const CafePriorityListWidget({super.key, required this.parentSetState});

  final VoidCallback parentSetState;

  @override
  State<CafePriorityListWidget> createState() => _CafePriorityListWidgetState();
}

class _CafePriorityListWidgetState extends State<CafePriorityListWidget> {
  late final List<String> _items;
  final DataController _dataController = DataController();

  @override
  void initState() {
    super.initState();
    _items = _dataController.cafeList;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      primary: false,
      header: Text("식당 순서 설정",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        for (int index = 0; index < _items.length; index += 1)
          ListTile(
            key: Key('$index'),
            title: Text(AppVar.cafeKorean[_items[index]] ?? "식당"),
            trailing: ReorderableDragStartListener(
                index: index, child: const Icon(Icons.drag_handle)),
          ),
      ],
      onReorder: this.onReorder,
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final String item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
    _dataController.updateCafePriority(_items);
    widget.parentSetState();
  }
}
