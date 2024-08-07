import 'package:elsobkypack/models/main_order_product.dart';

class Mainorder {
  int? id;
  double? ready;
  String? showNameAR;
  List<MainOrderProduct>? orderproduct;
  double get totalpricewithready => _calculateTotalwithready();

  Mainorder({
    this.id,
    this.ready,
    this.showNameAR,
    this.orderproduct,
  });

  double _calculateTotalwithready() {
    double total = 0;
    if (orderproduct != null) {
      for (var element in orderproduct!) {
        total += element.calculateall;
      }
    }
    return total + (ready ?? 0);
  }
}
