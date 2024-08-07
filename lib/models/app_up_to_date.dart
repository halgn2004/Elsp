class AppUpToDate {
  int id;
  AppUpToDate({required this.id});

  factory AppUpToDate.fromJson(Map<String, dynamic> json) {
    return AppUpToDate(id: json['NewId']);}
}
