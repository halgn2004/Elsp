import 'package:elsobkypack/models/user_order_details_api.dart';
import 'package:elsobkypack/models/userlogin.dart';

class User {
   int? id;
  String userName;
  String phone;
  bool usersent ;
  bool iscash ;
  List<UserLogin>? userDats;
  List<UserOrderDetails>? userorderdetails;



  User({
    this.id,
    required this.userName,
    required this.phone,
    this.userDats,
   required this.usersent,
    this.userorderdetails,
   required this.iscash
  });


    Map<String, dynamic> toJson() {
    return {
      'UserID':id,
      'UserName': userName,
      'Phone': phone,
      'iscash': iscash,
      'userDataLogins': userDats != null ? userDats!.map((x) => x.toJson()).toList() : [],
      'userOrderDetails': userorderdetails != null ? userorderdetails!.map((x) => x.toJson()).toList() : [],
    };
  }
}