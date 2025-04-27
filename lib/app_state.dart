import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String get userType => prefs.getString('ff_userType') ?? 'trainee';
  set userType(String value) {
    prefs.setString('ff_userType', value);
  }

  bool get isFirstTme => prefs.getBool('ff_isFirstTme') ?? true;
  set isFirstTme(bool value) {
    prefs.setBool('ff_isFirstTme', value);
  }

  bool get isLogined => prefs.getBool('ff_isLogined') ?? false;
  set isLogined(bool value) {
    prefs.setBool('ff_isLogined', value);
  }

  Future<void> clear() async {
    FFAppState().isLogined = false;
    FFAppState().userType = 'trainee';
  }
}
