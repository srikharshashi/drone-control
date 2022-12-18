import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypoint/UI/home.dart';
import 'package:waypoint/UI/mapstate.dart';
import 'package:waypoint/file_export_cubit/file_export_cubit.dart';
import 'package:waypoint/map_controller/map_controller_cubit.dart';

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
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/state': (context) => MapState(),
        },
        theme: ThemeData(primaryColor: Colors.teal),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
