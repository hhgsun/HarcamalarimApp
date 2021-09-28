import 'package:flutter/foundation.dart';
import 'package:harcamalarim/models/coords.dart';
import 'package:harcamalarim/models/spend.dart';
import 'package:harcamalarim/services/location_service.dart';

class SpendsService extends ChangeNotifier {
  LocationService locationService = LocationService();

  SpendsService(){
    spends.addAll([
      Spend(id: "0", desc: "Açıklama 1", amount: "100", date: DateTime.now(), catId: "Yemek", coords: Coords(40.9694567,29.0000)),
      Spend(id: "1", desc: "Açıklama 2", amount: "620", date: DateTime.now(), catId: "Spor",coords: Coords(40.9694567,29.2620939)),
      Spend(id: "2", desc: "Açıklama 3", amount: "256", date: DateTime.now(), catId: "Eğlence",coords: Coords(40.9694567,30.00000)),
      Spend(id: "3", desc: "Açıklama 4", amount: "400", date: DateTime.now(), catId: "Ulaşım",coords: Coords(40.9694567,30.2620939)),
      Spend(id: "4", desc: "Açıklama 5", amount: "300", date: DateTime.now(), catId: "Yemek",coords: Coords(40.9694567,30.4620939)),
      Spend(id: "5", desc: "Açıklama 6", amount: "250", date: DateTime.now(), catId: "Spor",coords: Coords(40.9694567,30.6620939)),
    ]);
  }

  List<String?> get cats {
    return spends.map((e) => e.catId).toSet().toList();
  }

  List<Spend> _spends = [];

  List<Spend> get spends => _spends;

  set spends(List<Spend> spends) {
    _spends = spends;
    notifyListeners();
  }

  Spend getById(String id) => _spends.where((s) => s.id == id).first;

  bool addSpend(Spend spend) {
    _spends.add(spend);
    notifyListeners();
    return true;
  }

  bool updateSpend(Spend spend) {
    int index = _spends.indexWhere((s) => s.id == spend.id);
    if (index != -1) {
      _spends[index] = spend;
    }
    notifyListeners();
    return true;
  }

  bool deleteSpend(Spend spend) {
    int index = _spends.indexWhere((s) => s.id == spend.id);
    if (index != -1) {
      _spends.removeAt(index);
    }
    notifyListeners();
    return true;
  }
}
