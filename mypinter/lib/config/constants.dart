import 'package:latlong2/latlong.dart';

class AppConstants {
  // GIF
  static const String sadDogs = "https://media.tenor.com/sdwtJhSDETgAAAAM/sad-dog.gif";

  // API
  static const String apiUrl = "http://123.192.96.63:8000/api/posts/?format=json";

  // Map
  static const String mapUrlTemplate = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';
  static const String mapPackageName = 'com.mypinter.app';
  static const LatLng defaultMapCenter = LatLng(25.01372, 121.54086); // NTUST
  static const double defaultMapZoom = 13.0;
}
