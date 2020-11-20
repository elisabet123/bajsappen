import 'package:bajsappen/visualize/poopratingicon.dart';
import 'package:flutter/material.dart';

class PoopRatingBar extends StatefulWidget {
  final Function(int) onRatingChanged;

  const PoopRatingBar({Key key, this.onRatingChanged}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PoopRatingBarState();
}

class PoopRatingBarState extends State<PoopRatingBar> {
  int selectedRating;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(5, (index) =>  _createRatingItem(index)
      ),
    );
  }

  Widget _createRatingItem(int index) {
    int rating = index + 1;
    return GestureDetector(
      child: PoopRatingIcon(
          rating,
          withColor: selectedRating == rating,
          padding: 0),
      onTap: () {
        widget.onRatingChanged(rating);
        setState(() {
          selectedRating = rating;
        });
      },
    );
  }
}
