

import 'package:map_launcher/map_launcher.dart';
//import 'package:maps_launcher/maps_launcher.dart';
import 'package:tickets_app/Helper/Singelton.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {


    if (await MapLauncher.isMapAvailable(MapType.apple)) {

      await MapLauncher.showDirections(
        mapType: MapType.apple,
        destination: Coords(latitude, longitude),
        origin: Coords( Global.currentLocation.latitude,  Global.currentLocation.longitude),
      );
    }

//    MapsLauncher.launchCoordinates(
//        latitude, longitude, '');

//    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//    if (await canLaunch(googleUrl)) {
//      await launch(googleUrl).catchError((e){
//        print(e);
//      });
//    } else {
//      throw 'Could not open the map.';
//    }
  }
}