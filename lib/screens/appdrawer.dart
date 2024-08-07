import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const AppDrawer({super.key, 
    // إضافة هذه السطر لتعريف المفتاح بشكل صحيح
    required this.selectedIndex,
    required this.onItemTapped,
  }); 

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 57, 90),
            ),
            child: Center(
              child: Image.asset('images/elsobkylogo.png'),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Home',
            index: 0,
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'History',
            index: 1,
          ),
          _buildDrawerItem(
            icon: Icons.info,
            text: 'About',
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
  }) {
    return ListTile(
      title: Text(
        text,
        style: GoogleFonts.oswald(
          textStyle: TextStyle(
            color: selectedIndex == index
                ? const Color.fromARGB(255, 255, 57, 90)
                : Colors.black,
          ),
        ),
      ),
      leading: Icon(
        icon,
        color: selectedIndex == index
            ? const Color.fromARGB(255, 255, 57, 90)
            : Colors.black,
      ),
      onTap: () => onItemTapped(index),
    );
  }
}
