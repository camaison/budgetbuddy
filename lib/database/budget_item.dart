class BudgetItem {
  int budgetId;
  String category;
  double currentAmount;
  String startDate;
  String endDate;
  double budget_limit;
  String title;
  String status;
  String description;

  BudgetItem({
    required this.budgetId,
    required this.category,
    required this.currentAmount,
    required this.startDate,
    required this.endDate,
    required this.budget_limit,
    required this.title,
    required this.status,
    required this.description,
  });

  factory BudgetItem.fromMap(Map<String, dynamic> map) {
    return BudgetItem(
      budgetId: map['budget_id'],
      category: map['category'],
      currentAmount: map['current_amount'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      budget_limit: map['budget_limit'],
      title: map['title'],
      status: map['status'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'budget_id': budgetId,
      'category': category,
      'current_amount': currentAmount,
      'start_date': startDate,
      'end_date': endDate,
      'budget_limit': budget_limit,
      'title': title,
      'status': status,
      'description': description,
    };
  }
}
