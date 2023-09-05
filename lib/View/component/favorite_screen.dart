

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavScreen extends StatefulWidget{
  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      if(_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: IconButton(
          alignment: Alignment.center,
          icon: (_isFavorited
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border)),
          color: Colors.red[500],
          onPressed: _toggleFavorite,
        )
      )
    );
  }
}
