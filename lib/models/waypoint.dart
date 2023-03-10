class WayPoint {
  double latitude;
  double longitude;
  int order;
  String? name;

  WayPoint(
      {required this.latitude, required this.longitude, required this.order});

  Map<String, dynamic> toJSON(WayPoint wayPoint) {
    return {
      "latitude": wayPoint.latitude,
      "longitude": wayPoint.longitude,
      "index": wayPoint.order,
      "name": wayPoint.name ?? ""
    };
  }
}
