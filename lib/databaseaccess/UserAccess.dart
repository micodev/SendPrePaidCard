import 'dart:async';
import 'package:trymethods/database/database.dart';
import 'package:trymethods/model/User.dart';

class UserAccess {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createUser(User user) async {
    final db = await dbProvider.database;
    //debugPrint(user.toDatabaseJson().toString());
    var result = db.insert(userTABLE, user.toDatabaseJson());
    return result;
  }

  Future<List<User>> getUsers({List<String> columns}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.query(userTABLE, columns: columns);
    List<User> users = result.isNotEmpty
        ? result.map((item) => User.fromDatabaseJson(item)).toList()
        : [];
    return users;
  }

  Future<User> getUser(String id) async {
    final db = await dbProvider.database;
    var res = await db.query(userTABLE, where: "number = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromDatabaseJson(res.first) : Null;
  }

  Future<int> updateUser(User user) async {
    final db = await dbProvider.database;

    var result = await db.update(userTABLE, user.toDatabaseJson(),
        where: "id = ?", whereArgs: [user.id]);

    return result;
  }

  Future<int> deleteUser(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(userTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllUsers() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      userTABLE,
    );

    return result;
  }
}
