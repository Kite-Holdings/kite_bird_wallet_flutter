import 'dart:convert';

import 'package:bird_v1/configs/settings.dart';
import 'package:bird_v1/modules/account_module.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionModule extends ChangeNotifier{
  TransactionModule(this.accountModule);
  AccountModule accountModule;
  List<TransactionModel> _transactionModels = [];
  List<WalletActivityModel> _walletActivityModels = [];
  bool isFetching = true;

  set setTransactionModels(List<TransactionModel> object){
    _transactionModels = object;
    notifyListeners();
  }
  set setWalletActivityModels(List<WalletActivityModel> object){
    _walletActivityModels = object;
    notifyListeners();
  }

  set setIsFetching(bool value){
    isFetching = value;
    notifyListeners();
  }

  List<TransactionModel> get transactionModels => _transactionModels;
  List<WalletActivityModel> get walletActivityModels => _walletActivityModels;

  void fetchTransactions()async{
    setIsFetching = true;
    if(accountModule.tokenHasExpired){
      await accountModule.login();
    }
    final Map<String, String> _headers = {
      'Authorization': 'Bearer ${accountModule.token}'
    };

    final http.Response _respnse = await http.get(transactionsUrl, headers: _headers);
    
    if(_respnse.statusCode == 200){
      // save account model
      dynamic _resBody = json.decode(_respnse.body);
      TransactionModel _transactionModel = TransactionModel();
      List<TransactionModel> _trans = [];
      _resBody['body'].forEach((item){
        _trans.add(_transactionModel.fromMap(item));
      });

      setTransactionModels = _trans;


    } else if(_respnse.statusCode == 401){
      accountModule.setTokenTimeStamp = 0;
      
      // logout
    } else{

    }
    setIsFetching = false;
  }
  void fetchWalletActivities()async{
    if(accountModule.tokenHasExpired){
      await accountModule.login();
    }
    final Map<String, String> _headers = {
      'Authorization': 'Bearer ${accountModule.token}'
    };

    final http.Response _respnse = await http.get(walletActivitiesUrl, headers: _headers);
    
    if(_respnse.statusCode == 200){
      // save account model
      dynamic _resBody = json.decode(_respnse.body);
      WalletActivityModel _walletActivityModel = WalletActivityModel();
      List<WalletActivityModel> _activities = [];
      _resBody['body'].forEach((item){
        _activities.add(_walletActivityModel.fromMap(item));
      });

      setWalletActivityModels = _activities;


    } else if(_respnse.statusCode == 401){
      accountModule.setTokenTimeStamp = 0;
      
      // logout
    } else{

    }
  }

  Future<Map<String, dynamic>> mpesaTopupTransaction({String phoneNo, String amount, String walletNo})async{
    bool _successful = false;
    dynamic _resMessage;
    int _status;
    if(walletNo.length >= 8){
      walletNo = '0010${walletNo.substring(walletNo.length -8)}';
    }

    if(phoneNo.length >= 8){
      phoneNo = '2547${phoneNo.substring(phoneNo.length -8)}';
    }

    if(accountModule.tokenHasExpired){
      await accountModule.login();
    }
    
    final Map<String, String> _headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${accountModule.token}'
    };
    final Map<String, String> _payload ={
      "phoneNo": phoneNo,
      "amount": amount,
      "walletNo": walletNo,
      'callBackUrl': "http://18.189.117.13:2027/",
      'transactionDesc': 'Topup'
    };


    try {
      final http.Response _response = await http.post(mpesaToWalletUrl, body: json.encode(_payload), headers: _headers);
      if(_response.statusCode == 200){
        _successful = true;
        _status = 0;
        _resMessage = json.decode(_response.body);


      } else if(_response.statusCode == 400){
        _successful = false;
        _status = 1;
        _resMessage = json.decode(_response.body);

      }
      else if(_response.statusCode == 401){
        _successful = false;
        _status = 1;
        _resMessage = 'error!';

      } else{
        _successful = false;
        _status = 2;
        _resMessage = _response.body;
      }
    } catch (e) {
      _successful = false;
      _status = 3;
      _resMessage = 'cannot reach server';
    }

    return {
      'successful': _successful,
      'status': _status,
      'message': _resMessage
    };
  }

  Future<Map<String, dynamic>> walletToWalletTransaction({String amount, String walletNo})async{
    bool _successful = false;
    dynamic _resMessage;
    int _status;
    if(walletNo.length >= 8){
      walletNo = '0010${walletNo.substring(walletNo.length -8)}';
    }


    if(accountModule.tokenHasExpired){
      await accountModule.login();
    }
    
    final Map<String, String> _headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${accountModule.token}'
    };
    final Map<String, String> _payload ={
      "amount": amount,
      "recipientNo": walletNo,
    };


    try {
      final http.Response _response = await http.post(walletToWalletUrl, body: json.encode(_payload), headers: _headers);
      if(_response.statusCode == 200){
        _successful = true;
        _status = 0;
        _resMessage = json.decode(_response.body);


      } else if(_response.statusCode == 400){
        _successful = false;
        _status = 1;
        _resMessage = json.decode(_response.body);

      }
      else if(_response.statusCode == 401){
        _successful = false;
        _status = 1;
        _resMessage = 'error!';

      } else{
        _successful = false;
        _status = 2;
        _resMessage = _response.body;
      }
    } catch (e) {
      _successful = false;
      _status = 3;
      _resMessage = 'cannot reach server';
    }

    return {
      'successful': _successful,
      'status': _status,
      'message': _resMessage
    };
  }
  

  Future<Map<String, dynamic>> cardTopupTransaction({
    String cardNo, 
    String amount, 
    String walletNo, 
    String year, 
    String month, 
    String cvv, 
    String email,
    })async{

    bool _successful = false;
    dynamic _resMessage;
    int _status;

    if(walletNo.length >= 8){
      walletNo = '0010${walletNo.substring(walletNo.length -8)}';
    }   

    

    if(accountModule.tokenHasExpired){
      await accountModule.login();
    }
    
    final Map<String, String> _headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${accountModule.token}'
    };
    final Map<String, String> _payload ={
      "cardNo": cardNo,
      "amount": amount,
      "walletNo": walletNo,
      'callbackUrl': "http://18.189.117.13:2027/",
      'cvv': cvv,
      'expiryMonth': month,
      'expiryYear': year,
      'email': email,
    };


    try {
      final http.Response _response = await http.post(cardToWalletUrl, body: json.encode(_payload), headers: _headers);
      if(_response.statusCode == 200){
        _successful = true;
        _status = 0;
        _resMessage = json.decode(_response.body);


      } else if(_response.statusCode == 400){
        _successful = false;
        _status = 1;
        _resMessage = json.decode(_response.body);

      }
      else if(_response.statusCode == 401){
        _successful = false;
        _status = 1;
        _resMessage = 'error!';

      } else{
        _successful = false;
        _status = 2;
        _resMessage = _response.body;
      }
    } catch (e) {
      _successful = false;
      _status = 3;
      _resMessage = 'cannot reach server';
    }

    return {
      'successful': _successful,
      'status': _status,
      'message': _resMessage
    };
  }
  

}

