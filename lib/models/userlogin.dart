class UserLogin {
  int? loginID;
  DateTime? logindate ;
  bool? loginsent ;

  UserLogin({this.loginID,  this.logindate,  this.loginsent});

  Map<String, dynamic> toJson() {
    return {      
      'date_': (logindate!.toIso8601String()),      
    };
  }
}