import 'package:elsobkypack/screens/history/hestoryscreen.dart';
import 'package:elsobkypack/screens/appdrawer.dart';
import 'package:elsobkypack/screens/home/homescreen.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('About'),
      ),
      drawer: SizedBox(
        width: screenSize.width * 0.6,
        child: AppDrawer(
          selectedIndex: 2,
          onItemTapped: (int index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const  HistoryPage()),
                );                
                break;
            }
          },
        ),
      ),
       body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover, // أو BoxFit.contain أو BoxFit.fill بناءً على النتيجة التي تريدها
          child: Image.asset(
            'images/about.png',
          ),
        ),
      ),
    );
  }
}