import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypoint/UI/drone_command.dart/command.dart';
import 'package:waypoint/UI/home.dart';
import 'package:waypoint/UI/add_mission/addmission_map.dart';
import 'package:waypoint/UI/add_mission/save_mission.dart';
import 'package:waypoint/UI/trackdrone/track_drone.dart';
import 'package:waypoint/cubits/drone_command_cubit/drone_command_cubit.dart';
import 'package:waypoint/cubits/track_location_cubit/track_location_cubit.dart';
import 'cubits/file_export_cubit/file_export_cubit.dart';
import 'cubits/map_controller/map_controller_cubit.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapControllerCubit(),
        ),
        BlocProvider(
          create: (context) => FileExportCubit(),
        ),
        BlocProvider(create: (context) => TrackLocationCubit()),
        BlocProvider(create: (context) => DroneCommandCubit()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/addmission': (context) => AddMission(),
          '/savemission': (context) => SaveMission(),
          '/dronecommand': (context) => CommandDrone(),
          '/track': (context) => TrackDrone(),
        },
        theme: ThemeData(primaryColor: Colors.teal),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
