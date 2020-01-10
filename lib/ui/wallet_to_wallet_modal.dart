import 'package:bird_v1/modules/transaction_module.dart';
import 'package:bird_v1/pages/home_page.dart';
import 'package:bird_v1/widgets/custom_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletToWalletModal extends StatefulWidget {
  @override
  _WalletToWalletModalState createState() => _WalletToWalletModalState();
}

class _WalletToWalletModalState extends State<WalletToWalletModal> {
  TextEditingController _amountController;
  TextEditingController _walletNoController;

  bool _amountNull = true;
  bool _walletNoNull = true;

  bool _walletNoError = false;
  bool _amountError = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _walletNoController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _walletNoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
                  ),
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
                      onPressed: (!_walletNoNull && !_amountNull ) ?
                      ()async{
                        setState(() {
                          _isLoading = true;
                        });
                        // transact 
                        final Map<String, dynamic> _resMap = await  transactionModule.walletToWalletTransaction(
                          amount: _amountController.text,
                          walletNo: _walletNoController.text,
                        );

                        
                        setState(() {
                          _isLoading = false;
                        });

                        if(_resMap['status'] == 0){// successful push
                          // Navigate back
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> HomePage()), (Route<dynamic> route) => false);
                        } else if(_resMap['status'] == 1){ // user errors
                        print(_resMap);
                          if(_resMap['message']['status'] == null){
                            _amountError = true;
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