
 import 'package:bird_v1/modules/account_module.dart';
import 'package:bird_v1/pages/register_account_page.dart';
import 'package:bird_v1/widgets/custom_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhoneNoModal extends StatefulWidget {
   @override
   _VerifyPhoneNoModalState createState() => _VerifyPhoneNoModalState();
 }
 
 class _VerifyPhoneNoModalState extends State<VerifyPhoneNoModal> {
   TextEditingController _phoneNoController;

   bool _phoneNoNull = true;

   bool _phoneNoError = false;

   bool _isLoading = false;

   @override
  void initState() {
    super.initState();
    _phoneNoController = TextEditingController();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            
            children: <Widget>[
              TextField(
                controller: _phoneNoController,
                keyboardType: TextInputType.phone,
                onChanged: (_text){
                  setState(() {
                    _phoneNoNull = _text == '';
                    _phoneNoError = false;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  errorText: _phoneNoError ? "* Invalid phone number" : null,
                ),
              ),
              
              SizedBox(height: 8,),
              Consumer<AccountModule>(
                builder: (context, accountModule, _) {
                  return _isLoading ?
                  SizedBox(
                      height: 90, width: 90,
                      child: FlareActor(
                        "assets/bob.flr", 
                        alignment:Alignment.center, 
                        fit:BoxFit.contain, 
                        animation:"Dance",
                      ),
                    ) :
                  CustomButton(
                    label: 'Verify',
                    width: 110,
                    onPressed: (!_phoneNoNull) ?
                    ()async{
                      setState(() {
                        _isLoading = true;
                      });

                      final Map<String, dynamic> _verifyRes = await accountModule.verifyNo(_phoneNoController.text);

                      setState(() {
                        _isLoading = false;
                      });
                      
                      if(_verifyRes['status'] == 0){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterAccountPage()));
                      } else if(_verifyRes['status'] == 1){
                        setState(() {
                          _phoneNoError = true;
                        });
                      }
                    } : null,
                  );
                }
              ),
              
            ],
          ),
        ),
     );
   }
 }
