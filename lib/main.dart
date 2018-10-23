import 'package:cheese_me_up/app.dart';
import 'package:cheese_me_up/app_state_container.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(new AppStateContainer(
    child: new AppRootWidget(),
  ));
}
