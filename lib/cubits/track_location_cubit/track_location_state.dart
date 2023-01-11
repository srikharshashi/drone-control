part of 'track_location_cubit.dart';

@immutable
abstract class TrackLocationState {
  double lat;
  double long;
  TrackLocationState({required this.lat, required this.long});
}

class TrackLocationInitial extends TrackLocationState {
  double lat;
  double long;
  TrackLocationInitial({required this.lat, required this.long})
      : super(lat: lat, long: long);
}
