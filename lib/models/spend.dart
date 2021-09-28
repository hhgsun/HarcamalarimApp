import 'package:harcamalarim/models/coords.dart';

class Spend {
  String? id;
  String? desc;
  String? amount;
  DateTime? date;
  String? catId;
  Coords? coords;

  Spend({
    this.id,
    required this.desc,
    required this.amount,
    required this.date,
    required this.catId,
    this.coords,
  });

  factory Spend.fromJson(Map<String, dynamic> json) {
    return Spend(
      id: json['id'],
      desc: json['desc'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      catId: json['catId'],
      coords: Coords.fromJson(json['coords']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "desc": desc,
        "amount": amount,
        "date": date.toString(),
        "catId": catId,
        "coords": coords != null ? coords?.toJson() : {},
      };
}
