import 'package:bird_v1/ui/wallet_to_wallet_modal.dart';
import 'package:bird_v1/widgets/form_page_container.dart';
import 'package:flutter/material.dart';

class WalletToWallet extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return FormPageContainer(animation: 'Dance',body: WalletToWalletModal(),);
   }
 }