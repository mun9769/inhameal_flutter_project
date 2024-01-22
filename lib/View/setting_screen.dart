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
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return true;
      },
      child: CustomReorderableListView.separated(
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 16),
          itemBuilder: (_, int index) => ListTile(
                key: Key('$index'),
                title: Text(AppVar.cafeKorean[_items[index]] ?? "식당"),
                trailing: ReorderableDragStartListener(
                    index: index, child: const Icon(Icons.drag_handle)),
              ),
          shrinkWrap: true,
          onReorder: this.onReorder,
          header: Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 8.0, bottom: 8.0),
            child: Text("식당 순서 설정",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
      ),
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
