import 'package:flutter/material.dart';

class TransactionPageHeadTotalsItem extends StatelessWidget {

  TransactionPageHeadTotalsItem({
    this.label,
    this.value
  });

  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Label/key
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
        // value
        Text(
          value,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}