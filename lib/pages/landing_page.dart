import 'package:bird_v1/pages/login_page.dart';
import 'package:bird_v1/pages/verify_phoneno_page.dart';
import 'package:bird_v1/widgets/custom_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(27, 20, 100,1.0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Stack(
          children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: FlareActor(
                  "assets/bob.flr", 
                  alignment:Alignment.bottomCenter, 
                  fit:BoxFit.cover, 
                  animation:"Wave",
                ),
            ),
          ),


            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomButton(
                    label: "Sign Up Now",
                    width: MediaQuery.of(context).size.width * .75,
                    height: 55,
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> VerifyPhoneNoPage()));
                    },
                  ),
                  SizedBox(height: 10,),
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
                    },
                    child: Text(
                      'Already a member? Log in',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}