import 'dart:convert';

import 'package:bird_v1/configs/settings.dart';
import 'package:bird_v1/modules/utils/fetch_corprate_token.dart';
import 'package:bird_v1/modules/utils/fetch_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccountModule extends ChangeNotifier{
  AccountCredentials _accountCredentials;
  String _token;
  int _tokenTimeStamp = 0;
  String _currentPhoneNo;
  AccountModel _accountModel;
  
  set setAccountCredentials(AccountCredentials value){
    _accountCredentials = value;
    notifyListeners();
  }

  set setToken(String value){
    _token = value;
    setTokenTimeStamp = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  set setTokenTimeStamp(int value){
    _tokenTimeStamp = value;
    notifyListeners();
  }

  set setCurrentPhoneNo(String value){
    _currentPhoneNo = value;
    notifyListeners();
  }

  set setAccountModel(AccountModel obj){
    _accountModel = obj;
    setCurrentPhoneNo = _accountModel.phoneNo;
    notifyListeners();
  }

  AccountCredentials get accountCredentials => _accountCredentials;
  String get token => _token;
  bool get tokenHasExpired => _tokeHasExpired();
  String get currentPhoneNo => _currentPhoneNo;
  AccountModel get accountModel => _accountModel;

  bool _tokeHasExpired() => (_tokenTimeStamp + 240 * 100) < DateTime.now().millisecondsSinceEpoch;
  
  Future<Map<String, dynamic>> login()async{
    final Map<String, dynamic> _res =await fetchToken(
      username: _accountCredentials.username, 
      password: _accountCredentials.password, 
      url: loginUrl,
      );
    if(_res['status'] == 0){
      // save token
      setToken = _res['message']['body']['token'];
    } else if(_res['status'] == 1){

    } else{

    }
    return _res;
  }

  Future<Map<String, dynamic>> verifyNo(String phoneNo)async{ 
    bool _successful = false;
    dynamic _resMessage;
    int _status;
    if(phoneNo.length >= 8){
      phoneNo = '2547${phoneNo.substring(phoneNo.length -8)}';
    }
    print(phoneNo);

    final String _corpToken = await corprateToken();
    final Map<String, String> _headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $_corpToken'
    };
    try {
      final http.Response _response = await http.post(verifyNoUrl, body: json.encode({"phoneNo": phoneNo}), headers: _headers);
      if(_response.statusCode == 200){
        _successful = true;
        _status = 0;
        _resMessage = json.decode(_response.body);

        // Set current phonNo
        setCurrentPhoneNo = phoneNo;

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


  Future<Map<String, dynamic>> registerAccount({String phoneNo, String otp, String username, String password})async{ 
    bool _successful = false;
    dynamic _resMessage;
    int _status;

    if(phoneNo.length >= 8){
      phoneNo = '2547${phoneNo.substring(phoneNo.length -8)}';
    }

    final String basicAuth = "Basic ${base64Encode(utf8.encode('$phoneNo:$otp'))}";
    final Map<String, String> _headers = {
      'content-type': 'application/json',
      'authorization': basicAuth
    };
    try {
      final http.Response _response = await http.post(registerUrl, body: json.encode({"username": username, "password": password}), headers: _headers);
      if(_response.statusCode == 200){
        _successful = true;
        _status = 0;
        _resMessage = json.decode(_response.body);

        // Set current phonNo
        setCurrentPhoneNo = phoneNo;

      } else if(_response.statusCode == 400){
        _successful = false;
        _status = 1;
        _resMessage = json.decode(_response.body);

      } else if(_response.statusCode == 401){
        _successful = false;
        _status = 2;
        _resMessage = 'Wrong otp';

      } else{
        _successful = false;
        _status = 3;
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

  void accountDetails()async{
    if(tokenHasExpired){
      await login();
    }
    final Map<String, String> _headers = {
      'Authorization': 'Bearer $_token'
    };

    final http.Response _respnse = await http.get(accountUrl, headers: _headers);
    
    if(_respnse.statusCode == 200){
      // save account model
      dynamic _resBody = json.decode(_respnse.body);
      AccountModel _accountModel = AccountModel();
      setAccountModel = _accountModel.fromMap(_resBody['body']);

    } else if(_respnse.statusCode == 401){
      setTokenTimeStamp = 0;
      // logout
    } else{

    }

  }


}

class AccountCredentials{
  AccountCredentials(this.username, this.password){
    if(username.length >= 8){
      username = '2547${username.substring(username.length -8)}';
    }
  }
  String username;
  String password;
}

class AccountModel{
  AccountModel({
    this.id,
    this.accountType,
    this.cooprateCode,
    this.phoneNo,
    this.username,
    this.wallet,
    this.received,
    this.sent,
  });

  final String id;
  final String accountType;
  final String phoneNo;
  final String username;
  final String cooprateCode;
  final WalletModel wallet;
  final String received;
  final String sent;

  AccountModel fromMap(dynamic object) {
    final WalletModel _walletModel = WalletModel();
    return AccountModel(
      id: object['_id'].toString(),
      accountType: object['accountType'].toString(),
      phoneNo: object['phoneNo'].toString(),
      username: object['_id'].toString(),
      cooprateCode: object['cooprateCode'].toString(),
      received: object['received'].toString(),
      sent: object['sent'].toString(),
      wallet: _walletModel.fromMap(object['wallet'][0])
    );
  }
}

class WalletModel{
  WalletModel({
    this.id,
    this.balance,
    this.walletNo
  });

  final String id;
  final double balance;
  final String walletNo;

  WalletModel fromMap(dynamic object) => WalletModel(
    id: object['_id'].toString(),
    balance: double.parse(object['balance'].toString()),
    walletNo: object['walletNo'].toString()
  );
}