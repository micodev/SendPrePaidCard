import 'dart:async';
import 'package:trymethods/database/database.dart';
import 'package:trymethods/model/Company.dart';

class CompanyAccess {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createCompany(Company company) async {
    final db = await dbProvider.database;
    //debugPrint(company.toDatabaseJson().toString());
    var result = db.insert(companyTABLE, company.toDatabaseJson());
    return result;
  }

  Future<Company> getCompany(int id) async {
    final db = await dbProvider.database;
    var res = await db.query(companyTABLE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Company.fromDatabaseJson(res.first) : Null;
  }

  Future<List<Company>> getCompanys({List<String> columns}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.query(companyTABLE, columns: columns);
    List<Company> companys = result.isNotEmpty
        ? result.map((item) => Company.fromDatabaseJson(item)).toList()
        : [];
    return companys;
  }

  Future<int> updateCompany(Company company) async {
    final db = await dbProvider.database;

    var result = await db.update(companyTABLE, company.toDatabaseJson(),
        where: "id = ?", whereArgs: [company.id]);

    return result;
  }

  Future<int> deleteCompany(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(companyTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllCompanys() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      companyTABLE,
    );

    return result;
  }
}
