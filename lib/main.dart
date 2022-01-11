import 'package:flutter/material.dart';
import 'package:mqtt/control.dart';
import 'package:mqtt/home.dart';
import 'package:mqtt/setting.dart';
import 'package:mqtt/subscribe.dart';
import 'package:mqtt/store.dart';
import 'package:provider/provider.dart';

import 'mqtt.dart';

//程序入口
void main() => runApp(MyApp());

//入口类
class MyApp extends StatelessWidget {
  //用构造函数覆盖父类
  const MyApp({Key? key}) : super(key: key);
  //程序名称
  static const String _title = 'ESPHOME 控制器 <MQTT>';

  //重写父类build方法，绘制界面
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Store(),
        child: MaterialApp(
          title: _title,
          home: MyStatefulWidget(title: _title),
        ));
  }
}

//有状态的widget
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, this.title = ''}) : super(key: key);
  final String title;
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

//UI框架（底部菜单）
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  //这里换成4个容器对象，分别建立子页面即可
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Subscribe(),
    Control(),
    Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //全局注入共享状态
  MqttTool mt = MqttTool.getInstance();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('main ==== didChangeDependencies');
    mt.setConfig(Provider.of<Store>(context).mqttData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('BottomNavigationBar Sample'),
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cast_connected),
            label: '连接',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_sharp),
            label: '订阅',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pest_control),
            label: '控制',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
            backgroundColor: Colors.purple,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
