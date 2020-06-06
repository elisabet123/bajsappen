import 'package:flutter/material.dart';

import '../poop.dart';

class PoopRatingIcon extends StatelessWidget {
  final Poop poop;

  const PoopRatingIcon(this.poop, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: IconTheme(
        data: IconThemeData(size: 40),
        child: _poopIcon(),
      ));
  }

  Widget _poopIcon() {
    if (poop.rating == null) {
      return Icon(
        Icons.sentiment_neutral,
        color: Colors.grey[200],
      );
    }
    switch (poop.rating.floor()) {
      case 0:
        return Icon(
          Icons.sentiment_very_dissatisfied,
          color: Colors.red,
        );
      case 1:
        return Icon(
          Icons.sentiment_dissatisfied,
          color: Colors.redAccent,
        );
      case 2:
        return Icon(
          Icons.sentiment_neutral,
          color: Colors.amber,
        );
      case 3:
        return Icon(
          Icons.sentiment_satisfied,
          color: Colors.lightGreen,
        );
      default:
        return Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.green,
        );
    }
  }
}