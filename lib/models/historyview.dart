class HistoryView {
  int id;
  DateTime date;
  bool check;
  int total;
  List<ProductView> products ;
  HistoryView({required this.id, required this.date, required this.check, required this.products , required this.total});
}
class ProductView {
  int? id;
  double? ready;
  String? showNameAR;
  List<ProductViewDetails>? orderproduct;
  double get totalpricewithready => _calculateTotalwithready();

  ProductView({
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


class ProductViewDetails {
 
  int? id;
  double price;
  int quantity;
  int stratquantity;
  String showNameAR;

  int get totalprice => _calculateTotal();
  int get calculateall=>_calculateall();

  ProductViewDetails({
    this.id,
    required this.price,
    required this.quantity,
    required this.showNameAR,
    required this.stratquantity,
  });

  int _calculateTotal() {
    double priceafterdiscount=0;
    if (quantity >= (stratquantity * 5)) {
      priceafterdiscount = (1 - 0.1) * price;
    } else if (quantity >= (stratquantity * 3)) {
      priceafterdiscount = (1 - 0.05) * price;
    } else {
      priceafterdiscount = price;
    }
    return (priceafterdiscount * quantity).round();
  }
  int _calculateall() {
    
    return (price * quantity).round();
  }
}
