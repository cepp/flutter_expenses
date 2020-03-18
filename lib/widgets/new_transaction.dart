import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function _addTransaction;

  NewTransaction(this._addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (this._amountController.text == null ||
        this._amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = this._titleController.text;
    final enteredAmount = double.parse(this._amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        this._selectedDate == null) {
      return;
    }

    this.widget._addTransaction(
          enteredTitle,
          enteredAmount,
          this._selectedDate,
        );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: this.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      this.setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: this._titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                onSubmitted: (_) => this._submitData(),
              ),
              TextField(
                controller: this._amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => this._submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(this._selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMMMd().format(this._selectedDate)}'),
                    ),
                    AdaptiveFlatButton(
                      onPressed: this._presentDatePicker,
                      text: 'Choose Date',
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                onPressed: this._submitData,
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
