import 'dart:async';
import 'package:trymethods/database/database.dart';
import 'package:trymethods/databaseaccess/CompanyAccess.dart';
import 'package:trymethods/model/CardType.dart';
import 'package:trymethods/model/Company.dart';

class CardTypeAccess {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createCardType(CardType type) async {
    final db = await dbProvider.database;
    //debugPrint(type.toDatabaseJson().toString());
    var result = db.insert(typeTABLE, type.toDatabaseJson());
    return result;
  }

  Future<List<CardType>> getCardTypes({List<String> columns}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.query(typeTABLE, columns: columns);
    List<CardType> types = result.isNotEmpty
        ? result.map((item) => CardType.fromDatabaseJson(item)).toList()
        : [];
    return types;
  }

  Future<int> updateCardType(CardType type) async {
    final db = await dbProvider.database;

    var result = await db.update(typeTABLE, type.toDatabaseJson(),
        where: "id = ?", whereArgs: [type.id]);

    return result;
  }

  Future<int> deleteCardType(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(typeTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllCardTypes() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      typeTABLE,
    );
    return result;
  }

  Future deleteAllCardTypesByCompany(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(typeTABLE, where: 'companyId = ?', whereArgs: [id]);
    return result;
  }

  Future<List<CardType>> getCardTypesByCompany(int id) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.query(typeTABLE, where: 'companyId = ?', whereArgs: [id]);
    List<CardType> types = result.isNotEmpty
        ? result.map((item) => CardType.fromDatabaseJson(item)).toList()
        : [];
    return types;
  }

  Future addTypesIfNotExist() async {
    CompanyAccess cmpacc = CompanyAccess();
    var types = await cmpacc.getCompanys(); //getCardTypes();
    if (types.length == 0) {
      cmpacc.createCompany(Company(name: "AsiaCell")); // 1
      cmpacc.createCompany(Company(name: "Korek")); // 2
      cmpacc.createCompany(Company(name: "Zain")); // 3
    }
  }

  Future<List<List<dynamic>>> getCardTypeAndCompany() async {
    final db = await dbProvider.database;
    var cmpa = new CompanyAccess();
    List<List<dynamic>> _final = new List();
    List<Map<String, dynamic>> result;

    result = await db.query(typeTABLE);
    List<CardType> types = result.isNotEmpty
        ? result.map((item) => CardType.fromDatabaseJson(item)).toList()
        : [];

    for (int i = 0; i < types.length; i++) {
      Company c = await cmpa.getCompany(types[i].companyId);
      _final.add([types[i], c]);
    }

    return _final;
  }
}
