import 'package:bird_v1/ui/transaction_page_body.dart';
import 'package:bird_v1/ui/transaction_page_head.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Contains two sections 1). Cumulative 2). transactions
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Cumulative
          TransactionPageHead(),

          // Transactions
          Expanded(child: TransactionPageBody())
        ],
      ),
    );
  }
}