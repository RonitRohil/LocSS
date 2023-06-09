import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../helper/shared_prefs.dart';
import '../ui/rate_ride.dart';

class TurnByTurn extends StatefulWidget {
  const TurnByTurn({Key? key}) : super(key: key);

  @override
  State<TurnByTurn> createState() => _TurnByTurnState();
}

class _TurnByTurnState extends State<TurnByTurn> {
  // // Waypoints to mark trip start and end
  LatLng source = LatLng(23.1871641, 72.6271351);
  LatLng destination = LatLng(21.771884, 72.14164499999998);
  // // LatLng source = getTripLatLngFromSharedPrefs('source');
  // // LatLng destination = getTripLatLngFromSharedPrefs('destination');
  late WayPoint sourceWaypoint, destinationWaypoint;
  final waypoints = <WayPoint>[];

  // Config variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  late double distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;

  final bool isMultipleStop = false;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (!mounted) return;

    // Setup directions and options
    // directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    //
    // // MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
    // // MapBoxNavigation.instance.setDefaultOptions(MapBoxOptions(
    // //   initialLatitude: source.latitude,
    // //   initialLongitude: source.longitude,
    // //   zoom: 18,
    // //   tilt: 0.0,
    // //   bearing: 0.0,
    // //   enableRefresh: false,
    // //   alternatives: true,
    // //   voiceInstructionsEnabled: true,
    // //   bannerInstructionsEnabled: true,
    // //   allowsUTurnAtWayPoints: true,
    // //   mode: MapBoxNavigationMode.drivingWithTraffic,
    // //   units: VoiceUnits.imperial,
    // //   simulateRoute: true,
    // //   language: "en",
    // // ));
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        isOptimized: true,
        units: VoiceUnits.metric,
        simulateRoute: true,
        language: "en",
    );

    // // Configure waypoints
    sourceWaypoint = WayPoint(
        name: "Source", latitude: source.latitude, longitude: source.longitude);
    destinationWaypoint = WayPoint(
        name: "Destination",
        latitude: destination.latitude,
        longitude: destination.longitude);
    waypoints.add(sourceWaypoint);
    waypoints.add(destinationWaypoint);

    // // Start the trip
    await directions.startNavigation(wayPoints: waypoints, options: _options);
    // await MapBoxNavigation.instance.startNavigation(wayPoints: wayPoints);
  }

  @override
  Widget build(BuildContext context) {
    return const RateRide();
  }

  Future<void> _onRouteEvent(e) async {
    // distanceRemaining = (await directions.getDistanceRemaining())!;
    // durationRemaining = (await directions.getDurationRemaining())!;

    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;


    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }

  // @override
  // dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
