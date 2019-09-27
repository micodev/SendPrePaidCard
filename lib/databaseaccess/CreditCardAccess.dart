import 'dart:async';
import 'package:trymethods/database/database.dart';
import 'package:trymethods/databaseaccess/CardTypeAccess.dart';
import 'package:trymethods/databaseaccess/CompanyAccess.dart';
import 'package:trymethods/model/CardType.dart';
import 'package:trymethods/model/Company.dart';
import 'package:trymethods/model/CreditCard.dart';
import 'package:trymethods/model/PrintWidget.dart';

class CreditCardAccess {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createCreditCard(CreditCard card) async {
    final db = await dbProvider.database;
    //debugPrint(card.toDatabaseJson().toString());
    var result = db.insert(cardTABLE, card.toDatabaseJson());
    return result;
  }

  Future<List<CreditCard>> getCreditCards({List<String> columns}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.query(cardTABLE, columns: columns);
    List<CreditCard> cards = result.isNotEmpty
        ? result.map((item) => CreditCard.fromDatabaseJson(item)).toList()
        : [];
    return cards;
  }

  Future<int> updateCreditCard(CreditCard card) async {
    final db = await dbProvider.database;

    var result = await db.update(cardTABLE, card.toDatabaseJson(),
        where: "id = ?", whereArgs: [card.id]);

    return result;
  }

  Future<int> deleteCreditCard(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(cardTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future<int> deleteCreditCardByType(int id) async {
    final db = await dbProvider.database;
    var card = (await getCreditCards()).where((i) => i.typeId == id).first;
    var result =
        await db.delete(cardTABLE, where: 'id = ?', whereArgs: [card.id]);

    return result;
  }

  Future deleteAllCreditCards() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      cardTABLE,
    );

    return result;
  }

  Future deleteAllCreditCardsByTypes(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(cardTABLE, where: 'typeId = ?', whereArgs: [id]);

    return result;
  }

  Future<List<PrintWidget>> getAvailableCreditCardsCounts() async {
    CardTypeAccess ctacc = CardTypeAccess();
    CompanyAccess ccacc = CompanyAccess();
    var cards = await getCreditCards();
    List<PrintWidget> tplist = new List<PrintWidget>();
    for (CardType type in await ctacc.getCardTypes()) {
      Company cmp = await ccacc.getCompany(type.companyId);
      var typel = new PrintWidget(
          typeId: type.id,
          print: "${cmp.name} ${type.brandPrice}".replaceFirst(".0", ""),
          count: cards.where((i) => i.typeId == type.id).length);
      tplist.add(typel);
    }
    return tplist;
  }

  Future<List<CreditCard>> getCreditCardsByType(String query) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.query(cardTABLE, where: "typeId = ?", whereArgs: [query]);
    List<CreditCard> cards = result.isNotEmpty
        ? result.map((item) => CreditCard.fromDatabaseJson(item)).toList()
        : [];
    return cards;
  }
}
