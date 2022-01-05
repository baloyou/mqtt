import 'package:flutter/material.dart';
import 'dart:convert';

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
                        'homeassistant/sensor/sht30/sht30-temperature/config');
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
                onPressed: () {
                  if (MqttTool.getInstance().isConnect()) {
                    MqttTool.getInstance().getSubscription((topic, payload) {
                      //先检查widget是否处于可见状态，否则会刷屏报错
                      if (this.mounted) {
                        //更新状态items
                        setState(() {
                          items.add([topic, payload]);
                        });
                        //将滚动条定位到最后一条数据
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      }
                    });
                  } else {
                    print('mqtt is not connect.');
                  }
                }),
            ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("关闭"),
                ),
                onPressed: () {
                  if (MqttTool.getInstance().isConnect()) {
                    MqttTool.getInstance().stopSubscription();
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
