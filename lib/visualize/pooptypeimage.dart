import 'package:flutter/cupertino.dart';

import '../poop.dart';

class PoopTypeImage extends StatelessWidget {
  final Poop poop;
  final double size;
  final bool border;

  const PoopTypeImage(this.poop, {Key key, this.size = 50, this.border = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        image: poop.hardness != null
            ? AssetImage('assets/images/type-' +
                poop.hardness.floor().toString() +
                '.png')
            : AssetImage('assets/images/empty.png'),
        height: this.size,
      ),
      decoration: border
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 0))
          : null,
    );
  }
}
