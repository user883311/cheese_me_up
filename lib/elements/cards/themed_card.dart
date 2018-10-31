import 'package:flutter/material.dart';

/// Customized [Card] widget for this app. 
/// Shows flat cards ([elevation] = 0.0) with slight border radius. 
class ThemedCard extends Card {
  final Key key;
  final Color color;
  final double elevation = 0.0;
  final EdgeInsetsGeometry margin;
  final Clip clipBehavior;
  final Widget child;
  final bool semanticContainer;

  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(9.0)),
  );

  ThemedCard({
    this.key,
    this.color,
    elevation,
    shape,
    this.margin = const EdgeInsets.all(4.0),
    this.clipBehavior = Clip.none,
    this.child,
    this.semanticContainer = true,
  }) : super(key: key);
}
