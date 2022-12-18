import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:waypoint/models/waypoint.dart';

part 'map_controller_state.dart';

class MapControllerCubit extends Cubit<MapControllerState> {
  int markerCount = 0;

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  final Set<Marker> markers = {};
  final List<WayPoint> wayPoints = [];
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  MapControllerCubit() : super(MapControllerInitial(markers: {}));

  void addmarker(LatLng pos) {
    wayPoints.add(WayPoint(
        latitude: pos.latitude, longitude: pos.longitude, order: markerCount));

    markers.add(Marker(markerId: MarkerId(getRandomString(5)), position: pos));
    markerCount++;
    emit(MapControllerInitial(markers: markers));
  }

  void resetwayPoints() {
    markers.clear();
    wayPoints.clear();
    markerCount = 0;
    emit(MapControllerInitial(markers: markers));
  }
}
