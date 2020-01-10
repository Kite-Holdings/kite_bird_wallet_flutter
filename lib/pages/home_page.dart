import 'package:bird_v1/modules/account_module.dart';
import 'package:bird_v1/modules/transaction_module.dart';
import 'package:bird_v1/pages/card_topup_page.dart';
import 'package:bird_v1/pages/mpesa_topup_page.dart';
import 'package:bird_v1/pages/soon_page.dart';
import 'package:bird_v1/pages/transaction_page.dart';
import 'package:bird_v1/pages/wallet_to_wallet.dart';
import 'package:bird_v1/widgets/circular_tiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _calcHeight(double h){
      return h * MediaQuery.of(context).size.height / 600;
    }
    double _calcWidth(double w){
      return w * MediaQuery.of(context).size.width / 360;
    }
    return Material(
      color: Color.fromRGBO(27, 20, 100,1.0),
      child: Stack(
        children: <Widget>[
          // Transactions
          Positioned(
            top: _calcHeight(20),
            left: _calcWidth(10),
            child: CircularTiles(
              label: 'Transactions', 
              radius: _calcHeight(180), 
              color: Color.fromRGBO(22, 160, 133,1.0),
              icon: Icons.blur_on,
              onPressed: (){
                AccountModule accountModule = Provider.of<AccountModule>(context);
                accountModule.accountDetails();
                TransactionModule transactionModule = Provider.of<TransactionModule>(context);
                transactionModule.fetchTransactions();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TransactionPage()));
              },
              ),
          ),
          // Wallet to wallet
          Positioned(
            top: _calcHeight(160),
            right: _calcWidth(15),
            child: CircularTiles(
              label: 'Send to Wallet', 
              radius: _calcHeight(160), 
              color: Color.fromRGBO(142, 68, 173,1.0),
              icon: Icons.account_balance_wallet,
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> WalletToWallet()));
              },
              ),
          ),
          // Topup
          Positioned(
            top: _calcHeight(30),
            right: _calcWidth(15),
            child: CircularTiles(
              label: 'Top Up', 
              radius: _calcHeight(120), 
              color: Color.fromRGBO(211, 84, 0,1.0),
              icon: Icons.attach_money,
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Material(
                        color: Colors.transparent,
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: Container(),
                            ),
                            // Mpesa
                            PaymentOptionItem(
                              label: 'Mpesa',
                              position: 0,
                              onPressed: (){
                                AccountModule accountModule = Provider.of<AccountModule>(context);
                                accountModule.accountDetails();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MpesaTopupPage()));
                              },
                            ),
                            // Card
                            PaymentOptionItem(
                              label: 'Card',
                              position: 1,
                              onPressed: (){
                                AccountModule accountModule = Provider.of<AccountModule>(context);
                                accountModule.accountDetails();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CardTopupPage()));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TransactionPage()));
              },
              ),
          ),
          // Wallet to bank
          Positioned(
            top: _calcHeight(210),
            left: _calcWidth(15),
            child: CircularTiles(
              label: 'Send to Bank', 
              radius: _calcHeight(160), 
              color: Color.fromRGBO(190, 46, 221,1.0),
              icon: Icons.account_balance,
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SoonPage()));
              },
              ),
          ),
          // Wallet to mpesa
          Positioned(
            bottom: _calcHeight(40),
            left: _calcWidth(20),
            child: CircularTiles(
              label: 'Send to Mpesa', 
              radius: _calcHeight(150), 
              color: Color.fromRGBO(112, 111, 211,1.0),
              icon: Icons.add_to_home_screen,
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SoonPage()));
              },
              ),
          ),
          // Wallet to Billers
          Positioned(
            bottom: _calcHeight(160),
            right: _calcWidth(85),
            child: CircularTiles(
              label: 'Billers', 
              radius: _calcHeight(120), 
              color: Color.fromRGBO(255, 107, 129,1.0),
              icon: Icons.sort,
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SoonPage()));
              },
              ),
          ),
          // Accounts
          Positioned(
            bottom: _calcHeight(10),
            right: _calcWidth(15),
            child: CircularTiles(
              label: 'Account', 
              radius: _calcHeight(150), 
              color: Color.fromRGBO(0, 148, 50,1.0),
              icon: Icons.group_work,
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SoonPage()));
              },
              ),
          ),
          
        ],
      ),
    );
  }
}

class PaymentOptionItem extends StatelessWidget {
  PaymentOptionItem({this.label, this.onPressed, this.position});
  final Function onPressed;
  final int position;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.0 +  position * 70,
      right: 100.0,
      child: Transform.rotate(
        angle: -.5 * position,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(190, 46, 221,1.0),
                Color.fromRGBO(83, 82, 237,1.0),
              ]
            ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
