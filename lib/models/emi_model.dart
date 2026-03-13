class EmiModel {
  final int? id;
  final String title;
  final double amount;
  final String date;

  EmiModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'amount': amount, 'date': date};
  }

  factory EmiModel.fromMap(Map<String, dynamic> map) {
    return EmiModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
