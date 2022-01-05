import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mqtt.dart';
import 'store.dart';

class Control extends StatefulWidget {
  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  Map sensors = {};
  data() {
    if (MqttTool.getInstance().isConnect()) {
      // print('start get sensors');
      MqttTool.getInstance().getSubscription((topic, payload) {
        RegExp mobile = new RegExp(r"^sht30/sensor/([a-zA-Z._0-9\-]+)/state$");
        if (mobile.firstMatch(topic) != null) {
          setState(() {
            sensors[mobile.firstMatch(topic)![1]] = {
              "name": mobile.firstMatch(topic)![1],
              "topic": topic,
              "payload": payload
            };
          });
        }
      });
    } else {
      print('mqtt is not connect.');
    }
  }

  @override
  Widget build(BuildContext context) {
    data();
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: map2list(context),
    );
  }

  List<Widget> map2list(BuildContext context) {
    Map sensorsConfig = Provider.of<Store>(context).sensors;
    Icon icon = Icon(
      Icons.favorite,
      color: Colors.blue,
    );
    // print(sensorsConfig['pm1_0']);
    List<Widget> tmp = [];
    sensors.forEach((key, value) {
      // print(sensorsConfig[key] ?? 'not');
      tmp.add(ListTile(
        leading:
            sensorsConfig.containsKey(key) ? sensorsConfig[key]['icon'] : icon,
        title: Text(value['payload']),
        subtitle: Text(
            sensorsConfig.containsKey(key) ? sensorsConfig[key]['name'] : key),
      ));
    });
    return tmp;
  }
}
