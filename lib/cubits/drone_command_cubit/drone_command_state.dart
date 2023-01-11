part of 'drone_command_cubit.dart';

@immutable
abstract class DroneCommandState {}

class DroneCommandInitial extends DroneCommandState {}

class DroneCommandLoad extends DroneCommandState {}

class FetchMissionLoad extends DroneCommandState {}

class FetchMissionError extends DroneCommandState {}

class MissionSelect extends DroneCommandState {
  List<String> missions;
  MissionSelect({required this.missions});
}

class DroneCommandSucess extends DroneCommandState {}

class DroneCommandError extends DroneCommandState {}
