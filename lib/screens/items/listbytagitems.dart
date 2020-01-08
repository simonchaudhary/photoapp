import 'package:flutter/material.dart';
import '../../models/framework.dart';

class ListByTagItems extends StatelessWidget {
  final List<Item> items;
  final String tag;
  ListByTagItems({this.items, this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List of items containing ' + tag),
        ),
        body: ListView(
          children: items
              .map((item) => item.itemTags.contains(tag)
                  ? Image.file(item.itemImage, height: 150.0, width: 150.0)
                  : Container())
              .toList(),
        ));
  }
}
