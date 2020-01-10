import 'package:bird_v1/modules/account_module.dart';
import 'package:bird_v1/pages/home_page.dart';
import 'package:bird_v1/pages/login_page.dart';
import 'package:bird_v1/widgets/custom_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterAccountModal extends StatefulWidget {
   @override
   _RegisterAccountModalState createState() => _RegisterAccountModalState();
 }
 
 class _RegisterAccountModalState extends State<RegisterAccountModal> {
   TextEditingController _usernameController;
   TextEditingController _otpController;
   TextEditingController _passwordController;
   bool _obscurePassword = true;

   bool _usernameNull = true;
   bool _otpNull = true;
   bool _passwordNull = true;

   bool _phoneNoError = false;
   bool _otpError = false;
   bool _passwordError = false;
   bool _isLoading = false;

   @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _otpController = TextEditingController();
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
                controller: _otpController,
                keyboardType: TextInputType.number,
                onChanged: (_text){
                  setState(() {
                    _otpNull = _text == '';
                    _otpError = false;
                  });
                },
                decoration: InputDecoration(
                  labelText: "OTP",
                  errorText: _otpError ? "* Invalid OTP" : null,
                ),
              ),
              TextField(
                controller: _usernameController,
                onChanged: (_text){
                  setState(() {
                    _usernameNull = _text == '';
                  });
                },
                decoration: InputDecoration(
                  labelText: "Username",
                  errorText: _phoneNoError ? "* Invalid username" : null,
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (_text){
                  setState(() {
                    _passwordNull = _text == '';
                  });
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _passwordError ? "* Weak password" : null,
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
                    label: 'Register',
                    width: 130,
                    onPressed: (!_usernameNull && !_passwordNull && !_otpNull) ?
                    ()async{
                      setState(() {
                        _isLoading = true;
                      });

                      final Map<String, dynamic> _registerRes = await accountModule.registerAccount(
                        phoneNo: accountModule.currentPhoneNo,
                        password: _passwordController.text,
                        otp: _otpController.text,
                        username: _usernameController.text
                      );
                      setState(() {
                        _isLoading = false;
                      });

                      if(_registerRes['status'] == 0){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> HomePage()), (Route<dynamic> route) => false);
                      } else if(_registerRes['status'] == 1){
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context){
                            return Container(
                              // height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                border: Border(top: BorderSide(
                                  width: 8,
                                  color: Colors.redAccent
                                )),
                                // borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Account Exist!',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          "Forgoten password",
                                          style: TextStyle(
                                            color: Color.fromRGBO(72, 52, 212,1.0)
                                          ),
                                        ),
                                        onPressed: (){},
                                      ),
                                      RaisedButton(
                                        color: Color.fromRGBO(27, 20, 100,1.0),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14
                                          ),
                                        ),
                                        onPressed: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
                                        },
                                      )
                                    ],
                                  )
                                ],
                              )
                            );
                          }
                        );
                      } else if(_registerRes['status'] == 2){
                        _otpError = true;
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
