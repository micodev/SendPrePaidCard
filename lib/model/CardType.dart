class CardType {
  int id;
  double price;
  int companyId;
  double brandPrice;
  CardType({this.id, this.price, this.brandPrice, this.companyId});

  factory CardType.fromDatabaseJson(Map<String, dynamic> json) => CardType(
        id: json["id"],
        price: json["price"],
        companyId: json["companyId"],
        brandPrice: json["brandPrice"],
      );

  Map<String, dynamic> toDatabaseJson() => {
        'id': id,
        'price': price,
        'companyId': companyId,
        'brandPrice': brandPrice
      };
}
