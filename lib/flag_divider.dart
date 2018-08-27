import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlagDivider extends StatelessWidget {
  // TODO: create a Swiss FLag divider (2 or 3 flag colors)
  final Color color1;
  final Color color2;
  final Color color3;
  final double height;
  final double indent;

  const FlagDivider(
      {Key key,
      this.height: 16.0,
      this.indent: 0.0,
      this.color1,
      this.color2,
      this.color3})
      : assert(height >= 0.0),
        super(key: key);

  Widget build(BuildContext context) {
    return new Row(children: [
      Divider(color: color1),
      Divider(color: color2),
      Divider(color: color3),
    ]);
  }
}
