import '../models/android_update.dart';
import '../models/main_prod.dart';
class AndroidAPI {
  final AndroidUpdate androidUpdate;
  final List<String> mainImages;
  final List<MainProd> mainProds;

  AndroidAPI({required this.androidUpdate, required this.mainImages, required this.mainProds});

  factory AndroidAPI.fromJson(Map<String, dynamic> json) {
    return AndroidAPI(
      androidUpdate: AndroidUpdate.fromJson(json['android_update']),
      mainImages: List<String>.from(json['mainImages']),
      mainProds: (json['mainProds'] as List).map((i) => MainProd.fromJson(i)).toList(),
    );
  }
}