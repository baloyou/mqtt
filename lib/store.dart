import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  Map mqttData = {
    'server': '192.168.1.254',
    'port': '1883',
    'username': 'admin',
    'password': 'admin',
    'ssl': false,
  };

  void mqtt(data) {
    mqttData = data;
    notifyListeners();
  }
}
