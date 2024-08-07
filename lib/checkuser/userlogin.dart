import 'dart:convert';

import 'package:elsobkypack/database/database_helper.dart';
import 'package:elsobkypack/models/user.dart';
import 'package:elsobkypack/models/userlogin.dart';
import 'package:elsobkypack/websitw/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ChekUser {
  Future<void> checkUser(BuildContext context) async {
    final dbHelper = DatabaseHelper.instance;
    final user = await dbHelper.getUser();
    if (user == null) {
      if (context.mounted) {
        _showUserInputDialog(context);
      }
    } else {
      if (user.usersent) {
        _logUserLogin(user);
      } else {
        _sendUserToServer(user);
      }
    }
  }

  void _showUserInputDialog(BuildContext context) {
     final TextEditingController userNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false, // لمنع إغلاق الحوار عند النقر خارج النافذة
      builder: (context) {       
        return PopScope(
          canPop: false, // عندما يكون false، يمنع الرجوع للشاشة السابقة
          onPopInvoked: (didPop) async {
            return;
          },
          child: AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(labelText: 'الاسم'),

                  ),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (userNameController.text.isNotEmpty &&
                      phoneController.text.isNotEmpty) {
                    final user = User(
                      userName: userNameController.text,
                      id: 0,
                      phone: phoneController.text,
                      usersent: false,
                      userDats: [],
                      iscash: true
                    );
                    await _sendUserToServer(user);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendUserToServer(User user) async {
    final userLogin = UserLogin(logindate: DateTime.now(), loginsent: false);
    user.userDats!.add(userLogin);

    final dbHelper = DatabaseHelper.instance;
    if (await dbHelper.getUser() == null) {
      await dbHelper.insertUser(user);
    }

    try {
      String baseUrl =
          '${MostStrings.url}/app/AppApi/CreateUser';
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
        user.id = data;
        user.usersent = true;
        dbHelper.updateUser(user);
        dbHelper.delettableuserLogins();
      }
    } catch (e) {
      await dbHelper.insertUserLogin(userLogin);
      Logger().e('Error sending user to server: $e');
    }
  }

  Future<void> _logUserLogin(User user) async {
    final userLogin = UserLogin(logindate: DateTime.now(), loginsent: false);
    user.userDats!.add(userLogin);
    await _sendUserLoginToServer(user);
  }

  Future<void> _sendUserLoginToServer(User user) async {
    try {
      String baseUrl =
          '${MostStrings.url}/app/AppApi/UserDateLogin';
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
        final dbHelper = DatabaseHelper.instance;
        await dbHelper.delettableuserLogins();
      }
    } catch (e) {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.insertUserLogin(user.userDats!.last);
      Logger().e('Error sending user login to server: $e');
    }
  }
}
