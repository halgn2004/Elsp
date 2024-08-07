import 'dart:io';

import 'package:elsobkypack/database/database_helper.dart';
import 'package:elsobkypack/models/main_order.dart';
import 'package:elsobkypack/models/main_order_product.dart';
import 'package:elsobkypack/models/main_prod.dart';
import 'package:elsobkypack/models/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final MainProd mainProd;
final VoidCallback setstatoforder;
const  ProductDetailPage({super.key,required this.product, required this.mainProd,required this.setstatoforder});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late double price;
  late int qunta;
  late int total;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  bool xz=false;
  @override
  void initState() {
    super.initState();
    price = widget.product.price!;
    qunta = widget.product.startQuantity!;
    total = calculateTotal();
    getMainOrderId();
  }
   
   Future<void> getMainOrderId() async{
    xz = await dbHelper.getMainOrderId(widget.mainProd.id!);
   }

  int calculateTotal() {
    if (qunta >= (widget.product.startQuantity! * 5)) {
      price = 0.9 * widget.product.price!;
      return (0.9 * widget.product.price! * qunta).round();
    } else if (qunta >= (widget.product.startQuantity! * 3)) {
      price = 0.95 * widget.product.price!;
      return (0.95 * widget.product.price! * qunta).round();
    } else {
      return (widget.product.price! * qunta).round();
    }
  }

  void updateTotal() {
    setState(() {
      total = calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(alignment: Alignment.topCenter, children: [
              Container(
                height: screenSize.height * 0.55,
                color: const Color.fromARGB(255, 255, 57, 90),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: screenSize.height * 0.20,
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 25,
                child: Text(
                  'Product Details',
                  style: GoogleFonts.arimo(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                bottom: screenSize.height * 0.06,
                left: screenSize.width * 0.09,
                right: screenSize.width * 0.09,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  child: Image.file(
                    File(widget.product.img),
                    height: MediaQuery.of(context).size.height * 0.35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: screenSize.height * 0.01,
                left: screenSize.width * 0.13,
                right: screenSize.width * 0.13,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.showNameEN,
                      style: GoogleFonts.arimo(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.product.showNameAR,
                      style: const TextStyle(
                        fontFamily: 'GE_SS_TWO_BOLD',
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenSize.width * 0.45,
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$total',
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Text(
                        'L.E',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 57, 90),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      style: TextStyle(color: Colors.white),
                      '+',
                    ),
                    onPressed: () {
                      setState(() {
                        qunta = qunta + widget.product.startQuantity!;
                        updateTotal();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.15,
                  child: Text(
                    textAlign: TextAlign.center,
                    '$qunta',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 57, 90),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    style: TextStyle(color: Colors.white),
                    '-',
                  ),
                  onPressed: () {
                    setState(() {
                      if (qunta > widget.product.startQuantity!) {
                        qunta = qunta - widget.product.startQuantity!;
                        updateTotal();
                      }
                    });
                  },
                ),
              ],
            ),
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'الوصف',
                  style: TextStyle(
                    fontFamily: 'GE_SS_TWO_BOLD',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  widget.product.details!,
                  style: const TextStyle(
                    fontFamily: 'GE_SS_TWO_BOLD',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Text(
                  'وفى حاله طلب كميه تساوي او اكبر من ${widget.product.startQuantity! * 3} سوف تحصل على خصم 5% او عند طلب كميه تساوى او اكبر من ${widget.product.startQuantity! * 5} سوف تحصل على خصم 10% من اجمالى المبلغ!',
                  style: const TextStyle(
                    fontFamily: 'GE_SS_TWO_BOLD',
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 57, 90),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  style: TextStyle(color: Colors.white),
                  'Add To Cart',
                ),
                onPressed: () async {
                  _addToCart();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart() async {    
    
    if (xz) {
      await dbHelper.insertOrderproduct(
          MainOrderProduct(
            price: price,
            quantity: qunta,
            showNameAR: widget.product.showNameAR,
            productIdApi: widget.product.id!,
            stratquantity: widget.product.startQuantity!,
          ),
          widget.mainProd.id!);
    } else {
      List<MainOrderProduct> orderproductlist = [];
      orderproductlist.add(MainOrderProduct(
        price: price,
        quantity: qunta,
        showNameAR: widget.product.showNameAR,
        productIdApi: widget.product.id!,
        stratquantity: widget.product.startQuantity!,
      ));
      var mainorder = Mainorder(
          id: widget.mainProd.id,
          ready: widget.mainProd.ready,
          showNameAR: widget.mainProd.showNameAR,
          orderproduct: orderproductlist);
    await  dbHelper.insertOrder(mainorder);
    }
    setState(() {
      widget.setstatoforder();
    });
    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
    
  }
}
