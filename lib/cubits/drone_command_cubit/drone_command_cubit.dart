import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

part 'drone_command_state.dart';

class DroneCommandCubit extends Cubit<DroneCommandState> {
  DroneCommandCubit() : super(DroneCommandInitial());

  final SERVER_URL = Uri.parse("http://18.234.187.114:4000/mission/query/all");
  List<dynamic> responseJson = [];
  Map<String, int> map = {};
  Map<String, String> map2 = {};

  var WSS_URL = "ws://18.234.187.114:4000/socket/command?device=phone";

  void fetchMissions() async {
    emit(FetchMissionLoad());
    map.clear();
    try {
      print("aa");
      var response = await http.get(
        SERVER_URL,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        responseJson = jsonDecode(response.body);
        List<String> missions = [];
        int c = 0;
        responseJson.forEach((element) {
          missions.add(element["name"]);
          map[element["name"]] = c;
          map2[element["name"]] = element["_id"];
          c++;
        });
        emit(MissionSelect(missions: missions));
      } else {
        emit(FetchMissionError());
      }
    } catch (e) {
      print(e.toString());
      emit(FetchMissionError());
    }
  }

  void reset() {
    fetchMissions();
  }

  void startMission(String name) {
    print(name);

    int index = map[name]!;
    final mission = responseJson[index]["waypoints"];
    bool flag = true;
    print(mission);
    emit(DroneCommandLoad());
    var channel = IOWebSocketChannel.connect(Uri.parse(WSS_URL));
    channel.stream.listen((message) {
      channel.sink.add(jsonEncode({"message": "can_launch"}));
      Map<String, dynamic> data = jsonDecode(message);
      print(message);
      if (data.containsKey("reply")) {
        print("reply is " + data.toString());
        if (data["reply"] == true && flag) {
          flag = false;
          channel.sink.add(jsonEncode(
              {"message": "LAUNCH", "waypoints": mission, "id": map2[name]}));
          emit(DroneCommandSucess());
        }
      }
    });
  }
}
