import 'package:flutter/material.dart';

import 'mqtt.dart';

class Control extends StatefulWidget {
  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
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
        itemExtent: 50,
        itemBuilder: (context, index) {
          return new ListTile(
            dense: true,
            leading: Icon(
              Icons.favorite,
              color: Colors.blue,
            ),
            subtitle: new Text('${items[index][0]}'),
            title: new Text('${items[index][1]}'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("订阅"),
                ),
                onPressed: () {
                  if (MqttTool.getInstance().isConnect()) {
                    MqttTool.getInstance().subscribe(
                        'Controlassistant/sensor/sht30/sht30-temperature/config');
                    MqttTool.getInstance().subscribe('sht30/sensor/+/state');
                  } else {
                    print('mqtt is not connect.');
                  }
                }),
            ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("获取(${items.length})"),
                ),
                onPressed: () {}),
            ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("关闭"),
                ),
                onPressed: () {
                  if (MqttTool.getInstance().isConnect()) {
                    // MqttTool.getInstance().stopSubscription();
                  } else {
                    print('mqtt is not connect.');
                  }
                }),
            ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("清空"),
                ),
                onPressed: () {
                  setState(() {
                    items.clear();
                  });
                }),
          ],
        ),
        Expanded(
            child: Container(
          child: lvb(),
        ))
      ],
    );
  }
}
