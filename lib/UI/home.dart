import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flash/flash.dart';
import '../env/env.dart';
import '../map_controller/map_controller_cubit.dart';
import 'package:google_api_headers/google_api_headers.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final Mode _mode = Mode.overlay;
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _HomeState extends State<Home> {
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  Set<Marker> marker = {};
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(17.395474086964512, 78.62202694033529);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton: AnimatedFloatingActionButton(
            fabButtons: [
              Container(
                child: FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () async {
                    await handlePressButton();
                  },
                  heroTag: "btn0",
                  tooltip: 'Search',
                  child: Icon(FontAwesomeIcons.searchengin),
                ),
              ),
              Container(
                child: FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    context.read<MapControllerCubit>().resetwayPoints();
                  },
                  heroTag: "btn1",
                  tooltip: 'Reset',
                  child: Icon(FontAwesomeIcons.refresh),
                ),
              ),
              Container(
                child: FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () async {
                    bool isEnabled =
                        await Geolocator.isLocationServiceEnabled();

                    if (!isEnabled) {
                      context.showErrorBar(
                          content: Text("Location Not Enabled"));
                      return;
                    }
                    var servicePermission = await Geolocator.checkPermission();

                    if (servicePermission == LocationPermission.denied ||
                        servicePermission == LocationPermission.deniedForever) {
                      await Geolocator.requestPermission();
                    }

                    if (servicePermission == LocationPermission.denied ||
                        servicePermission == LocationPermission.deniedForever) {
                      context.showErrorBar(
                          content: Text("Location Permission Denied"));
                    }

                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.best);
                    mapController.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
                            zoom: 19)));
                  },
                  heroTag: "btn2",
                  tooltip: 'Current Location',
                  child: Icon(Icons.location_searching),
                ),
              ),
              Container(
                child: FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    Navigator.pushNamed(context, '/state');
                  },
                  heroTag: "btn3",
                  tooltip: 'Options',
                  child: Icon(FontAwesomeIcons.save),
                ),
              ),
            ],
            key: key,
            colorStartAnimation: Colors.teal,
            colorEndAnimation: Colors.red,
            animatedIconData: AnimatedIcons.menu_close),
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Mission Planner"),
        ),
        body: BlocConsumer<MapControllerCubit, MapControllerState>(
          listener: (context, state) {},
          builder: (context, state) {
            return GoogleMap(
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                mapType: MapType.satellite,
                markers: state.markers,
                onLongPress: (LatLng arg) {
                  print(
                      arg.latitude.toString() + " " + arg.longitude.toString());
                  context.read<MapControllerCubit>().addmarker(arg);
                },
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 19));
          },
        ));
  }

  Future<void> handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: API_KEY,
        onError: (PlacesAutocompleteResponse response) {
          context.showErrorBar(content: Text(response.errorMessage!));
        },
        mode: _mode,
        language: "en",
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: "Search",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "in")]);

    if (p != null) displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: API_KEY,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    // markersList.clear();
    // markersList.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result.name)));

    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 19.0)));
  }
}
