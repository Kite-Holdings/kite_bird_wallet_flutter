 import 'package:bird_v1/ui/login_modal.dart';
import 'package:bird_v1/widgets/form_page_container.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return FormPageContainer(animation: 'Stand',body: LoginModal(),);
   }
 }
