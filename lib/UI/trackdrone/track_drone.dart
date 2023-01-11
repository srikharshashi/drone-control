import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waypoint/cubits/track_location_cubit/track_location_cubit.dart';

class TrackDrone extends StatefulWidget {
  const TrackDrone({super.key});

  @override
  State<TrackDrone> createState() => _TrackDroneState();
}

class _TrackDroneState extends State<TrackDrone> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    context.read<TrackLocationCubit>().start();
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    print("hehe");
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/marker.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Tracking"),
      ),
      body: BlocBuilder<TrackLocationCubit, TrackLocationState>(
        builder: (context, state) {
          return Container(
            child: GoogleMap(
                mapType: MapType.satellite,
                zoomControlsEnabled: true,
                markers: {
                  Marker(
                      icon: markerIcon,
                      markerId: const MarkerId("pos"),
                      position: LatLng(state.lat, state.long))
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(state.lat, state.long), zoom: 19)),
          );
        },
      ),
    );
  }
}
