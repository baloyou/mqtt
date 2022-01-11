import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mqtt.dart';
import 'store.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  Map sensors = {};

  data() {
    MqttTool.getInstance().getSubscription('sht30/sensor/+/state',
        (topic, payload) {
      if (!this.mounted) {
        return;
      }
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
  }

  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  deactivate() {
    print('deactivate');
    super.deactivate();
    MqttTool.getInstance().subAction('cancel');
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("-didChangeAppLifecycleState-" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        if (MqttTool.getInstance().isConnect() != true) {
          data();
        }
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    data();
    print('didChangeDependencies');
  }

  ///弹出一个窗体
  showAlertDialog(BuildContext context, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("连接状态"),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
              onPressed: () {
                MqttTool.getInstance().mqttClient!.disconnect();
                return showAlertDialog(context, '已断开');
              },
              child: Text("断开连接"),
            ),
            OutlinedButton(
              onPressed: () {
                showAlertDialog(context,
                    MqttTool.getInstance().isConnect() ? '连接中' : '已断开');
              },
              child: Text("检查状态"),
            ),
            OutlinedButton(
              onPressed: () {
                if (MqttTool.getInstance().isConnect() == true) {
                  return showAlertDialog(context, '已连接，不能重连');
                }
                data();
                return showAlertDialog(context, '重连完毕');
              },
              child: Text("重新连接"),
            ),
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          childAspectRatio: 4 / 2,
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: map2list(context),
        ),
      ],
    );
  }

  ///mqtt订阅的数据，被组装成map类型（防止重复数据）
  ///在gridview展示时，需要组装成一个list的widget
  ///图标和名字，通过 store.dart 进行配置
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
      tmp.add(
        Container(
          // color: Colors.lightBlue,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: Colors.black12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.green, spreadRadius: 2),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.only(
              left: 1,
              right: 0,
              top: 0,
              bottom: 0,
            ),
            leading: sensorsConfig.containsKey(key)
                ? sensorsConfig[key]['icon']
                : icon,
            title: Text(value['payload']),
            subtitle: Text(sensorsConfig.containsKey(key)
                ? sensorsConfig[key]['name']
                : key),
          ),
        ),
      );
    });
    return tmp;
  }
}
