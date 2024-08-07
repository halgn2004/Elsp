import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:elsobkypack/database/database_helper.dart';
import 'package:elsobkypack/websitw/strings.dart';

class Chekhistory {
  final String baseUrl = '${MostStrings.url}/app/AppApi/Checkifdone';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  Future<void> chekhistory() async {
    List<int> uncheckedIds = await databaseHelper.getUncheckedHistoryIds();
    if (uncheckedIds.isNotEmpty) {
      String username = '11179567';
      String password = '60-dayfreetrial';
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      try {
        final response = await http.post(Uri.parse(baseUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'authorization': basicAuth,
            },
            body: jsonEncode(uncheckedIds));
        if (response.statusCode == 201) {
          final List<dynamic> responseBody = jsonDecode(response.body);
          List<int> ids = responseBody.cast<int>();

          // استدعاء الدالة لتحديث الحقول في قاعدة البيانات
          await DatabaseHelper.instance.updateCheckToTrue(ids);
        } else {}
      } catch (e) {
        rethrow;
      }
    }
  }
}
