import 'package:elsobkypack/models/historyview.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class HistoryDetailsInfo extends StatelessWidget {
  final List<ProductView> productViews;
  final  int totalorder;


 const  HistoryDetailsInfo({super.key, 
    required this.productViews,
    required this.totalorder,
  }) ;


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    int isrady=0;
    int count=0;
    return Scaffold(
      appBar: AppBar(),
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
                      'images/payment.png',
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
                      child:  ListView.builder(                                  
                                  shrinkWrap: true,
                                  itemCount: productViews.length,
                                  itemBuilder: (context, index) {
                                    ProductView productview = productViews[index];
                                    isrady = 0;
                                    return Column(
                                      children: [
                                        ListView.builder(                                        
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: productview.orderproduct!.length,
                                          itemBuilder: (context, productIndex) {                                            
                                            isrady = isrady + 1;
                                            count=count+1;
                                            ProductViewDetails productDetails = productview.orderproduct![productIndex];
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  right:
                                                      screenSize.height * 0.01),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [                                                  
                                                  Localcontainer(
                                                    text: isrady == 1
                                                        ? '${productview.ready! + productDetails.calculateall}'
                                                        : '${productDetails.calculateall}',
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
                                                        ? '${productview.ready}'
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
                                                    text: productDetails.price
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
                                                    text: '${productDetails.quantity}',
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
                                                    text: productDetails.showNameAR,
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
                                                    text: '$count',
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
                      'images/paymentbottom.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                 
                ],
              ),
            ),
          )         
        ],
      ),
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


