import 'package:bird_v1/modules/account_module.dart';
import 'package:bird_v1/modules/transaction_module.dart';
import 'package:bird_v1/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  AccountModule accountModule = AccountModule();
  return  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: accountModule,),
        ChangeNotifierProvider.value(value: TransactionModule(accountModule),),
      ],
      child: MaterialApp(
        home: LandingPage(),
      ),
    )
  );
}



