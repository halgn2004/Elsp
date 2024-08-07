class AndroidUpdate {
  final int id;
  final String date;

  AndroidUpdate({required this.id, required this.date});

  factory AndroidUpdate.fromJson(Map<String, dynamic> json) {
    return AndroidUpdate(
      id: json['ID'],
      date: json['dateTime'],
    );
  }
}