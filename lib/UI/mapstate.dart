import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waypoint/file_export_cubit/file_export_cubit.dart';
import 'package:waypoint/map_controller/map_controller_cubit.dart';
import 'package:waypoint/models/waypoint.dart';

class MapState extends StatefulWidget {
  const MapState({super.key});

  @override
  State<MapState> createState() => _MapStateState();
}

class _MapStateState extends State<MapState> {
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: height / 4,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            context.read<MapControllerCubit>().resetwayPoints();
                          },
                          child: Text("Reset WayPoints")),
                      ElevatedButton(
                          onPressed: () async {
                            List<WayPoint> wayPoints =
                                context.read<MapControllerCubit>().wayPoints;
                            if (!(wayPoints.length > 1)) {
                              context.showErrorBar(
                                  content: Text("Select atleast 2 way points"));
                              return;
                            }
                            try {
                              String path = await context
                                  .read<FileExportCubit>()
                                  .exportFile(wayPoints);
                              Share.shareXFiles([XFile(path)],
                                  text: "Exported JSON");
                            } catch (e) {
                              print(e.toString());
                              context.showErrorBar(
                                  content:
                                      Text("Error Exporting :" + e.toString()));
                            }
                          },
                          child: Text("Export JSON"))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: Text("Send to Server"))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
