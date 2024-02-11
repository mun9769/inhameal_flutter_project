
import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/View/swipe_screen.dart';
import '../Controller/data_controller.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  final DataController _dataController = DataController();

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
  }

  void reload() {
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget._dataController.dummyFunc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          throw 'no cafe list';
          // TODO: error handling
        } else {
          return SwipePage(onUpdateCafeList: this.reload);
        }
      },
    );
  }
}
