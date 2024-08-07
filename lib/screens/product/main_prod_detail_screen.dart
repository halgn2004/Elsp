import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/main_prod.dart';
import 'product_details.dart';

class MainProdDetailScreen extends StatelessWidget {
  final MainProd mainProd;
  final VoidCallback setstatoforder;
  const MainProdDetailScreen({super.key, required this.mainProd, required this.setstatoforder});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: screenSize.height * 0.04,
            color: const Color.fromARGB(255, 255, 57, 90),
          ),
          Container(
            height: screenSize.height * 0.011,
            color: const Color.fromARGB(255, 255, 245, 80),
          ),
          Stack(
            children: [
              Image.file(File(mainProd.img)),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  color: const Color.fromARGB(143, 255, 57, 90),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width * 0.09,
                      right: screenSize.width * 0.09,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          mainProd.showNameEN,
                          style: GoogleFonts.arimo(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(188, 255, 255, 255),
                          ),
                        ),
                        Text(
                          mainProd.showNameAR,
                          style: const TextStyle(
                            fontFamily: 'GE_SS_TWO_BOLD',
                            fontSize: 18,
                            color: Color.fromARGB(188, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: screenSize.height * 0.011,
            color: const Color.fromARGB(255, 255, 245, 80),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: screenSize.height * 0.01),
              children: [
                SizedBox(
                  height: screenSize.height * 0.6, // تحديد ارتفاع ثابت للـ GridView
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: mainProd.products.map((product) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: product,
                                mainProd: mainProd,
                                setstatoforder: setstatoforder,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            right: screenSize.width * 0.02,
                            left: screenSize.width * 0.02,
                            bottom: screenSize.height * 0.02,
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                child: Image.file(
                                  File(product.img),
                                  width: double.infinity,
                                  height: screenSize.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      product.showNameEN,
                                      style: GoogleFonts.arimo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        product.showNameAR,
                                        style: const TextStyle(
                                          fontFamily: 'GE_SS_TWO_BOLD',
                                          fontSize: 14,
                                        ),
                                        softWrap: true,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}