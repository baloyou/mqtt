import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Text("查看 mqtt 信息\r\n 连接按钮、断开按钮、提示信息");
  }
}
