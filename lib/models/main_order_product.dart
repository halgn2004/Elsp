class MainOrderProduct {
  int? id;
  double price;
  int quantity;
  int stratquantity;
  String showNameAR;
  int productIdApi;
  int get totalprice => _calculateTotal();
  int get calculateall=>_calculateall();

  MainOrderProduct({
    this.id,
    required this.price,
    required this.quantity,
    required this.showNameAR,
    required this.stratquantity,
    required this.productIdApi,
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



/*
void main() {
  // إنشاء كائن من فئة MainOrderProduct
  MainOrderProduct product = MainOrderProduct(
    id: 1,
    price: 50.0,
    quantity: 350, // يمكنك تعديل الكمية لاختبار مختلف السيناريوهات
    showNameAR: "منتج تجريبي",
    stratquantity: 100,
  );

  // استعراض الخصائص
  print("معرف المنتج: ${product.id}");
  print("اسم المنتج: ${product.showNameAR}");
  print("السعر الأساسي: ${product.price}");
  print("الكمية: ${product.quantity}");
  print("الكمية الابتدائية: ${product.stratquantity}");

  // حساب الإجمالي
  print("السعر بعد الخصم: ${product.priceafterdiscount ?? product.price}");
  print("الإجمالي الكلي: ${product.totalprice}");
}
*/