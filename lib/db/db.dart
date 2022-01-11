import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDB {
  static var _instance;
  var db;

  ///单例模式获取对象
  static SqliteDB getInstance() {
    if (_instance == null) {
      _instance = SqliteDB();
    }
    return _instance;
  }

  ///得到一个database对象
  Future<Database> getDb() async {
    ///已经有了db对象，就直接返回
    if (db is Future<Database>) {
      return db;
    }

    /// 打开数据库
    db = await openDatabase(
      join(await getDatabasesPath(), 'my.db'),
      version: 1,
      onCreate: (db, version) async {
        var batch = db.batch();

        /// 添加settings表
        batch.execute('DROP TABLE IF EXISTS settings');
        batch.execute('''CREATE TABLE settings (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              key TEXT UNIQUE,value TEXT)
            ''');

        ///添加设备表
        batch.execute('DROP TABLE IF EXISTS entities');
        batch.execute('''CREATE TABLE entities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    device_name TEXT DEFAULT '', --设备的名字，比如 sht30
    type TEXT DEFAULT '', --实体的类型(switch/sensor..)
    name TEXT DEFAULT '', --实体的名字
    name_show TEXT DEFAULT '', --自定义的实体名字，便于阅读
    icon TEXT DEFAULT '', --图标
    config TEXT DEFAULT '', --从mqtt得到的配置json
    config_topic TEXT DEFAULT '',
    state_topic  TEXT DEFAULT '',
    status_topic Text DEFAULT '', --设备在线状态的topic
    value TEXT,
    in_time INTEGER DEFAULT (cast(strftime('%s','now') as int)),
    up_time INTEGER DEFAULT 0,
    rm_time INTEGER DEFAULT 0
)''');
        await batch.commit();
      },
    );
    return db;
  }

  /// 删除数据库
  deleteDB() async {
    File file = File(join(await getDatabasesPath(), 'my.db'));
    if (file.existsSync()) {
      print('delete ok');
      file.deleteSync();
    } else {
      print('file not exists');
    }
  }
}
