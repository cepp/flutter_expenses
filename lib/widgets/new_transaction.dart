import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final Function _addTransaction;

  NewTransaction(this._addTransaction);

  void submitData() {
    final enteredTitle = this.titleController.text;
    final enteredAmount = double.parse(this.amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    this._addTransaction(
      enteredTitle,
      enteredAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: this.titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              onSubmitted: (_) => this.submitData(),
            ),
            TextField(
              controller: this.amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => this.submitData(),
            ),
            FlatButton(
              child: Text('Add Transaction'),
              onPressed: this.submitData,
              textColor: Colors.purple,
            )
          ],
        ),
      ),
    );
  }
}
