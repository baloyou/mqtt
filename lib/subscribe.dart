import 'package:flutter/material.dart';

class Subscribe extends StatefulWidget {
  @override
  State<Subscribe> createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
  @override
  Widget build(BuildContext context) {
    return Text("频道:____ 订阅按钮\r\n已订阅的频道列表、删除按钮\r\n 来自不同频道的消息列表\r\n时间、频道、消息内容");
  }
}
