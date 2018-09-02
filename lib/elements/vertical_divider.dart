import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({Key key, this.height = 16.0, this.indent = 0.0, this.color})
      : assert(height >= 0.0),
        super(key: key);

  final double height;
  final double indent;

  final Color color;

  static BorderSide createBorderSide(BuildContext context,
      {Color color, double width = 0.0}) {
    assert(width != null);
    
    return new BorderSide(
      color: color ?? Theme.of(context).dividerColor,
      width: width,
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: height,
      child: new Center(
        child: new Container(
          // height: 0.0,
          width: 0.0,
          margin: new EdgeInsetsDirectional.only(start: indent),
          decoration: new BoxDecoration(
            border: new Border(
              // bottom: createBorderSide(context, color: color),
              left: createBorderSide(context, color: color),
              
            ),
          ),
        ),
      ),
    );
  }
}
