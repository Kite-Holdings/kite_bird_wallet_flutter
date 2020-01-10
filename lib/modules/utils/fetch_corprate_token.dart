import 'package:bird_v1/configs/settings.dart';
import 'package:bird_v1/modules/utils/fetch_token.dart';

Future<String> corprateToken()async{
  String _token;
  final Map<String, dynamic> _res =await fetchToken(
    username: corprateKey, 
    password: corprateSecrete, 
    url: corprateTokenUrl,
    );
  if(_res['status'] == 0){
    _token = _res['message']['body']['token'];
  } else if(_res['status'] == 1){

  } else{
    
  }
  return _token;
  }