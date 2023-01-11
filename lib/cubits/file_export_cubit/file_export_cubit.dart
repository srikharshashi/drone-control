import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/waypoint.dart';

part 'file_export_state.dart';

class FileExportCubit extends Cubit<FileExportState> {
  FileExportCubit() : super(FileExportInitial());

  Future<String> exportFile(List<WayPoint> waypoints) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/sample.json');
    List<Map<String, dynamic>> r = [];
    waypoints.forEach((element) {
      r.add(element.toJSON(element));
    });
    await file.writeAsString(json.encode(r));
    return file.path;
  }
}
