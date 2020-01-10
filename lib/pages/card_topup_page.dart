import 'package:bird_v1/ui/card_topup_modal.dart';
import 'package:bird_v1/widgets/form_page_container.dart';
import 'package:flutter/material.dart';

class CardTopupPage extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return FormPageContainer(animation: 'Stand',body: CardTopupModal(),);
   }
 }