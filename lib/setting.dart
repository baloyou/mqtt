import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Text("设置MQTT的信息\r\n服务器地址、端口\r\n是否使用SSL\r\n账号、密码");
  }
}
