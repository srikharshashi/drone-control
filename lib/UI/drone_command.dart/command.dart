import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waypoint/cubits/drone_command_cubit/drone_command_cubit.dart';

class CommandDrone extends StatefulWidget {
  const CommandDrone({super.key});

  @override
  State<CommandDrone> createState() => _CommandDroneState();
}

class _CommandDroneState extends State<CommandDrone> {
  @override
  void initState() {
    context.read<DroneCommandCubit>().fetchMissions();
    super.initState();
  }

  String _selectedLocation = "";

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Drone Command"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocConsumer<DroneCommandCubit, DroneCommandState>(
          listener: (context, state) {
            // if (state is DroneCommandSucess || state is DroneCommandError) {
            //   context.read<DroneCommandCubit>().closeC();
            // }
          },
          builder: (context, state) {
            if (state is DroneCommandInitial) {
              return Container(
                height: height / 2,
                width: width / 2,
                child: Text("Drone Command Initial"),
              );
            } else if (state is DroneCommandLoad) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sending Command to drone"),
                    Container(
                        child: SpinKitFadingCircle(
                      color: Colors.teal,
                      size: 50.0,
                    )),
                    ElevatedButton(
                        onPressed: () {
                          context.read<DroneCommandCubit>().reset();
                        },
                        child: Text("Reset"))
                  ],
                ),
              );
            } else if (state is FetchMissionLoad) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Fetching missions from server"),
                    Container(
                        child: SpinKitFadingCircle(
                      color: Colors.teal,
                      size: 50.0,
                    )),
                  ],
                ),
              );
            } else if (state is FetchMissionError) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error Fetching missions from server"),
                    ElevatedButton(onPressed: () {}, child: Text("Retry"))
                  ],
                ),
              );
            } else if (state is MissionSelect) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select a mission",
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    DropdownButton(
                      value: state.missions[0],
                      hint: Text(
                          'Please choose a location'), // Not necessary for Option 1
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLocation = newValue.toString();
                        });
                      },
                      items: state.missions.map((e) {
                        return DropdownMenuItem(child: Text(e), value: e);
                      }).toList(),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          print(_selectedLocation);
                          context
                              .read<DroneCommandCubit>()
                              .startMission(_selectedLocation);
                        },
                        child: Text("Start Mission"))
                  ],
                ),
              );
            } else if (state is DroneCommandSucess) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Drone LAUNCH sent sucessfully"),
                    ElevatedButton(
                        onPressed: () {
                          context.read<DroneCommandCubit>().reset();
                        },
                        child: Text("Reset"))
                  ],
                ),
              );
            } else if (state is DroneCommandError) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Drone LAUNCH Error"),
                    ElevatedButton(
                        onPressed: () {
                          context.read<DroneCommandCubit>().reset();
                        },
                        child: Text("Reset"))
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error"),
                    ElevatedButton(
                        onPressed: () {
                          context.read<DroneCommandCubit>().reset();
                        },
                        child: Text("Reset"))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
