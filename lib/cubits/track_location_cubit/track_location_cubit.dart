import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'track_location_state.dart';

class TrackLocationCubit extends Cubit<TrackLocationState> {
  TrackLocationCubit()
      : super(TrackLocationInitial(lat: 17.397058, long: 78.490332));

  void start() {
    print("abcd");
    final channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://18.234.187.114:4000/socket/command?device=tracker'),
    );
    var stream = channel.stream;

    stream.listen((event) {
      Map<String, dynamic> data = jsonDecode(event);
      if (data.containsKey("message")) {
        if (data["message"] == "location_update") {
          emit(TrackLocationInitial(lat: data["lat"], long: data["long"]));
          print(data);
        }
      }
    });
  }
}
