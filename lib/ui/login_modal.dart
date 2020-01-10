
import 'package:bird_v1/modules/account_module.dart';
import 'package:bird_v1/pages/home_page.dart';
import 'package:bird_v1/widgets/custom_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginModal extends StatefulWidget {
   @override
   _LoginModalState createState() => _LoginModalState();
 }
 
 class _LoginModalState extends State<LoginModal> {
   TextEditingController _phoneNoController;
   TextEditingController _passwordController;
   bool _obscurePassword = true;

   bool _phoneNoNull = true;
   bool _passwordNull = true;

   bool _phoneNoError = false;
   bool _passwordError = false;
   bool _isLoading = false;

   @override
  void initState() {
    super.initState();
    _phoneNoController = TextEditingController();
    _passwordController = TextEditingController();
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
                  errorText: _phoneNoError ? "* Wrong phone number" : null,
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (_text){
                  setState(() {
                    _passwordNull = _text == '';
                    _passwordError = false;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _passwordError ? "* Wrong password" : null,
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(!_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  )
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
                    label: 'Login',
                    width: 140,
                    onPressed: (!_phoneNoNull && !_passwordNull) ?
                    ()async{
                      setState(() {
                        _isLoading = true;
                      });
                      accountModule.setAccountCredentials = AccountCredentials(_phoneNoController.text, _passwordController.text);
                      final Map<String, dynamic> _loginRes = await accountModule.login();

                      setState(() {
                        _isLoading = false;
                      });
                      if(_loginRes['status'] == 0){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomePage()));
                        
                      } else if(_loginRes['status'] == 1){
                        _passwordError = true;
                        _phoneNoError = true;
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