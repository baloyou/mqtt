import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class Store with ChangeNotifier {
  Store() {
    var rng = new Random();
    mqttData['client_id'] = 'mqtt_${rng.nextInt(10000)}';
  }

  Map mqttData = {
    'server': '192.168.1.254',
    'port': '1883',
    'username': 'admin',
    'password': 'admin',
    'ssl': false,
    'client_id': null,
  };

  Map sensors = {
    'pm1_0': {
      "name": 'pm1.0',
      'icon': Icon(
        Icons.air,
        color: Colors.blue,
      )
    },
    'pm2_5': {
      "name": 'pm2.5',
      'icon': Icon(
        Icons.air,
        color: Colors.blue,
      )
    },
    'pm_10': {
      "name": 'pm10',
      'icon': Icon(
        Icons.air,
        color: Colors.blue,
      )
    },
    'workshop_eco2': {
      "name": '二氧化碳',
      'icon': Icon(
        Icons.eco,
        color: Colors.blue,
      )
    },
    'workshop_tvoc': {
      "name": 'tvoc',
      'icon': Icon(
        Icons.air,
        color: Colors.blue,
      )
    },
    'sht30-temperature': {
      "name": '温度',
      'icon': Icon(
        MdiIcons.coolantTemperature,
        color: Colors.red,
      )
    },
    'sht30-humidity': {
      "name": '湿度',
      'icon': Icon(
        WeatherIcons.wi_humidity,
        color: Colors.green,
      )
    },
  };

  void mqtt(data) {
    mqttData = data;
    notifyListeners();
  }
}
