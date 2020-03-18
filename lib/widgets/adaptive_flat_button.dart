import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  AdaptiveFlatButton({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              this.text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: this.onPressed,
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              this.text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: this.onPressed,
          );
  }
}
