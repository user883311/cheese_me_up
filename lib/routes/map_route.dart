import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/themed_bottom_sheet.dart';
import 'package:cheese_me_up/elements/themed_snackbar.dart';
import 'package:cheese_me_up/internal/keys.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapRoute extends StatefulWidget {
  MapRoute();

  @override
  MapRouteState createState() => new MapRouteState();
}

class MapRouteState extends State<MapRoute> {
  // set default position to Berne, Switzerland
  LatLng _myLatLng = LatLng(46.95, 7.45);
  static double _defaultZoom = 7.0;
  double _currentZoom = _defaultZoom;
  List<Marker> markers = [];
  MapController mapController = new MapController();

  @override
  void initState() {
    super.initState();

    _getMyLocation().then((_myPosition) {
      setState(() {
        _myLatLng = LatLng(_myPosition.latitude, _myPosition.longitude);
      });
    }).catchError((error) {
      print("Error in getting my position: \n$error.");
      showSnackBar(
          context,
          error.toString() +
              " We've set your position to Berne, Switzerland, by default :)");
    });
  }

  Future<Position> _getMyLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);

    switch (permission) {
      case PermissionStatus.denied:
        print("Getting your location was denied");
        throw ("Getting your location was denied. Please review the app permissions settings in your parameters.");
        break;

      case PermissionStatus.disabled:
        print("Getting your location was/is disabled");
        throw ("Getting your location was/is disabled.");
        break;

      case PermissionStatus.unknown:
        print("Getting your location is unknown");
        throw ("Getting your location is unknown.");
        break;

      case PermissionStatus.granted:
        print("Getting your location was granted!");
        Position position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
        return position;
        break;

      default:
        throw ("Permission was neither denied, disabled, unknown or granted.");
    }
  }

  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    AppState appState = container.state;

    // add marker for my position
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: _myLatLng,
        builder: (context) => new Container(
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.person_pin_circle,
                  color: Colors.red,
                ),
              ),
            ),
      ),
    );

    // create markers for all the producers
    appState.producers.values.forEach((producer) {
      bool theProducerHasCoordinates =
          producer.latitude != null && producer.longitude != null;
      if (theProducerHasCoordinates) {
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: new LatLng(producer.latitude, producer.longitude),
            builder: (context) => new Container(
                  child: GestureDetector(
                    onTap: () async {
                      // Center the map on this producer coordinates
                      mapController.move(
                          LatLng(producer.latitude, producer.longitude),
                          _currentZoom);

                      // get the producer's cheeses
                      var db = appState.sqlDatabase;
                      List<Map> producedBy =
                          await db.rawQuery('SELECT * FROM producedBy');
                      // create two Maps for retrieving cheeses and producers alike
                      List<Cheese> cheeses = [];
                      String cheesesString;
                      for (Map mapItem in producedBy) {
                        String producerID = mapItem["producerID"].toString();
                        String cheeseID = mapItem["cheeseID"].toString();
                        if (producerID == producer.id) {
                          Cheese cheese = appState.cheeses[cheeseID];
                          cheeses.add(cheese);
                          cheesesString = (cheesesString == null)
                              ? ""
                              : cheesesString + ", ";
                          cheesesString = cheesesString + cheese.name;
                        }
                      }

                      // show BottomSheet with Producer's info
                      ThemedBottomSheet themedBottomSheet =
                          new ThemedBottomSheet(
                        listWidgets: <Widget>[
                          ListTile(
                            leading: Icon(Icons.home),
                            title: Text(producer.name),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.map),
                            title: Text("Cheeses: $cheesesString"),
                            onTap: () {},
                          ),
                        ],
                      );
                      // open the BottomSheet
                      themedBottomSheet.mainBottomSheet(context);
                    },
                    child: Icon(
                      Icons.pin_drop,
                      color: Colors.brown,
                    ),
                  ),
                ),
          ),
        );
      }
    });

    return Scaffold(
      body: FlutterMap(
        options: new MapOptions(
          center: _myLatLng,
          zoom: 7.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://api.tiles.mapbox.com/v4/"
                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken': mapBoxKey,
              'id': 'mapbox.streets',
            },
          ),
          new MarkerLayerOptions(
            markers: markers,
          ),
        ],
        mapController: mapController,
      ),
    );
  }
}
