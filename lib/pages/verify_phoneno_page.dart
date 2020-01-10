import 'package:bird_v1/ui/verify_phoneno_modal.dart';
import 'package:bird_v1/widgets/form_page_container.dart';
import 'package:flutter/material.dart';

class VerifyPhoneNoPage extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return FormPageContainer(animation: 'Dance',body: VerifyPhoneNoModal(),);
   }
 }