 
 import 'package:bird_v1/ui/register_account_modal.dart';
import 'package:bird_v1/widgets/form_page_container.dart';
import 'package:flutter/material.dart';

class RegisterAccountPage extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return FormPageContainer(animation: 'Dance',body: RegisterAccountModal(),);

   }
 }
