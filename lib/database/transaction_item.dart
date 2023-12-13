class TransactionItem {
  int transactionId;
  String dateTime;
  double amount;
  String category;
  String type;
  String title;
  String createdDateTime;
  String description;

  TransactionItem({
    required this.transactionId,
    required this.dateTime,
    required this.amount,
    required this.category,
    required this.type,
    required this.title,
    required this.createdDateTime,
    required this.description,
  });

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      transactionId: map['transaction_id'],
      dateTime: map['date_time'],
      amount: map['amount'],
      category: map['category'],
      type: map['type'],
      title: map['title'],
      createdDateTime: map['created_date_time'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transaction_id': transactionId,
      'date_time': dateTime,
      'amount': amount,
      'category': category,
      'type': type,
      'title': title,
      'created_date_time': createdDateTime,
      'description': description,
    };
  }
}
