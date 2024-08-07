import 'dart:convert';
import 'package:elsobkypack/main.dart';
import 'package:elsobkypack/models/android_update.dart';
import 'package:elsobkypack/models/main_prod.dart';

import 'package:elsobkypack/websitw/strings.dart';

import 'package:http/http.dart' as http;
import '../database/database_helper.dart';

class Chekfile {

Future<String> checkUpdateData() async {
    final dbHelper = DatabaseHelper.instance;

    // إذا لم يكن هناك اتصال بالإنترنت، قم بجلب البيانات من قاعدة البيانات المحلية

    // إذا كان هناك اتصال بالإنترنت، حاول جلب البيانات من الـ API
    try {
      String baseUrl = '${MostStrings.url}/app/AppApi/updateAppStore';
      String username = '11179567';
      String password = '60-dayfreetrial';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: <String, String>{'authorization': basicAuth},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);  
        final appvirsionId = data['appvirsionId'] as int;
        if (appvirsionId != 1) {
          return data['appvirsionName'] as String;
        }
        
        final serverUpdate = AndroidUpdate.fromJson(data['android_update']);
        final AndroidUpdate? localUpdate = await dbHelper.fetchAndroidUpdate();
        if (localUpdate == null || localUpdate.date != serverUpdate.date) {
        await  checkAndUpdateData();
        }

      }
      return '';   
    } catch (e) {
      return '';
    }
  }



  Future<void> checkAndUpdateData() async {
    final dbHelper = DatabaseHelper.instance;

    // إذا لم يكن هناك اتصال بالإنترنت، قم بجلب البيانات من قاعدة البيانات المحلية

    // إذا كان هناك اتصال بالإنترنت، حاول جلب البيانات من الـ API
    try {
      String baseUrl = '${MostStrings.url}/app/AppApi/GetAndroid_API';
      String username = '11179567';
      String password = '60-dayfreetrial';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: <String, String>{'authorization': basicAuth},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final serverUpdate = AndroidUpdate.fromJson(data['android_update']);
        final AndroidUpdate? localUpdate = await dbHelper.fetchAndroidUpdate();

        if (localUpdate == null || localUpdate.date != serverUpdate.date) {
          await dbHelper.clearDatabase();
          await dbHelper.insertAndroidUpdate(serverUpdate);

          for (var mainProdJson in data['MainProds']) {
            final mainProd = MainProd.fromJson(mainProdJson);
            await dbHelper.insertMainProd(mainProd);

            // Save images locally
            await dbHelper.saveImage(mainProd.img);
            for (var product in mainProd.products) {
              await dbHelper.saveImage(product.img);
            }
          }

          // Save main images
          for (var imageUrl in data['MainImges']) {
            await dbHelper.insertMainImage(imageUrl);
            await dbHelper.saveImage(imageUrl);
          }
        }
        //MyApp();
      } else {
        // إذا كان هناك مشكلة في الاتصال بالإنترنت، جلب البيانات من قاعدة البيانات المحلية
        //  _fetchDataFromLocalDB();
      }
    } catch (e) {
      // print("Error fetching data: $e");
      // إذا كان هناك مشكلة في الاتصال بالإنترنت، جلب البيانات من قاعدة البيانات المحلية
      //   _fetchDataFromLocalDB();
    }
  }




Future<bool> checkBeForPay(context) async {
    final dbHelper = DatabaseHelper.instance;

    // إذا لم يكن هناك اتصال بالإنترنت، قم بجلب البيانات من قاعدة البيانات المحلية

    // إذا كان هناك اتصال بالإنترنت، حاول جلب البيانات من الـ API
    try {
      String baseUrl = '${MostStrings.url}/app/AppApi/updateAppStore';
      String username = '11179567';
      String password = '60-dayfreetrial';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: <String, String>{'authorization': basicAuth},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);  
        final appvirsionId = data['appvirsionId'] as int;
        if (appvirsionId != 1) {          
           UpdateScreen(message: data['appvirsionName'] as String).build(context);
        }
        
        final serverUpdate = AndroidUpdate.fromJson(data['android_update']);
        final AndroidUpdate? localUpdate = await dbHelper.fetchAndroidUpdate();
        if (localUpdate == null || localUpdate.date != serverUpdate.date) {
        await checkAndUpdateData();  
        return true;      
        }

      }
    return false;
     
    // ignore: empty_catches
    } catch (e) {
     return false;
    }
  }







  

}
