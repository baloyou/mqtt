import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mqtt/store.dart';
import 'package:provider/provider.dart';

import 'db/setting.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  GlobalKey _formKey = GlobalKey<FormState>();
  var logger = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('setting ==== didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
                initialValue: store.mqttData['server'],
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "MQTT服务器地址",
                    hintText: "IP 或者 域名均可",
                    prefixIcon: Icon(MdiIcons.server)),
                validator: (v) {
                  return v!.trim().length > 0 ? null : "地址不能为空";
                },
                onSaved: (val) {
                  store.mqttData['server'] = val;
                }),
            TextFormField(
              initialValue: store.mqttData['port'],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "MQTT 服务端口",
                  hintText: "普通连接默认1883，SSL连接默认8883",
                  prefixIcon: Icon(MdiIcons.midiPort)),
              validator: (v) {
                return RegExp(r'^[0-9]+$').hasMatch(v!) ? null : "端口必须是数字";
              },
              onSaved: (val) {
                store.mqttData['port'] = val;
              },
            ),
            CheckboxListTile(
              title: Text("使用SSL连接"),
              value: store.mqttData['ssl'],
              activeColor: Colors.red, //选中时的颜色
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  store.mqttData['ssl'] = value;
                });
              },
            ),
            TextFormField(
              initialValue: store.mqttData['username'],
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "账户",
                  hintText: "连接到MQTT使用的账号",
                  prefixIcon: Icon(Icons.person)),
              onSaved: (val) {
                store.mqttData['username'] = val;
              },
            ),
            TextFormField(
              initialValue: store.mqttData['password'],
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "对应的密码",
                  prefixIcon: Icon(Icons.lock)),
              obscureText: false,
              onSaved: (val) {
                store.mqttData['password'] = val;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("保存"),
                      ),
                      onPressed: () async {
                        // 通过_formKey.currentState 获取FormState后，
                        // 调用validate()方法校验用户名密码是否合法，校验
                        // 通过后再提交数据。
                        if ((_formKey.currentState as FormState).validate()) {
                          /// 验证通过保存数据到store
                          (_formKey.currentState as FormState).save();
                          print(store.mqttData);

                          /// 保存数据到数据库
                          SettingModel settings = SettingModel();
                          int id = await settings.save({
                            'key': 'mqtt',
                            'value': store.mqttData.toString(),
                          });
                          print('save=====');
                          print(id);
                          print(await settings.getList());
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
