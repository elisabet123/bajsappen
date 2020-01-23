import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback onTap;

  const StatisticsCard({Key key, this.children, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: children
          ),
        ),
      ),
    );
  }

}