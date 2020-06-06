import 'package:flutter/cupertino.dart';

import '../poop.dart';

class PoopTypeImage extends StatelessWidget {
  final Poop poop;

  const PoopTypeImage(this.poop, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        image: poop.hardness != null
            ? AssetImage('assets/images/type-' +
            poop.hardness.floor().toString() +
            '.png')
            : AssetImage('assets/images/empty.png'),
        height: 50,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 0)),
    );
  }
}