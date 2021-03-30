
import 'package:trans/api/connector/Connector.dart';
import 'package:trans/api/result/Error.dart';
class Result<T>{
  int code;
  Error error;
  T data;

  bool isOtherError(){
    if(code != ConnectorConstants.OK
        && code != ConnectorConstants.CREATED
        && code != ConnectorConstants.ACCEPTED
        && code != ConnectorConstants.NO_INTERNET
        && code != ConnectorConstants.EXPIRE ){
      return true;
    }
    return false;
  }


  bool isSuccess(){
    if(code == ConnectorConstants.OK){
      return true;
    }
    return false;
  }

  bool isNoInternet(){
    if(code == ConnectorConstants.NO_INTERNET){
      return true;
    }
    return false;
  }

  bool isNoAuthentication(){
    if(code == ConnectorConstants.EXPIRE){
      return true;
    }
    return false;
  }
  @override
  String toString() {
    return 'Code $code, message $error, data $data';
  }
}