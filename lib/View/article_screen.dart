// New: import the updateHeadline function
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/Model/news_data.dart';

import 'home_screen.dart';

class ArticleScreen extends StatefulWidget {
  late NewsArticle article;
  ArticleScreen({super.key, required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      // body: const Center(child: Text("haiwng")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Updating home screen widget...'),
          ));
          updateHeadline(widget.article);
        },
        label: const Text('Update Homescreen'),
      ),
    );
  }
}
