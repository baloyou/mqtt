import 'package:flutter/material.dart';
import 'package:mqtt/store.dart';
import 'package:provider/provider.dart';

import 'mqtt.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //列表中使用的模拟数据
  final List items = [];

  //创建列表
  ListView lvb() {
    print('start');
    return new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          print('build');
          return new ListTile(
            title: new Text('${items[index]}'),
          );
        });
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
              setState(() {
                items.add('aaa');
              });
              print(items);
              if (MqttTool.getInstance().isConnect()) {
                MqttTool.getInstance().subscribe();
              } else {
                print('mqtt is not connect.');
              }
            }),
        Expanded(
            child: Container(
          child: lvb(),
        ))
      ],
    );
  }
}
