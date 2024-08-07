import 'package:elsobkypack/database/database_helper.dart';
import 'package:elsobkypack/models/historyview.dart';
import 'package:elsobkypack/screens/history/historyshoinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:elsobkypack/screens/about/aboutscreen.dart';
import 'package:elsobkypack/screens/appdrawer.dart';
import 'package:elsobkypack/screens/home/homescreen.dart';
import 'package:intl/intl.dart';
class Transaction {
  final String date;
  final double amount;
  final bool check;

  Transaction({required this.date, required this.amount, required this.check});
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {  
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

 
  @override
  Widget build(BuildContext context) {
        final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('History Page'),
        ),
        drawer: SizedBox(
            width: screenSize.width * 0.6,
          child: AppDrawer(
            selectedIndex: 1,
            onItemTapped: (int index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                  break;             
                case 2:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                  break;
              }
            },
          ),
        ),
        body: FutureBuilder<List<HistoryView>>(
            future: dbHelper.fetchHistoryViews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                final historyviews = snapshot.data!;
                return ListView.builder(
                  itemCount: historyviews.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(historyviews[index].date)}'),
                        subtitle: Text('Amount: ${historyviews[index].total}'),
                        trailing: historyviews[index].check
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle button press for Waiting
                                     Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HistoryDetailsInfo(productViews: historyviews[index].products ,totalorder: historyviews[index].total, ),
                                            )
                                     );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(251, 73, 238, 8),
                                      textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Approved',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                157, 22, 22, 22)),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.check_circle,
                                          color: Color.fromARGB(255, 4, 46, 5)),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HistoryDetailsInfo(productViews: historyviews[index].products ,totalorder: historyviews[index].total, ),
                                            ),
                                          );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 250, 246, 4),
                                      textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Waiting',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                157, 22, 22, 22)),
                                      ),
                                      SizedBox(width: 8),
                                      Padding(
                                        padding: EdgeInsets.zero,
                                        child: SpinKitFadingCircle(
                                          color: Colors.blue,
                                          size: 25.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        tileColor: historyviews[index].check
                            ? const Color.fromARGB(255, 184, 255, 157)
                            : const Color.fromARGB(255, 255, 250, 179),
                        onTap: () {},
                      ),
                    );
                  },
                );
              }
            }));
  }
}
