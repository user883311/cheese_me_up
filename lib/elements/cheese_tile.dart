import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';

import 'package:flutter/material.dart';

/// Creates a tile representing a given [Cheese] object. Upon tapping
/// on the tile, a callback function [onTapped] is called, for a given [user].
Widget cheeseTile(Cheese cheese, [User user, onTapped, bool circleAvatar = true]) {
  return Card(
    child: ListTile(
      trailing: new Container(
        width: 100.0,
        height: 50.0,
        child: new Image.asset(
          "assets/media/img/cheese/" + cheese.image,
          fit: BoxFit.cover,
        ),
      ),
      leading: circleAvatar
          ? CircleAvatar(
              backgroundColor: Colors.orange[100],
              foregroundColor: Colors.black,
              child: new Text(cheese.name.substring(0, 2).toUpperCase()),
            )
          : null,
      title: new Text(cheese.name),
      subtitle: new Text(cheese.region + ", " + cheese.country),
      onTap: () async {
        print("Tapped dat ${cheese.name}!");
        if (onTapped != null) {
          onTapped(cheese, user);
        }
      },
    ),
  );
}
