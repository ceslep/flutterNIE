import 'package:flutter/foundation.dart';

class YearProvider extends ChangeNotifier {
  String _year = "";

  String get year => _year;

  void setYear(String year) {
    _year = year;
    notifyListeners();
  }
}
