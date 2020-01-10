import 'package:bird_v1/widgets/form_page_container.dart';
import 'package:flutter/material.dart';

class SoonPage extends StatefulWidget {
  @override
  _SoonPageState createState() => _SoonPageState();
}

class _SoonPageState extends State<SoonPage> {
  String _animation = 'Stand';
   @override
   Widget build(BuildContext context) {
     return FormPageContainer(animation: _animation, body: Align(
       alignment: Alignment.bottomCenter,
       child: InkWell(
         onTap: (){
         setState(() {
           if(_animation == 'Stand'){
             _animation = 'Jump';
           } else if(_animation == 'Jump'){
             _animation = 'Wave';
           } else if(_animation == 'Wave'){
             _animation = 'Dance';
           } else{
             _animation = 'Stand';
           }
         });
       },
         child: Container(
           height: MediaQuery.of(context).size.height,
           padding: const EdgeInsets.only(bottom: 80),
           child: Align(
             alignment: Alignment.bottomCenter,
             child: Text(
               "Coming soon...",
               style: TextStyle(
                 color: Colors.white,
                 fontStyle: FontStyle.italic,
                 fontSize: 30
               ),
             ),
           ),
         ),
       ),
     ),);
   }
}