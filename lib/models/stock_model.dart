import 'dart:convert';

class StockModel {
  final String cat;
  StockModel({
    required this.cat,
  });

  Map<String, dynamic> toMap() {
    return {
      'cat': cat,
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      cat: map['cat'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StockModel.fromJson(String source) => StockModel.fromMap(json.decode(source));
}
