//بسم الله الرحمن الرحيم
//@dart=2.9
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as GeoCoding;
import 'package:location/location.dart';

class LocationController with ChangeNotifier {
  double _latitude; // = 12.916983;
  double _longitude; //= 77.634873;
  String _locationName;
  bool _isBool = true;
  bool _isStatus = true;

  bool get bool1 => _isBool;


  bool get status => _isStatus;

  double get latitude => _latitude;

  double get longitude => _longitude;

  String get locationName => _locationName;

  set setBool(bool val) {
    _isBool = val;
    notifyListeners();
  }

  set setStatus(bool v) {
    _isStatus = v;
    notifyListeners();
  }

  set setStatusWithoutNotify(bool v) {
    _isStatus = v;
  }

  //Methods
  Future<void> getCurrentLatitudeAndLongitude() async {
    Location location = new Location();
    LocationData _locationData;
/*    bool _serviceEnabled;
    PermissionStatus _permissionGranted;


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      print("_serviceEnabled $_serviceEnabled");
      if (!_serviceEnabled) {
        //  if(mounted)
        notifyListeners();
        return;
      }
    }

     _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }*/

    //Get Location
    //  Position currentCoordinates = await Geolocator.getCurrentPosition();
    //  if (_longitude == null) {
    //  _latitude = currentCoordinates.latitude.toDouble();
    //  _longitude = currentCoordinates.longitude.toDouble();
    //   }
    _locationData = await location.getLocation();
    if ((_latitude == null) ||
        (_longitude == null) && ((_locationData != null))) {
      _latitude = _locationData.latitude;
      _longitude = _locationData.longitude;
    }

    print('Lat lng:  $_latitude $_longitude');
    notifyListeners();
  }

 /* Future<void> getLocationName(double lat, double lng) async {
    try {
      List<GeoCoding.Placemark> addresses =
          await GeoCoding.placemarkFromCoordinates(lat, lng);

      if (addresses != null && addresses.length > 0)
        _locationName = addresses.first.administrativeArea;
      print('Address: ' + _locationName);
    } catch (ex) {
      print("get current address error $ex");
    }
  }*/
  Future<void> getLocationName(
      double lat, double lng) async {
    var addresses;
    var responseBody;
    print('positionCoordinataes$lat$lng');
    try {
      final response = await http.get(
        Uri.parse(
            "https://us1.locationiq.com/v1/reverse.php?key=pk.78f5d2220ef901d6141426cd38bfe0bc&lat=$lat&lon=$lng&format=json"),
      );
      responseBody = json.decode(response.body);
      print(responseBody.toString());
      // return true;
    } catch (e) {
      print("Error"+e.toString() );
    }

    _locationName =  ((responseBody['address']["county"]??responseBody['address']["city"]?? "")+ " "+
        responseBody['address']["country"]??"") ??"";
    print('positionCoohhhrdinates$_locationName');
  }
}
