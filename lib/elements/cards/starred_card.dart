import 'package:cheese_me_up/elements/cards/themed_card.dart';
import 'package:cheese_me_up/elements/time.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/rating.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StarredCard extends StatefulWidget {
  final Cheese cheese;
  final User user;
  final onTapped;
  final Widget circleAvatar;

  StarredCard({
    @required this.cheese,
    this.user,
    this.circleAvatar,
    this.onTapped,
  }) : assert(cheese != null);

  @override
  StarredCardState createState() => new StarredCardState(
      cheese: cheese,
      user: user,
      onTapped: onTapped,
      circleAvatar: circleAvatar);
}

class StarredCardState extends State<StarredCard> {
  final Cheese cheese;
  final User user;
  final onTapped;
  final Widget circleAvatar;

  StarredCardState({
    @required this.cheese,
    this.user,
    this.onTapped,
    this.circleAvatar,
  });

  @override
  void initState() {
    super.initState();
  }

  _deleteRating(String userId, String cheeseId) {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference _userRef =
        database.reference().child("users/$userId/ratings/r$cheeseId");
    _userRef.remove();
  }

  Widget build(BuildContext context) {
    Rating rating = user.ratings[cheese.id];

    return GestureDetector(
      onTap: () async {
        if (onTapped != null) {
          onTapped();
        }
      },
      child: ThemedCard(
        child: ListTile(
          trailing: Container(
            width: 110.0,
            height: 70.0,
            child: FittedBox(
              child: Stack(children: [
                Positioned(
                  child: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/cheese-me-up.appspot.com/o/cheese_images%2Fabbaye-de-belloc.jpg?alt=media&token=dfee9be5-5bdb-4ce5-8bf9-ec019174606d",
                    fit: BoxFit.cover,
                  ),
                ),
                // Positioned.fill(child: Icon(Icons.delete_forever)),
              ]),
            ),
          ),
          leading: circleAvatar,
          isThreeLine: true,
          title: Text(
            cheese.name,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            cheese.region +
                ", " +
                cheese.country +
                "\n" +
                "${relevantTimeSince(rating.time)["durationInt"]} ${relevantTimeSince(rating.time)["unit"]} ago",
          ),
        ),
      ),
    );
  }
}

// class StarredCard extends StatelessWidget {
//   final Rating rating;
//   final Cheese cheese;

//   StarredCard({
//     this.rating,
//     @required this.cheese,
//   });

//   _deleteRating(String userId, String cheeseId) {
//     final FirebaseDatabase database = FirebaseDatabase.instance;
//     DatabaseReference _userRef =
//         database.reference().child("users/$userId/ratings/r$cheeseId");
//     _userRef.remove();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var container = AppStateContainer.of(context);
//     AppState appState = container.state;

//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(5.0),
//         child: Row(
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 Text(
//                   "${relevantTimeSince(rating.time)["durationInt"]} ${relevantTimeSince(rating.time)["unit"]} ago",
//                   textScaleFactor: 1.2,
//                 ),
//                 RawMaterialButton(
//                   child: Text(
//                     "\n${cheese.name}",
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   onPressed: () => Navigator.pushNamed(
//                       context, "/cheese_route/${cheese.id}"),
//                 ),
//                 Row(children: [
//                   Text("${rating.rating.toInt()}"),
//                   Icon(
//                     Icons.star,
//                     color: Colors.brown,
//                     size: 10.0,
//                   ),
//                 ]),
//               ],
//             ),
//             Stack(
//               children: <Widget>[
//                 Positioned(
//                   child: Image.network(
//                     "https://firebasestorage.googleapis.com/v0/b/cheese-me-up.appspot.com/o/cheese_images%2Fabbaye-de-belloc.jpg?alt=media&token=dfee9be5-5bdb-4ce5-8bf9-ec019174606d",
//                   ),
//                 ),
//                 Builder(
//                   builder: (context) => Positioned(
//                         child: GestureDetector(
//                           onTap: () async {
//                             switch (await showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return new SimpleDialog(
//                                     title: Text(
//                                         'Do you want to delete this rating?'),
//                                     children: <Widget>[
//                                       new SimpleDialogOption(
//                                           onPressed: () =>
//                                               Navigator.pop(context, true),
//                                           child: const Text('Yes')),
//                                       new SimpleDialogOption(
//                                           onPressed: () =>
//                                               Navigator.pop(context, false),
//                                           child: const Text('No')),
//                                     ],
//                                   );
//                                 })) {
//                               case true:
//                                 _deleteRating(
//                                     appState.user.id, rating.cheeseId);
//                                 Scaffold.of(context).showSnackBar(
//                                     SnackBar(content: Text('Deleted rating.')));
//                                 break;

//                               case false:
//                                 break;

//                               default:
//                                 break;
//                             }
//                           },
//                           child: Icon(
//                             Icons.delete_outline,
//                             color: Colors.deepOrange[200],
//                           ),
//                         ),
//                       ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
