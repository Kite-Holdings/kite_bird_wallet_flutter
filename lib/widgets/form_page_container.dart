import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class FormPageContainer extends StatelessWidget {
  FormPageContainer({
    this.animation = 'Dance',
    this.flare = 'assets/bob.flr',
    this.body,
  });
  final String flare;
  final String animation;
  final Widget body;

   @override
   Widget build(BuildContext context) {

     return Scaffold(
       backgroundColor: Color.fromRGBO(27, 20, 100,1.0),
       body: Stack(
         children: <Widget>[
           Center(
             child: SizedBox(
                height: MediaQuery.of(context).size.height * .8,
                child: FlareActor(
                    flare, 
                    alignment:Alignment.bottomCenter, 
                    fit:BoxFit.cover, 
                    animation: animation,
                  ),
              ),
           ),
           Align(
             alignment: Alignment.bottomCenter,
             child: body
           )
         ],
       ),
     );
   }
 }