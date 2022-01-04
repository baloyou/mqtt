import 'package:flutter/material.dart';

class Control extends StatefulWidget {
  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  @override
  Widget build(BuildContext context) {
    return Text("先检查mqtt是否已连接\r\n向指定频道发送指定消息\r\n频道地址\r\n多行消息框\r\n发送按钮");
  }
}
