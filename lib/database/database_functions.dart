import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class DatabaseFunctions {
  static final DatabaseFunctions instance = DatabaseFunctions._instance();
  static Database? dataStore;

  DatabaseFunctions._instance();

  // New table names
  String budgetTable = 'budget_table';
  String transactionTable = 'transaction_table';
  String budgetTransactionTable = 'budget_transaction_table';

  // Columns for the Budget table only
  String colBudgetId = 'budget_id';
  String colCurrentAmount = 'current_amount';
  String colStartDate = 'start_date';
  String colEndDate = 'end_date';
  String colLimit = 'budget_limit';
  String colStatus = 'status';

  //Columns for the Transaction table only
  String colTransactionId = 'transaction_id';
  String colDateTime = 'date_time';
  String colAmount = 'amount';
  String colType = 'type';

  // Columns for both the Transaction table and Budget Table
  String colCategory = 'category';
  String colTitle = 'title';
  String colDescription = 'description';
  String colCreatedDateTime = 'created_date_time';

  // Database getter
  Future<Database> get db async {
    if (dataStore != null) return dataStore!;
    dataStore = await _initDb();
    return dataStore!;
  }

  // Initialize the database
  Future<Database> _initDb() async {
    String path = '${await getDatabasesPath()}budget_app.db';
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  // Method to get the database path
  Future<String> get databasePath async {
    return '${await getDatabasesPath()}budget_app.db';
  }

  // Create the database
  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $budgetTable($colBudgetId INTEGER PRIMARY KEY AUTOINCREMENT, $colCategory TEXT, $colCurrentAmount REAL, $colStartDate TEXT, $colEndDate TEXT, $colLimit REAL, $colTitle TEXT, $colStatus TEXT, $colDescription TEXT)');
    await db.execute(
        'CREATE TABLE $transactionTable($colTransactionId INTEGER PRIMARY KEY AUTOINCREMENT, $colDateTime TEXT, $colAmount REAL, $colCategory TEXT, $colType TEXT, $colTitle TEXT, $colCreatedDateTime TEXT, $colDescription TEXT)');
    await db.execute(
        'CREATE TABLE $budgetTransactionTable($colBudgetId INTEGER, $colTransactionId INTEGER, FOREIGN KEY($colBudgetId) REFERENCES $budgetTable($colBudgetId), FOREIGN KEY($colTransactionId) REFERENCES $transactionTable($colTransactionId), PRIMARY KEY($colBudgetId, $colTransactionId))');
  }

  //Delete the database
  Future<void> deleteDb() async {
    String path = '${await getDatabasesPath()}budget_app.db';
    await deleteDatabase(path);
  }

  //get all active budgets
  Future<List<Map<String, dynamic>>> getActiveBudgets() async {
    Database db = await this.db;
    return await db
        .rawQuery('SELECT * FROM $budgetTable WHERE $colStatus = "Active"');
  }

  //get all inactive budgets
  Future<List<Map<String, dynamic>>> getInactiveBudgets() async {
    Database db = await this.db;
    return await db
        .rawQuery('SELECT * FROM $budgetTable WHERE $colStatus = "Inactive"');
  }

// Insert a budget
  Future<int> insertBudget(Map<String, dynamic> budget) async {
    Database db = await this.db;
    return await db.insert(budgetTable, budget);
  }

  // Get all budgets
  Future<List<Map<String, dynamic>>> getBudgetList() async {
    Database db = await this.db;
    return await db.query(budgetTable);
  }

  // Update a budget
  Future<int> updateBudget(Map<String, dynamic> budget) async {
    Database db = await this.db;
    int id = budget[colBudgetId];
    return await db.update(
      budgetTable,
      budget,
      where: '$colBudgetId = ?',
      whereArgs: [id],
    );
  }

  // Delete a budget
  Future<int> deleteBudget(int id) async {
    Database db = await this.db;
    return await db.delete(
      budgetTable,
      where: '$colBudgetId = ?',
      whereArgs: [id],
    );
  }

  // Insert a transaction
  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    Database db = await this.db;
    return await db.insert(transactionTable, transaction);
  }

  // Get all transactions
  Future<List<Map<String, dynamic>>> getTransactionList() async {
    Database db = await this.db;
    return await db.query(transactionTable);
  }

  // Update a transaction
  Future<int> updateTransaction(
      Map<String, dynamic> transaction, int id) async {
    Database db = await this.db;
    return await db.update(
      transactionTable,
      transaction,
      where: '$colTransactionId = ?',
      whereArgs: [id],
    );
  }

  // Delete a transaction
  Future<int> deleteTransaction(int id) async {
    Database db = await this.db;
    return await db.delete(
      transactionTable,
      where: '$colTransactionId = ?',
      whereArgs: [id],
    );
  }

  //Delete all transactions
  Future<int> deleteAllTransactions() async {
    Database db = await this.db;
    return await db.delete(transactionTable);
  }

  // Insert a budget-transaction pair
  Future<int> insertBudgetTransaction(
      Map<String, dynamic> budgetTransaction) async {
    Database db = await this.db;
    return await db.insert(budgetTransactionTable, budgetTransaction);
  }

  // Get all budget-transaction pairs
  Future<List<Map<String, dynamic>>> getBudgetTransactionList() async {
    Database db = await this.db;
    return await db.query(budgetTransactionTable);
  }

  // Update a budget-transaction pair
  Future<int> updateBudgetTransaction(
      Map<String, dynamic> budgetTransaction) async {
    Database db = await this.db;
    int budgetId = budgetTransaction[colBudgetId];
    int transactionId = budgetTransaction[colTransactionId];
    return await db.update(
      budgetTransactionTable,
      budgetTransaction,
      where: '$colBudgetId = ? AND $colTransactionId = ?',
      whereArgs: [budgetId, transactionId],
    );
  }

  // Delete a budget-transaction pair
  Future<int> deleteBudgetTransaction(int budgetId, int transactionId) async {
    Database db = await this.db;
    return await db.delete(
      budgetTransactionTable,
      where: '$colBudgetId = ? AND $colTransactionId = ?',
      whereArgs: [budgetId, transactionId],
    );
  }

  // Get all transactions for a budget
  Future<List<Map<String, dynamic>>> getBudgetTransactions(int budgetId) async {
    Database db = await this.db;
    return await db.rawQuery(
        'SELECT * FROM $transactionTable WHERE $colTransactionId IN (SELECT $colTransactionId FROM $budgetTransactionTable WHERE $colBudgetId = $budgetId)');
  }

  // Get all budgets for a transaction
  Future<List<Map<String, dynamic>>> getTransactionBudgets(
      int transactionId) async {
    Database db = await this.db;
    return await db.rawQuery(
        'SELECT * FROM $budgetTable WHERE $colBudgetId IN (SELECT $colBudgetId FROM $budgetTransactionTable WHERE $colTransactionId = $transactionId)');
  }

  // Get the total amount spent for a budget
  Future<double> getBudgetTotal(int budgetId) async {
    Database db = await this.db;
    List<Map<String, dynamic>> transactions =
        await getBudgetTransactions(budgetId);
    double total = 0;
    for (Map<String, dynamic> transaction in transactions) {
      total += transaction[colAmount];
    }
    return total;
  }

  // Get the total amount spent for a category
  Future<double> getCategoryTotal(String category) async {
    Database db = await this.db;
    List<Map<String, dynamic>> transactions = await db.rawQuery(
        'SELECT * FROM $transactionTable WHERE $colCategory = $category');
    double total = 0;
    for (Map<String, dynamic> transaction in transactions) {
      total += transaction[colAmount];
    }
    return total;
  }

  // Get the total amount spent for a category in a budget
  Future<double> getCategoryBudgetTotal(int budgetId, String category) async {
    Database db = await this.db;
    List<Map<String, dynamic>> transactions = await db.rawQuery(
        'SELECT * FROM $transactionTable WHERE $colCategory = $category AND $colTransactionId IN (SELECT $colTransactionId FROM $budgetTransactionTable WHERE $colBudgetId = $budgetId)');
    double total = 0;
    for (Map<String, dynamic> transaction in transactions) {
      total += transaction[colAmount];
    }
    return total;
  }

  //Get total income and total expense as map
  Future<Map<String, double>> getIncomeExpenseTotal() async {
    Database db = await this.db;
    List<Map<String, dynamic>> transactions =
        await db.rawQuery('SELECT * FROM $transactionTable');
    double income = 0;
    double expense = 0;
    for (Map<String, dynamic> transaction in transactions) {
      if (transaction[colType] == 'Income') {
        income += transaction[colAmount];
      } else {
        expense += transaction[colAmount];
      }
    }
    return {'income': income, 'expense': expense};
  }

  //Get transactions for a specific year
  Future<List<Map<String, dynamic>>> getTransactionsForYear(int year) async {
    Database db = await this.db;
    return await db.rawQuery(
        'SELECT * FROM $transactionTable WHERE $colDateTime LIKE "$year%"');
  }

  //Get transactions for a specific month
  Future<List<Map<String, dynamic>>> getTransactionsForMonth(
      int year, int month) async {
    Database db = await this.db;
    return await db.rawQuery(
        'SELECT * FROM $transactionTable WHERE $colDateTime LIKE "$year-$month%"');
  }

  //Get transactions for a specific day
  Future<List<Map<String, dynamic>>> getTransactionsForDay(
      int year, int month, int day) async {
    Database db = await this.db;
    return await db.rawQuery(
        'SELECT * FROM $transactionTable WHERE $colDateTime LIKE "$year-$month-$day%"');
  }

  //Get 10 most recent transactions
  Future<List<Map<String, dynamic>>> getRecentTransactions() async {
    Database db = await this.db;
    return await db.rawQuery(
        'SELECT * FROM $transactionTable ORDER BY $colDateTime DESC LIMIT 10');
  }
}
