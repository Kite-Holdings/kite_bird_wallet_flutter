import 'package:bird_v1/modules/account_module.dart';
import 'package:bird_v1/modules/transaction_module.dart';
import 'package:bird_v1/pages/web_page.dart';
import 'package:bird_v1/widgets/custom_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardTopupModal extends StatefulWidget {
  @override
  _CardTopupModalState createState() => _CardTopupModalState();
}

class _CardTopupModalState extends State<CardTopupModal> {
  TextEditingController _cardNoController;
  TextEditingController _amountController;
  TextEditingController _walletNoController;
  TextEditingController _monthController;
  TextEditingController _yearController;
  TextEditingController _cvvController;
  TextEditingController _emailController;

  bool _cardNoNull = false;
  bool _amountNull = true;
  bool _walletNoNull = true;
  bool _monthNull = false;
  bool _yearNull = false;
  bool _emailNull = true;
  bool _cvvNull = false;

  bool _cardNoError = false;
  bool _walletNoError = false;
  bool _amountError = false;
  // bool _emailError = false;
  bool _isLoading = false;

  bool _pasetWallet = true;

  @override
  void initState() {
    super.initState();
    _cardNoController = TextEditingController()..text = '4242424242424242';
    _amountController = TextEditingController();
    _walletNoController = TextEditingController();
    _emailController = TextEditingController();
    _monthController = TextEditingController()..text = '01';
    _yearController = TextEditingController()..text = "21";
    _cvvController = TextEditingController()..text = "812";
  }

  @override
  void dispose() {
    _cardNoController.dispose();
    _amountController.dispose();
    _emailController.dispose();
    _walletNoController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final AccountModule accountModule =Provider.of<AccountModule>(context);
    final String _userWalletNo = accountModule.accountModel == null ? null : accountModule.accountModel.wallet.walletNo;
    return Material(
       color: Colors.transparent,
       child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              
              children: <Widget>[
                // CardNo
                TextField( readOnly: true,
                  controller: _cardNoController,
                  keyboardType: TextInputType.number,
                  onChanged: (_text){
                    setState(() {
                      _cardNoNull = _text == '';
                      _cardNoError = false;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Card Number",
                    errorText: _cardNoError ? "* Invalid Card number" : null,
                  ),
                ),
                // dates
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // month
                    Expanded(
                      child: TextField( readOnly: true,
                        controller: _monthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Month",
                        ),
                        onChanged: (_text){
                          setState(() {
                            _monthNull = _text == '';
                          });
                        }
                      ),
                    ),

                    SizedBox(width: 8,),

                    // year
                    Expanded(
                      child: TextField( readOnly: true,
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Year",
                        ),
                        onChanged: (_text){
                          setState(() {
                            _yearNull = _text == '';
                          });
                        }
                      ),
                    ),

                    SizedBox(width: 8,),

                    // cvv
                    Expanded(
                      child: TextField( readOnly: true,
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "CVV",
                        ),
                        onChanged: (_text){
                          setState(() {
                            _cvvNull = _text == '';
                          });
                        },
                      ),
                    ),
                    


                  ],
                ),

                // Amount
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onChanged: (_text){
                    setState(() {
                      _amountNull = _text == '';
                      _amountError = false;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Amount",
                    errorText: _amountError ? "* Amount less than required" : null,
                  ),
                ),
                // wallet
                TextField(
                  controller: _walletNoController,
                  keyboardType: TextInputType.number,
                  onChanged: (_text){
                    setState(() {
                      _walletNoNull = _text == '';
                      _walletNoError = false;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Wallet Number",
                    errorText: _walletNoError ? "* Wallet doesn't exist" : null,
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _pasetWallet = !_pasetWallet;
                          !_pasetWallet ? _walletNoController.text = _userWalletNo : WidgetsBinding.instance.addPostFrameCallback((_) => _walletNoController.clear());
                        });
                      },
                      icon: Icon(_pasetWallet ? Icons.content_paste : Icons.clear),
                    )
                  ),
                ),
                // email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_text){
                    setState(() {
                      _emailNull = _text == '';
                      // _emailError = false;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    errorText: _amountError ? "* Invalid email" : null,
                  ),
                ),
                
                SizedBox(height: 8,),
                Consumer<TransactionModule>(
                  builder: (context, transactionModule, _) {
                    return _isLoading ?
                    SizedBox(
                        height: 90, width: 90,
                        child: FlareActor(
                          "assets/bob.flr", 
                          alignment:Alignment.center, 
                          fit:BoxFit.contain, 
                          animation:"Jump",
                        ),
                      ) :
                    CustomButton(
                      label: 'Submit',
                      width: 110,
                      onPressed: (
                        !_cardNoNull && !_amountNull 
                        && !_walletNoNull && !_cvvNull 
                        && !_emailNull && !_monthNull && !_yearNull
                        ) ?
                      ()async{
                        setState(() {
                          _isLoading = true;
                        });
                        // transact 
                        final Map<String, dynamic> _resMap = await  transactionModule.cardTopupTransaction(
                          cardNo: _cardNoController.text,
                          amount: _amountController.text,
                          walletNo: _walletNoController.text,
                          cvv: _cvvController.text,
                          year: _yearController.text,
                          month: _monthController.text,
                          email: _emailController.text
                        );

                        
                        setState(() {
                          _isLoading = false;
                        });

                        if(_resMap['status'] == 0){// successful push
                        final String _url =_resMap['message']['body']['data']['authurl'].toString();
                          // Navigate back
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> WebPage(_url)));
                        } else if(_resMap['status'] == 1){ // user errors
                        print(_resMap);
                          if(_resMap['message']['status'] == null){
                          
                          } else{
                            if(_resMap['message']['status'] == 101){
                              _walletNoError = true;
                            } 
                            
                          }
                        }
                      } : null,
                    );
                  }
                ),
                
              ],
            ),
          ),
        ),
     );
  }
}