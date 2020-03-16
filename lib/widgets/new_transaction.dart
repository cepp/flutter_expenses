import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final Function _addTransaction;

  NewTransaction(this._addTransaction);

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
            ),
            TextField(
              controller: this.amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            FlatButton(
              child: Text('Add Transaction'),
              onPressed: () => this._addTransaction(
                this.titleController.text,
                double.parse(this.amountController.text),
              ),
              textColor: Colors.purple,
            )
          ],
        ),
      ),
    );
  }
}
