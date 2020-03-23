import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: themeData(),
    );
  }

  ThemeData themeData() {
    return ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return this._transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTransaction = new Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      this._transactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(this._addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    this.setState(() {
      this._transactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });
  }

  Widget _switchWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.title,
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
          value: this._showChart,
          onChanged: (val) => this.setState(() => this._showChart = val),
        ),
      ],
    );
  }

  Widget _chartWidget(double bodyHeight, bool isLandscape) {
    return Container(
      height: bodyHeight * (isLandscape ? 0.7 : 0.3),
      child: Chart(this._recentTransactions),
    );
  }

  Widget _transactionWidget(double bodyHeight) {
    return Container(
      height: bodyHeight * 0.7,
      child: TransactionList(this._transactions, this._deleteTransaction),
    );
  }

  List<Widget> _buildLandscapeContent(double bodyHeight) {
    return [
      this._switchWidget(),
      this._showChart
          ? this._chartWidget(bodyHeight, true)
          : this._transactionWidget(bodyHeight)
    ];
  }

  List<Widget> _buildPortraitContent(double bodyHeight) {
    return [
      this._chartWidget(bodyHeight, false),
      this._transactionWidget(bodyHeight)
    ];
  }

  List<Widget> _buildMainContent(double bodyHeight, bool isLandscape) {
    return isLandscape
        ? this._buildLandscapeContent(bodyHeight)
        : this._buildPortraitContent(bodyHeight);
  }

  Widget _buildScaffoldBody(double bodyHeight, bool isLandscape) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: this._buildMainContent(bodyHeight, isLandscape),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final title = const Text(
      'Personal Expenses',
    );

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: title,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => this._startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: title,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => this._startAddNewTransaction(context),
              )
            ],
          );

    final bodyHeight = (mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top);

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: this._buildScaffoldBody(bodyHeight, isLandscape),
          )
        : Scaffold(
            appBar: appBar,
            body: this._buildScaffoldBody(bodyHeight, isLandscape),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => this._startAddNewTransaction(context),
            ),
          );
  }
}
