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
  ScrollController _scrollController = ScrollController();

  //创建列表
  ListView lvb() {
    return new ListView.builder(
        reverse: true,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return new ListTile(
            leading: Icon(Icons.map),
            subtitle: new Text('${items[index][0]}'),
            title: new Text('${items[index][1]}'),
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
              if (MqttTool.getInstance().isConnect()) {
                MqttTool.getInstance().subscribe((topic, payload) {
                  setState(() {
                    items.add([topic, payload]);
                    // items.add('$topic : $payload');
                  });
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
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
