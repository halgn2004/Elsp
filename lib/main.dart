import 'package:elsobkypack/screens/home/homescreen.dart';
import 'package:elsobkypack/services/chekhistory.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'checkfileinsplash/checkfilestart.dart';


//import 'providers/android_api_provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';


//import 'screens/home_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding  wFB = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wFB);
 
 
  final String massge =  await Chekfile().checkUpdateData();  
  if (massge!='') {
    FlutterNativeSplash.remove();
     runApp(MaterialApp(
      home: UpdateScreen(message: massge),
    ));
    
  }else{


  await Chekhistory().chekhistory();
  FlutterNativeSplash.remove();
  runApp(Phoenix(child: const MyApp()));
  }
}









class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Elsobkypack Pack',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),       
        home:const HomeScreen(),    
    );
  }
}





class UpdateApp extends StatelessWidget {
  final String message;

  const UpdateApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UpdateScreen(message: message),
    );
  }
}

class UpdateScreen extends StatelessWidget {
  final String message;

  const UpdateScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUpdateDialog(context);
    });
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('موافق'),
              onPressed: () {
                // يمكنك غلق التطبيق أو عمل أي إجراء آخر
               SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}









