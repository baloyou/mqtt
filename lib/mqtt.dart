import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttTool {
  //自动推导变量类型
  static var _instance;

  //mqtt的配置数据
  Map? mqttData;

  //mqtt客户端对象
  MqttServerClient? mqttClient;

  //订阅的stream
  // ignore: cancel_subscriptions
  StreamSubscription? _dataSubscription;

  //单例模式获取对象
  static MqttTool getInstance() {
    if (_instance == null) {
      _instance = MqttTool();
    }
    return _instance;
  }

  ///传入MQTT的配置项（通过 widget 的provider）
  void setConfig(Map d) {
    mqttData = d;
  }

  ///检查是否连接
  bool isConnect() {
    if (mqttClient == null ||
        mqttClient!.connectionStatus!.state != MqttConnectionState.connected) {
      return false;
    }
    return true;
  }

  //连接到mqtt
  Future<MqttServerClient?> connect() async {
    if (mqttClient == null) {
      mqttClient =
          MqttServerClient(mqttData!['server'], mqttData!['client_id']);
    }

    ///已经处于连接状态，直接返回
    if (mqttClient!.connectionStatus!.state == MqttConnectionState.connected) {
      print('already connected');
      return mqttClient;
    }

    ///连接信息
    mqttClient!.port = int.parse(mqttData!['port']);
    mqttClient!.secure = false;
    mqttClient!.setProtocolV311();
    mqttClient!.logging(on: false);
    mqttClient!.keepAlivePeriod = 20;

    await mqttClient!.connect(mqttData!['username'], mqttData!['password']);
    return mqttClient;

    ///连接
    // try {
    //   print('re connected');
    //   return mqttClient;
    // } on Exception catch (e) {
    //   print('EXAMPLE::client exception - $e');
    //   mqttClient!.disconnect();
    //   return throw Exception(e);
    //   // return Future.delayed(Duration(milliseconds: 5000), () async {
    //   //   return mqttClient = await connect();
    //   // });
    // }
  }

  Future reConnect() async {
    try {
      return mqttClient = await connect();
    } on Exception catch (e) {
      print(e);
      Future.delayed(Duration(milliseconds: 5000), () async {
        return mqttClient = await reConnect();
      });
    }
  }

  /// 通过stream 获取订阅频道的数据
  /// 注意：不要重复调用，会造成重复订阅
  getSubscription(String topic, fn) async {
    /// 连接MQTT
    mqttClient = await connect();

    /// 订阅频道
    mqttClient!.subscribe(topic, MqttQos.atMostOnce);

    /// 已经有此链接
    // if (_dataSubscription != null) {
    //   return;
    // }
    // _dataSubscription.
    /// 通过stream 获取数据(如何避免它重复执行？)
    _dataSubscription = mqttClient!.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      fn(c[0].topic, pt);
      print('topic is <${c[0].topic}>, payload is <-- $pt -->');
      // print(pt);
      // print(recMess);
    });
    _dataSubscription!.onDone(() {
      print('onDone===');
    });
    _dataSubscription!.onError((error) {
      print('onError===$error');
    });
  }

  ///订阅stream之后的取消操作。
  subAction(String ac) {
    if (_dataSubscription == null) {
      print('it is not subScription');
      return null;
    }
    if (ac == 'cancel') {
      return _dataSubscription!.cancel();
    }
    if (ac == 'pause') {
      return _dataSubscription!.pause();
    }
    if (ac == 'resume') {
      return _dataSubscription!.resume();
    }
  }

  /// 订阅一个指定的频道
  subscribe(String topic) {
    connect().then((mqttClient) {
      mqttClient!.subscribe(topic, MqttQos.atMostOnce);
    });
  }
}
