class BudgetItem {
  int budgetId;
  String category;
  double currentAmount;
  String startDate;
  String endDate;
  double limit;
  String title;
  String status;

  BudgetItem({
    required this.budgetId,
    required this.category,
    required this.currentAmount,
    required this.startDate,
    required this.endDate,
    required this.limit,
    required this.title,
    required this.status,
  });

  factory BudgetItem.fromMap(Map<String, dynamic> map) {
    return BudgetItem(
      budgetId: map['budget_id'],
      category: map['category'],
      currentAmount: map['current_amount'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      limit: map['limit'],
      title: map['title'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'budget_id': budgetId,
      'category': category,
      'current_amount': currentAmount,
      'start_date': startDate,
      'end_date': endDate,
      'limit': limit,
      'title': title,
      'status': status,
    };
  }
}
