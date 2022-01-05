import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttTool {
  //自动推导变量类型
  static var _instance;

  //mqtt的配置数据
  Map? mqttData;

  MqttServerClient? mqttClient;

  //单例模式获取对象
  static MqttTool getInstance() {
    if (_instance == null) {
      _instance = MqttTool();
    }
    return _instance;
  }

  void setConfig(Map d) {
    mqttData = d;
  }

  bool isConnect() {
    if (mqttClient == null ||
        mqttClient!.connectionStatus!.state != MqttConnectionState.connected) {
      return false;
    }
    return true;
  }

  //连接到mqtt
  Future<MqttClient?> connect() async {
    if (mqttClient == null) {
      mqttClient = MqttServerClient(mqttData!['server'], '12345');
    }

    if (mqttClient!.connectionStatus!.state == MqttConnectionState.connected) {
      print('already connected');
      return mqttClient;
    }
    mqttClient!.port = int.parse(mqttData!['port']);
    mqttClient!.secure = false;
    mqttClient!.setProtocolV311();
    mqttClient!.logging(on: false);
    mqttClient!.keepAlivePeriod = 20;
    try {
      await mqttClient!.connect(mqttData!['username'], mqttData!['password']);
      print('re connected');
      return mqttClient;
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      mqttClient!.disconnect();
    }
  }

  //订阅频道
  subscribe() {
    connect().then((mqttClient) {
      mqttClient!.subscribe("/test", MqttQos.atMostOnce);
      mqttClient.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print('topic is <${c[0].topic}>, payload is <-- $pt -->');
        print('');
      });
    });
  }
}
