import 'package:bird_v1/modules/account_module.dart';
import 'package:bird_v1/modules/transaction_module.dart';
import 'package:bird_v1/pages/home_page.dart';
import 'package:bird_v1/widgets/custom_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MpesaTopupModal extends StatefulWidget {
  @override
  _MpesaTopupModalState createState() => _MpesaTopupModalState();
}

class _MpesaTopupModalState extends State<MpesaTopupModal> {
  TextEditingController _phoneNoController;
  TextEditingController _amountController;
  TextEditingController _walletNoController;

  bool _phoneNoNull = true;
  bool _amountNull = true;
  bool _walletNoNull = true;

  bool _phoneNoError = false;
  bool _walletNoError = false;
  bool _amountError = false;
  bool _isLoading = false;
  bool _pasetNo = true;
  bool _pasetWallet = true;

  @override
  void initState() {
    super.initState();
    _phoneNoController = TextEditingController();
    _amountController = TextEditingController();
    _walletNoController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNoController.dispose();
    _amountController.dispose();
    _walletNoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final AccountModule accountModule =Provider.of<AccountModule>(context);
    final String _userPhoneNo = accountModule.accountModel == null ? null : accountModule.accountModel.phoneNo;
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
                // PhoneNo
                TextField(
                  controller: _phoneNoController,
                  keyboardType: TextInputType.number,
                  onChanged: (_text){
                    setState(() {
                      _phoneNoNull = _text == '';
                      _phoneNoError = false;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Phone Number (from)",
                    errorText: _phoneNoError ? "* Invalid Phone number" : null,
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _pasetNo = !_pasetNo;
                          !_pasetNo ? _phoneNoController.text = _userPhoneNo : WidgetsBinding.instance.addPostFrameCallback((_) => _phoneNoController.clear());
                        });
                      },
                      icon: Icon(_pasetNo ? Icons.content_paste : Icons.clear),
                    )
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
                    labelText: "Wallet Number (to)",
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
                      onPressed: (!_phoneNoNull && !_amountNull && !_walletNoNull) ?
                      ()async{
                        setState(() {
                          _isLoading = true;
                        });

                        // transact 
                        final Map<String, dynamic> _resMap = await  transactionModule.mpesaTopupTransaction(
                          phoneNo: _phoneNoController.text,
                          amount: _amountController.text,
                          walletNo: _walletNoController.text
                        );
                        
                        setState(() {
                          _isLoading = false;
                        });

                        if(_resMap['status'] == 0){// successful push
                          // Navigate back
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> HomePage()), (Route<dynamic> route) => false);
                        } else if(_resMap['status'] == 1){ // user errors
                          if(_resMap['message']['status'] == null){
                          final String _error = _resMap['message']['reasons'].toString().split("'")[1];
                            if(_error == 'amount'){
                              setState(() {
                                _amountError = true;
                              });
                            }
                            if(_error == 'phoneNo'){
                              setState(() {
                                _phoneNoError = true;
                              });
                            }
                          } else{
                            if(_resMap['message']['status'] == 101){
                              _walletNoError = true;
                            } else if(_resMap['message']['status'] == 2){
                              showDialog(
                                context: context,
                                child: SimpleDialog(
                                  title: Container(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    decoration: BoxDecoration(
                                      border: Border(top: BorderSide(width: 2, color: Colors.redAccent))
                                    ),
                                    child: Center(
                                      child: Text(
                                        'A similar transactions is being processed'
                                      ),
                                    ),
                                  ),
                                )
                              );
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