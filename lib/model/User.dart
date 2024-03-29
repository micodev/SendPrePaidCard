class User {
    int id;
   String name;
   String number;
   double balance;
  User({this.id, this.name, this.number, this.balance});
  factory User.fromDatabaseJson(Map<String, dynamic> json) => User(
    //Factory method will be used to convert JSON objects that
    //are coming from querying the database and converting
    //it into a Todo object
        id: json["id"],
        name: json["name"],
        number: json["number"],
        balance: json["balance"],
      );

  Map<String, dynamic> toDatabaseJson() => { 'name': name, 'number': number, 'balance': balance};
}
