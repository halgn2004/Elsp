class Product {
  int? id;
  double? price;
  int? startQuantity;
  String img;
  String showNameAR;
  String showNameEN;
  String? details;

  Product({
    this.id,
    this.price,
    this.startQuantity,
    required this.img,
    required this.showNameAR,
    required this.showNameEN,
    this.details,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['Id'],
      price: json['price'],
      startQuantity: json['StartQuantity'],
      img: json['Img'],
      showNameAR: json['Show_Name_AR'],
      showNameEN: json['Show_Name_EN'],
      details: json['Details'],
    );
  }
}