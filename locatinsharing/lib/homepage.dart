import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:locatinsharing/Navigation/screens/prepare_ride.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as per;

import 'homepage.dart';
import 'Navigation/screens/navigation.dart';
import 'SOS/SOS.dart';
import 'ShareLoc/ShareLoc.dart';
import 'NearbyMe/NearbyMe.dart';
import 'FriendFamily/Contacts.dart';
import 'Splash/splash_screen.dart';
import 'Signin_Signup/signin.dart';
import 'Signin_Signup/signup.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   initializeLocationAndSave();
  // }
  //
  // void initializeLocationAndSave() async {
  //   // Ensure all permissions are collected for Locations
  //   Location _location = Location();
  //   bool? _serviceEnabled;
  //   PermissionStatus? _permissionGranted;
  //
  //   _serviceEnabled = await _location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await _location.requestService();
  //   }
  //
  //   _permissionGranted = await _location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await _location.requestPermission();
  //   }
  //
  //   // Get capture the current user location
  //   LocationData _locationData = await _location.getLocation();
  //   latLng.LatLng currentLatLng =
  //   latLng.LatLng(_locationData.latitude!, _locationData.longitude!);
  //
  //   // Store the user location in sharedPreferences
  //   sharedPreferences.setDouble('latitude', _locationData.latitude!);
  //   sharedPreferences.setDouble('longitude', _locationData.longitude!);
  //
  //   // Get and store the directions API response in sharedPreferences
  //   // for (int i = 0; i < restaurants.length; i++) {
  //   //   Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
  //   //   saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
  //   // }
  //
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => MyHomePage()),
  //           (route) => false);
  // }


  int selectedPage = 0;

  final _pageOptions = [
    MyHomePage(),
    SOS(),
    Navigation(),
    ShareLocation(),
    Contacts(),
    NearMe()
  ];

  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pageOptions[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(

            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),

            title: Text("LocSS"),

            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications_none, size: 30,),
                onPressed: () {},
              ),
            ],

            //backgroundColor: Colors.cyan,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent.shade100, Colors.greenAccent.shade200],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Colors.teal[900],
            onTap: _onItemTapped,

            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30,),
                label: 'Home',
                backgroundColor: Colors.greenAccent.shade200,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.emergency_share, size: 30,),
                label: 'SOS Share',
                backgroundColor: Colors.blueAccent.shade100,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.navigation, size: 30,),
                label: 'Navigation',
                backgroundColor: Colors.greenAccent.shade200,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.share_location_sharp, size: 30,),
                label: 'ShareLocation',
                backgroundColor: Colors.blueAccent.shade100,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.person_4, size: 30,),
                label: 'Contacts',
                backgroundColor: Colors.greenAccent.shade200,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.near_me_rounded, size: 30,),
                label: 'Near Me',
                backgroundColor: Colors.blueAccent.shade100,
              ),
            ],

            elevation: 50,
            selectedFontSize: 15,
          ),

          body: FlutterMap(
            options: MapOptions(
              center: latLng.LatLng(23.2156, 72.6369),
              zoom: 11,
            ),
            // nonRotatedChildren: [
            //   AttributionWidget.defaultWidget(
            //     source: 'OpenStreetMap contributors',
            //     onSourceTapped: null,
            //   ),
            // ],

            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/ronitjain04/clfxzfjit000301qflgwwr3ip/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoicm9uaXRqYWluMDQiLCJhIjoiY2xmeHdsdGt1MHY5ajNpczZwZ2gzZ2U3YiJ9.4YWhnln8WAvbrzSEKYf_Jg',
                additionalOptions: {
                  'accessToken': 'pk.eyJ1Ijoicm9uaXRqYWluMDQiLCJhIjoiY2xmeHdsdGt1MHY5ajNpczZwZ2gzZ2U3YiJ9.4YWhnln8WAvbrzSEKYf_Jg',
                  'id': 'mapbox.mapbox-streets-v8'
                },
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical:100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                child: TextField(
                  decoration: InputDecoration(

                    contentPadding: EdgeInsets.all(16.0),
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

