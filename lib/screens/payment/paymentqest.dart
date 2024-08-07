import 'package:elsobkypack/database/database_helper.dart';
import 'package:elsobkypack/models/historyview.dart';
import 'package:elsobkypack/models/main_order.dart';
import 'package:elsobkypack/models/main_order_product.dart';
import 'package:elsobkypack/models/user_order_details_api.dart';
import 'package:elsobkypack/sendorderapi/send_order_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentQest extends StatefulWidget {
  final VoidCallback setstatoforder;
  const PaymentQest({super.key, required this.setstatoforder});

  @override
  State<PaymentQest> createState() => _PaymentQestState();
}

class _PaymentQestState extends State<PaymentQest> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  int isrady = 0;
  List<Mainorder> mainOrders = [];
  int totalorder = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getnubers();
  }

  Future<List<Mainorder>> getMainOrder() async {
    var mainorder = await dbHelper.fetchOrders();
    return mainorder;
  }

  void getnubers() async {
    int x = 0;
    var mainorderr = await dbHelper.fetchOrders();
    for (var element in mainorderr) {
      x = x + element.totalpricewithready.round();
    }
    setState(() {
      totalorder = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: screenSize.height * 0.23,
                    child: Image.asset(
                      'images/paymentqest.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenSize.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Localcontainer(
                          text: 'الاجمالى',
                          height: screenSize.height * 0.08,
                          width: screenSize.width * 0.15,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5)),
                          fontsize: 11,
                          color: const Color.fromARGB(255, 255, 57, 90),
                        ),
                        Localcontainer(
                          text: 'تجهيزات',
                          height: screenSize.height * 0.08,
                          width: screenSize.width * 0.10,
                          borderRadius: BorderRadius.circular(0),
                          fontsize: 8,
                          color: const Color.fromARGB(255, 255, 57, 90),
                        ),
                        Column(
                          children: [
                            Localcontainer(
                              text: 'سعــر',
                              height: screenSize.height * 0.04,
                              width: screenSize.width * 0.15,
                              borderRadius: BorderRadius.circular(0),
                              fontsize: 11,
                              color: const Color.fromARGB(255, 255, 57, 90),
                            ),
                            Localcontainer(
                              text: 'الكميه /كرتونه',
                              height: screenSize.height * 0.04,
                              width: screenSize.width * 0.15,
                              borderRadius: BorderRadius.circular(0),
                              fontsize: 8,
                              color: const Color.fromARGB(255, 255, 57, 90),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Localcontainer(
                              text: 'العــدد',
                              height: screenSize.height * 0.04,
                              width: screenSize.width * 0.10,
                              borderRadius: BorderRadius.circular(0),
                              fontsize: 9,
                              color: const Color.fromARGB(255, 255, 57, 90),
                            ),
                            Localcontainer(
                              text: 'الكميه /كرتونه',
                              height: screenSize.height * 0.04,
                              width: screenSize.width * 0.10,
                              borderRadius: BorderRadius.circular(0),
                              fontsize: 7.5,
                              color: const Color.fromARGB(255, 255, 57, 90),
                            ),
                          ],
                        ),
                        Localcontainer(
                          text: 'الصــــــــــنف',
                          height: screenSize.height * 0.08,
                          width: screenSize.width * 0.25,
                          borderRadius: BorderRadius.circular(0),
                          fontsize: 11,
                          color: const Color.fromARGB(255, 255, 57, 90),
                        ),
                        Localcontainer(
                          text: 'م',
                          height: screenSize.height * 0.08,
                          width: screenSize.width * 0.08,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5)),
                          fontsize: 11,
                          color: const Color.fromARGB(255, 255, 245, 80),
                        )
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenSize.height * 0.2,
                    ),
                    child: SizedBox(
                      height: screenSize.height * 0.4,
                      child: FutureBuilder<List<Mainorder>>(
                          future: getMainOrder(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No Items in Cart'));
                            } else {
                              mainOrders = snapshot.data!;

                              int counter = 1;

                              return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: mainOrders.length,
                                  itemBuilder: (context, index) {
                                    Mainorder order = mainOrders[index];
                                    isrady = 0;
                                    return Column(
                                      children: [
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: order.orderproduct!.length,
                                          itemBuilder: (context, productIndex) {
                                            counter = counter + 1;
                                            isrady = isrady + 1;
                                            MainOrderProduct product = order
                                                .orderproduct![productIndex];
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  right:
                                                      screenSize.height * 0.01),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width:
                                                        screenSize.width * 0.13,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 1,
                                                            bottom: 2,
                                                            right: 2,
                                                            top: 2),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                255, 57, 90),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                      ),
                                                      child: const Text(
                                                        'x',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () async {
                                                        order.orderproduct!.remove(
                                                            order.orderproduct![
                                                                productIndex]);

                                                        await dbHelper
                                                            .removeOrderProduct(
                                                                product.id!);
                                                        widget.setstatoforder();
                                                        getnubers();
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                  Localcontainer(
                                                    text: isrady == 1
                                                        ? '${order.ready! + product.calculateall}'
                                                        : '${product.calculateall}',
                                                    height: screenSize.height *
                                                        0.04,
                                                    width:
                                                        screenSize.width * 0.15,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    fontsize: 11,
                                                    color: Colors.white,
                                                  ),
                                                  Localcontainer(
                                                    text: isrady == 1
                                                        ? '${order.ready}'
                                                        : '0',
                                                    height: screenSize.height *
                                                        0.04,
                                                    width:
                                                        screenSize.width * 0.1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    fontsize: 8,
                                                    color: Colors.white,
                                                  ),
                                                  Localcontainer(
                                                    text: product.price
                                                        .toStringAsFixed(2),
                                                    height: screenSize.height *
                                                        0.04,
                                                    width:
                                                        screenSize.width * 0.15,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    fontsize: 8,
                                                    color: Colors.white,
                                                  ),
                                                  Localcontainer(
                                                    text: '${product.quantity}',
                                                    height: screenSize.height *
                                                        0.04,
                                                    width:
                                                        screenSize.width * 0.1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    fontsize: 8,
                                                    color: Colors.white,
                                                  ),
                                                  Localcontainer(
                                                    text: product.showNameAR,
                                                    height: screenSize.height *
                                                        0.04,
                                                    width:
                                                        screenSize.width * 0.25,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    fontsize: 11,
                                                    color: Colors.white,
                                                  ),
                                                  Localcontainer(
                                                    text: '${counter - 1}',
                                                    height: screenSize.height *
                                                        0.04,
                                                    width:
                                                        screenSize.width * 0.08,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    fontsize: 11,
                                                    color: const Color.fromARGB(
                                                        255, 255, 245, 80),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: screenSize.height * 0.04,
                        width: screenSize.width * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: const Color.fromARGB(255, 255, 57, 90),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          '$totalorder',
                          style: GoogleFonts.arimo(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        'الاجمالــــى',
                        style: TextStyle(
                          fontFamily: 'GE_SS_TWO_BOLD',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.37,
                    child: Image.asset(
                      'images/paymentbottomqest.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 57, 90),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text(
                        style: TextStyle(color: Colors.white),
                        'Send Order',
                      ),
                      onPressed: () async {
                        if (mainOrders.isEmpty) return;
                        //add  loading
                        setState(() {
                          isLoading = true;
                        });
                        final dbHelper = DatabaseHelper.instance;
                        final user = await dbHelper.getUser();

                        List<UserOrderDetails> sendorder = [];
                        List<ProductView> products = [];

                        for (var main in mainOrders) {
                          List<ProductViewDetails> productdetals = [];
                          for (var product in main.orderproduct!) {
                            sendorder.add(UserOrderDetails(
                                price: product.price.toInt(),
                                productDetailID: product.productIdApi,
                                qunta: product.quantity));

                            productdetals.add(ProductViewDetails(
                              price: product.price,
                              quantity: product.quantity,
                              stratquantity: product.stratquantity,
                              showNameAR: product.showNameAR,
                            ));
                          }
                          products.add(ProductView(
                              ready: main.ready,
                              showNameAR: main.showNameAR,
                              orderproduct: productdetals));
                        }
                        user!.userorderdetails = sendorder;
                        user.iscash = true;
                        int historyid =
                            await SendOrderApi.sendUserToServer(user);
                        if (historyid > 0) {
                          await dbHelper.insertHistory(HistoryView(
                              id: historyid,
                              date: DateTime.now(),
                              check: true,
                              products: products,
                              total: totalorder));
                          await dbHelper.deleteAllOrders();
                          widget.setstatoforder();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        } else {
                          if (context.mounted) {
                            showAlertDialogError(context, "خطأ فى الاتصال");
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  showAlertDialogError(BuildContext context, String massg) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("خطأ"),
      content: Text(massg),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Localcontainer extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final double fontsize;
  final BorderRadius borderRadius;
  final Color color;
  const Localcontainer({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.fontsize,
    required this.borderRadius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black, // لون الإطار
          width: 1, // سمك الإطار
        ),
        borderRadius: borderRadius, // حدود مستديرة للإطار
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.arimo(
            fontSize: fontsize,
            fontWeight: FontWeight.bold,
            color: color == const Color.fromARGB(255, 255, 245, 80) ||
                    color == Colors.white
                ? Colors.black
                : Colors.white,
          ),
          textAlign: TextAlign.center, // حجم النص
        ),
      ),
    );
  }
}
