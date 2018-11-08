import 'package:flutter/material.dart';

class ThemedSnackBar extends SnackBar {
  final Key key;
  @required
  final Widget content;
  final Color backgroundColor = Colors.red[100];
  final SnackBarAction action;
  final Duration duration;
  final Animation<double> animation;

  ThemedSnackBar({
    this.key,
    @required this.content,
    backgroundColor,
    this.action,
    this.duration = const Duration(milliseconds: 2000),
    this.animation,
  })  : assert(content != null),
        assert(duration != null),
        super(key: key, content: content);
}

void showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(ThemedSnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.red[100],
    ));
  }