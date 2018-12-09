import 'package:flutter/material.dart';

class ThemedBottomSheet {
  @required
  List<Widget> listWidgets;

  ThemedBottomSheet({this.listWidgets});

  // Widget cheesesExpansionPanelList = ExpansionPanelList(
  //   children: listWidgets.map((widgetItems){}).toList(),
  // );

  void mainBottomSheet(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: listWidgets,
                ),
          );
        });
  }

  ListTile _createTile(
      BuildContext context, String name, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  _action1() {
    print('action 1');
  }

  _action2() {
    print('action 2');
  }

  _action3() {
    print('action 3');
  }
}
