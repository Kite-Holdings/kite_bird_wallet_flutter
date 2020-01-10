import 'package:bird_v1/modules/account_module.dart';
import 'package:bird_v1/modules/transaction_module.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionPageBody extends StatefulWidget {
  @override
  _TransactionPageBodyState createState() => _TransactionPageBodyState();
}

class _TransactionPageBodyState extends State<TransactionPageBody> {
  TransactionModule transactionModule;
  AccountModule accountModule;

  TransactionTypeItem _transactionTypeItem(String type){
    switch (type) {
      case 'cardToWallet':
        return TransactionTypeItem(TransactionType.card);
        break;
      case 'mpesaCb':
        return TransactionTypeItem(TransactionType.mobile);
        break;
      case 'walletTowallet':
        return TransactionTypeItem(TransactionType.wallet);
        break;
      default:
        return TransactionTypeItem(TransactionType.nonDefined);
    }
  }

  String formartDate(String value){
    DateTime _date = DateTime.parse(value);
    return DateTime(
      _date.year, 
      _date.month, 
      _date.day, 
      _date.hour+3, 
      _date.minute,
      _date.second,
      ).toString().split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    transactionModule = Provider.of<TransactionModule>(context);
    accountModule = Provider.of<AccountModule>(context);
    bool isFetching = transactionModule.isFetching;
    String _walletNo = accountModule.accountModel != null ? accountModule.accountModel.wallet.walletNo : null;
    List<TransactionModel> transactions = transactionModule.transactionModels;
    return Material(
      color: Color.fromRGBO(27, 20, 100,1.0),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Title
            Text(
              'Transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 5,),

            // List of transactions
            Expanded(
              child: isFetching ? 
              SizedBox(
                height: 300, width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: FlareActor(
                        "assets/bob.flr", 
                        alignment:Alignment.center, 
                        fit:BoxFit.contain, 
                        animation:"Jump",
                      ),
                    ),
                    Text(
                      'Fetching your data ...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    SizedBox(height: 40,)
                  ],
                ),
              ) :
              ListView.builder(
                padding: EdgeInsets.only(top: 5),
                itemCount: transactions.length,
                itemBuilder: (BuildContext context, int index){
                  return Card(
                    color: Colors.white10,
                    elevation: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          right: BorderSide(
                            color: (transactions[index].recipientNo == _walletNo) ? Color.fromRGBO(46, 213, 115,1.0) : Color.fromRGBO(255, 71, 87,1.0),
                            width: 5
                          )
                        ),
                      ),
                      child: ListTile(
                        // user dp
                        leading: CircleAvatar(
                          backgroundColor: _transactionTypeItem(transactions[index].transactionType).color,
                          child: Icon(_transactionTypeItem(transactions[index].transactionType).iconData),
                        ),

                        // username / email
                        title: Text(
                          transactions[index].recipientNo == _walletNo ? 'From' : 'To',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),

                        // user wallet number & date
                        subtitle: Text(
                          transactions[index].senderNo == _walletNo 
                          ? transactions[index].recipientNo 
                          : transactions[index].senderNo,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13
                          ),
                        ),

                        // Amount
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Ksh. ${transactions[index].amount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              formartDate(transactions[index].timeStamp.toString()),
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                backgroundColor: Color.fromRGBO(27, 20, 100,.9),
                                title: Center(child: Text("Transaction Details", style: TextStyle(color: Colors.white),)),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      tile(
                                        transactions[index].recipientNo == _walletNo ? 'From' : 'To', 
                                        transactions[index].senderNo,
                                      ),
                                      tile('Amount', transactions[index].amount),
                                      tile('Cost', transactions[index].cost),
                                      tile('Date', formartDate(transactions[index].timeStamp.toString())),
                                      tile('Transaction type', transactions[index].transactionType),
                                      tile('Transaction state', transactions[index].state),
                                    ],
                                  ),
                                ),
                              );
                            }
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget tile(String head, String body){
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        head,
        style: TextStyle(
          color: Colors.white70
        ),
      ),
      Text(
        body,
        style: TextStyle(
          color: Colors.white
        ),
      ),
      Divider(thickness: 1.5,  color: Colors.white38,)
      
    ],
  );
}


class TransactionTypeItem{
  TransactionTypeItem(this.transactionType){
    switch (transactionType) {
      case TransactionType.card:
        iconData = Icons.credit_card;
        color = Colors.purpleAccent;
        break;
      case TransactionType.mobile:
        iconData = Icons.dock;
        color = Colors.limeAccent;
        break;
      case TransactionType.wallet:
        iconData = Icons.account_balance_wallet;
        color = Colors.indigoAccent;
        break;
      default:
        iconData = Icons.flare;
        color = Colors.blueGrey;
    }
  }
  final TransactionType transactionType;
  IconData iconData;
  Color color;
}

enum TransactionType{
  card,
  mobile,
  wallet,
  nonDefined
}