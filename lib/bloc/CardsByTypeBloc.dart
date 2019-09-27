import 'dart:async';
import 'package:trymethods/model/CreditCard.dart';
import 'package:trymethods/repository/AppRepository.dart';

class CardsByTypeBloc {
  final _cardRepo = AppRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _cardController = StreamController<List<CreditCard>>.broadcast();
  final String cardtype;
  get cards => _cardController.stream;

  CardsByTypeBloc(this.cardtype) {
    getCreditCards();
  }

  getCreditCards() async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _cardController.sink.add(await _cardRepo.getCreditCardsByType(cardtype));
  }

  addCard(CreditCard card) async {
    await _cardRepo.insertCreditCard(card);
    getCreditCards();
  }

  addTypes() async {
    await _cardRepo.addTypesIfNotExist();
  }

  updateCard(CreditCard card) async {
    await _cardRepo.updateCreditCard(card);
    getCreditCards();
  }

  deleteCardById(int id) async {
    await _cardRepo.deleteCreditCardById(id);
    getCreditCards();
  }

  deleteCardByTypeId(int id) async {
    await _cardRepo.deleteCardByCardType(id);
    getCreditCards();
  }

  dispose() {
    _cardController.close();
  }
}
