import 'package:expenses_tracker/model/new_expense.dart';
import 'package:expenses_tracker/widget/chart/chart.dart';
import 'package:expenses_tracker/widget/expenses_list/expenses_list.dart';
import 'package:expenses_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Cousred",
        amount: 19.54,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinem",
        amount: 15,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(
      () {
        _registeredExpenses.add(expense);
      },
    );
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(
      () {
        _registeredExpenses.remove(expense);
      },
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  final width =  MediaQuery.of(context).size.width;
    // print(MediaQuery.of(context).size.height);

    Widget mainContent = const Center(
      child: Text("No expense. Start adding expense"),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600 ?
      Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ): 
      Row(
        children: [
         Expanded (child: Chart(expenses: _registeredExpenses),),
          Expanded(
            child: mainContent,
          ),
      ],),
    );
  }
}
