import 'package:flutter/material.dart';
import 'package:mqtt/store.dart';
import 'package:provider/provider.dart';

import 'mqtt.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  rightClick() {
    print('123');
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    return Column(
      children: [
        Text(store.mqttData.toString()),
        ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("订阅频道"),
            ),
            onPressed: () {
              MqttTool.getInstance().subscribe();
            }),
      ],
    );
  }
}
