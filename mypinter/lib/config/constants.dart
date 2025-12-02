import 'package:latlong2/latlong.dart';

class AppConstants {
  // API Base URL
  static const String apiBaseUrl = 'http://123.192.96.63:8000';
  
  // API Endpoints
  static const String apiUrl = '$apiBaseUrl/api/posts/?format=json';
  static const String apiLoginUrl = '$apiBaseUrl/api/auth/login/';
  static const String apiRegisterUrl = '$apiBaseUrl/api/auth/register/';
  static const String apiUserUrl = '$apiBaseUrl/api/auth/user/';
  static const String apiPostCreateUrl = '$apiBaseUrl/api/posts/create/';
  
  // Map Configuration
  static const String mapUrlTemplate = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';
  static const String mapPackageName = 'com.mypinter.app';
  static const LatLng defaultMapCenter = LatLng(25.01372, 121.54086); // NTUST
  static const double defaultMapZoom = 13.0;
  static const double defaultLatitude = 25.0330;
  static const double defaultLongitude = 121.5654;
  static const double defaultZoom = 13.0;
  
  // External URLs
  static const String sadDogs = "https://media.tenor.com/wpSo-8CrXqUAAAAi/pikachu-sad.gif";
}
