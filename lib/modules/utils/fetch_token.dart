import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchToken({String username, String password, String url})async{
  bool _successful = false;
  dynamic _resMessage;
  int _status;
  
  try {
    final String basicAuth = "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    final Map<String, String> _headers = {
      'authorization': basicAuth,
      "Accept": "application/json",
      };
    final http.Response _response = await http.get(url, headers: _headers);

    if(_response.statusCode == 200){
      _successful = true;
      _status = 0;
      _resMessage = json.decode(_response.body);

    } else if(_response.statusCode == 401){
      _successful = false;
      _status = 1;
      _resMessage = 'wrong credentials';

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