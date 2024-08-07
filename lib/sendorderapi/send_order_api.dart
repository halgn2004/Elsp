import 'dart:convert';
import 'package:elsobkypack/websitw/strings.dart';
import 'package:http/http.dart' as http;
import 'package:elsobkypack/models/user.dart';

class SendOrderApi {
static Future<int> sendUserToServer(User user) async {
   
    try {
      String baseUrl =
          '${MostStrings.url}/app/AppApi/MakeOrder';
      String username = '11179567';
      String password = '60-dayfreetrial';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';        
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': basicAuth,
        },
        
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {  
        final data = jsonDecode(response.body);       
        return data;        
      }
      return -1;
    } catch (e) {     
     return -1;
    }
  }
}