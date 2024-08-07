class UserOrderDetails {
  int productDetailID;
  int qunta;
  int price ;

  UserOrderDetails({
   required this.productDetailID,
    required this.qunta,
    required this.price,   
  });


    Map<String, dynamic> toJson() {
    return {
      'ProductDetailID':productDetailID,
      'Qunta': qunta,
      'price': price,      
    };
  }
}