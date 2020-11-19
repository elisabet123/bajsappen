import 'package:flutter/material.dart';


class PoopRatingIcon extends StatelessWidget {
  final int rating;
  final bool withColor;

  final double padding;

  PoopRatingIcon(this.rating, this.withColor, this.padding);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(this.padding),
        child: IconTheme(
          data: IconThemeData(size: 40),
          child: _poopIcon(),
        ));
  }

  Widget _poopIcon() {
    if (this.rating == null) {
      return Icon(
        Icons.sentiment_neutral,
        color: Colors.grey[200],
      );
    }
    switch (this.rating) {
      case 1:
        return Icon(
          Icons.sentiment_very_dissatisfied,
          color: this.withColor ? Colors.red : Colors.grey[200],
        );
      case 2:
        return Icon(
          Icons.sentiment_dissatisfied,
          color: this.withColor ? Colors.redAccent : Colors.grey[200],
        );
      case 3:
        return Icon(
          Icons.sentiment_neutral,
          color: this.withColor ? Colors.amber : Colors.grey[200],
        );
      case 4:
        return Icon(
          Icons.sentiment_satisfied,
          color: this.withColor ? Colors.lightGreen : Colors.grey[200],
        );
      default:
        return Icon(
          Icons.sentiment_very_satisfied,
          color: this.withColor ? Colors.green : Colors.grey[200],
        );
    }
  }
}
