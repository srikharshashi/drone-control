part of 'map_controller_cubit.dart';

@immutable
abstract class MapControllerState {
  Set<Marker> markers;
  MapControllerState({required this.markers});
}

class MapControllerInitial extends MapControllerState {
  Set<Marker> markers;
  MapControllerInitial({required this.markers}) : super(markers: markers);
}
