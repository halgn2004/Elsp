import '../models/product.dart';
class MainProd {
  int? id;
  double? ready;
  String img;
  String showNameAR;
  String showNameEN;
  List<Product> products;

  MainProd({
    this.id,
    this.ready,
    required this.img,
    required this.showNameAR,
    required this.showNameEN,
    required this.products,
  });

  factory MainProd.fromJson(Map<String, dynamic> json) {
    return MainProd(
      id: json['ID'],
      ready: json['Ready'],
      img: json['Img'],
      showNameAR: json['Show_Name_AR'],
      showNameEN: json['Show_Name_EN'],
      products: (json['products'] as List).map((i) => Product.fromJson(i)).toList(),
    );
  }
}