class TransactionModel{
  TransactionModel({
    this.id,
    this.amount,
    this.cost,
    this.timeStamp,
    this.recipientNo,
    this.senderNo,
    this.state,
    this.total,
    this.transactionType,
  });

  final String id;
  final String amount;
  final String cost;
  final DateTime timeStamp;
  final String recipientNo;
  final String senderNo;
  final String state;
  final String total;
  final String transactionType;

  TransactionModel fromMap(dynamic object)=> TransactionModel(
    id: object['_id'].toString(),
    amount: object['amount'].toString(),
    cost: object['cost'].toString(),
    timeStamp: DateTime.parse(object['timeStamp'].toString()),
    recipientNo: object['recipientNo'].toString(),
    senderNo: object['senderNo'].toString(),
    state: object['state'].toString(),
    total: object['total'].toString(),
    transactionType: object['transactionType'].toString(),
  );

}

class WalletActivityModel{
  WalletActivityModel({
    this.id,
    this.amount,
    this.balance,
    this.timeStamp,
    this.operation,
    this.secondPartNo,
    this.transactionType,
  });

  final String id;
  final String amount;
  final String balance;
  final DateTime timeStamp;
  final String operation;
  final String secondPartNo;
  final String transactionType;

  WalletActivityModel fromMap(dynamic object)=> WalletActivityModel(
    id: object['_id'].toString(),
    amount: object['amount'].toString(),
    balance: object['balance'].toString(),
    timeStamp: DateTime.parse(object['timeStamp'].toString()),
    operation: object['operation'].toString(),
    secondPartNo: object['secondPartNo'].toString(),
    transactionType: object['transactionType'].toString(),
  );

}