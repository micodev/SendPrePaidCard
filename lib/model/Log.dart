import 'package:intl/intl.dart';

class Log {
  int id;
  int userId;
  double amount; //
  String label;
  int date;
  Log({this.id, this.userId, this.label, this.amount, this.date});

  factory Log.fromJson(Map<String, dynamic> json) => new Log(
      id: json["id"],
      userId: json["userId"],
      amount: json["amount"],
      label: json["label"],
      date: json["date"]);
  factory Log.fromDatabaseJson(Map<String, dynamic> json) => Log(
        id: json["id"],
        userId: json["userId"],
        amount: json["amount"],
        label: json["label"],
        date: json["date"],
      );
  String toDate() {
    DateTime _date = DateTime.fromMillisecondsSinceEpoch(date);
    String dt = DateFormat("yyyy-MM-dd").format(_date);
    return dt;
  }

  Map<String, dynamic> toDatabaseJson() => {
        'id': id,
        'userId': userId,
        'amount': amount,
        'date': date,
        'label': label
      };
}
