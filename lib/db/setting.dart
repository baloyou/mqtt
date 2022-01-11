import 'package:sqflite/sqflite.dart';
import 'db.dart';

class SettingModel {
  final String tableName = 'settings';

  SettingModel();

  Future<int> save(Map<String, String> data) async {
    final db = await SqliteDB.getInstance().getDb();
    // SqliteDB.getInstance().deleteDB();
    // return 0;
    // Get a reference to the database.
    // final db = await SqliteDB.getInstance().getDb();
    // print(db);
    // return 0;
    // List<Map> rows =
    //     await getList(where: 'key=?', whereArgs: ['mqtt'], limit: 1);
    // if(rows.length>0){

    // }else{

    // }
    return await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///获取所有配置
  Future<List<Map>> getList({
    String? where,
    List<Object?>? whereArgs,
    int? limit,
  }) async {
    // Get a reference to the database.
    final db = await SqliteDB.getInstance().getDb();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(tableName,
        where: where, whereArgs: whereArgs, limit: limit);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return {
        'key': maps[i]['key'],
        'value': maps[i]['value'],
      };
    });
  }
}
