class Coords {
  double latitude;
  double longitude;

  Coords(this.latitude, this.longitude);

  factory Coords.fromJson(Map json) =>
      Coords(double.parse(json['latitude']), double.parse(json['longitude']));

  Map toJson() =>
      {'latitude': latitude.toString(), 'longitude': longitude.toString()};
}
