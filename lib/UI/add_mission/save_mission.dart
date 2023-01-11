import 'dart:async';
import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waypoint/env/env.dart';
import 'package:waypoint/models/waypoint.dart';
import 'package:http/http.dart' as http;
import '../../cubits/file_export_cubit/file_export_cubit.dart';
import '../../cubits/map_controller/map_controller_cubit.dart';

class SaveMission extends StatefulWidget {
  const SaveMission({super.key});

  @override
  State<SaveMission> createState() => _SaveMissionState();
}

class _SaveMissionState extends State<SaveMission> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Mission Planner"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocConsumer<MapControllerCubit, MapControllerState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (context.read<MapControllerCubit>().wayPoints.length >= 3)
                return WayPointsValid(
                    formKey: _formKey,
                    nameController: nameController,
                    descriptionController: descriptionController);
              else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      "Select atleast three way points",
                      style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                  ),
                );
              }
            },
          ),),
    );
  }
}

class WayPointsValid extends StatelessWidget {
  const WayPointsValid({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.nameController,
    required this.descriptionController,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Add Mission",
                  style: GoogleFonts.montserrat(
                      fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Mission Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flight)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  maxLines: 2,
                  decoration: InputDecoration(
                      labelText: "Mission Description",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(FontAwesomeIcons.noteSticky)),
                ),
              ),
              Flexible(
                child: ListView.builder(
                    itemCount:
                        context.read<MapControllerCubit>().controllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: TextFormField(
                            controller: context
                                .read<MapControllerCubit>()
                                .controllers[index],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                filled: true,
                                labelText: "Way Point ${index + 1}",
                                fillColor: Colors.teal.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.pin_drop)),
                          ),
                        ),
                      );
                    }),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var completer = Completer();
                      context.showBlockDialog(dismissCompleter: completer);
                      var waypoints = makeBody1(
                          context.read<MapControllerCubit>().wayPoints,
                          context.read<MapControllerCubit>().controllers);

                      var body = makeBody2(nameController.text,
                          descriptionController.text, waypoints);

                      bool response = await makerequest(body);
                      completer.complete();
                      if (response) {
                        context.showSuccessBar(
                            content: Text("Request was made sucessfully"));
                      } else {
                        context.showErrorBar(
                            content: Text("Request was not sent due to error"));
                      }
                    } else {
                      context.showErrorBar(
                          content: Text("One or more fields in null"));
                      //   var completer = Completer();
                      // context.showBlockDialog(
                      //     dismissCompleter: completer);
                    }
                  },
                  child: Text("Submit"))
            ],
          ),
        ));
  }
}

void exportJson(BuildContext context) async {
  List<WayPoint> wayPoints = context.read<MapControllerCubit>().wayPoints;
  if (!(wayPoints.length > 1)) {
    context.showErrorBar(content: Text("Select atleast 2 way points"));
    return;
  }
  try {
    String path = await context.read<FileExportCubit>().exportFile(wayPoints);
    Share.shareXFiles([XFile(path)], text: "Exported JSON");
  } catch (e) {
    print(e.toString());
    context.showErrorBar(content: Text("Error Exporting :" + e.toString()));
  }
}

List<Map<String, dynamic>> makeBody1(
    List<WayPoint> waypoints, List<TextEditingController> names) {
  List<Map<String, dynamic>> body = [];

  for (int i = 0; i < waypoints.length; i++) {
    var entry = {
      "lat": waypoints[i].latitude,
      "long": waypoints[i].longitude,
      "index": i,
      "name": names[i].text
    };
    body.add(entry);
  }
  return body;
}

Map<String, String> makeBody2(String missionName, String description,
    List<Map<String, dynamic>> waypoints) {
  return {
    "name": missionName,
    "description": description,
    "waypoints": jsonEncode(waypoints),
  };
}

Future<bool> makerequest(Map<String, String> body) async {
  var responseJson;
  try {
    final response = await http.post(Uri.parse(SERVER_URL + "/mission/create"),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    return true;
  } catch (e) {
    return false;
  }
}
