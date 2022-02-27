import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SQLiteModel {
  final int? id;
  final String nameProduct;
  final String price;
  final String amount;
  final String sum;
  final String docProduct;
  final String docStock;
  final String docUser;
  SQLiteModel({
    this.id,
    required this.nameProduct,
    required this.price,
    required this.amount,
    required this.sum,
    required this.docProduct,
    required this.docStock,
    required this.docUser,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameProduct': nameProduct,
      'price': price,
      'amount': amount,
      'sum': sum,
      'docProduct': docProduct,
      'docStock': docStock,
      'docUser': docUser,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: (map['id'] ?? 0) as int,
      nameProduct: (map['nameProduct'] ?? '') as String,
      price: (map['price'] ?? '') as String,
      amount: (map['amount'] ?? '') as String,
      sum: (map['sum'] ?? '') as String,
      docProduct: (map['docProduct'] ?? '') as String,
      docStock: (map['docStock'] ?? '') as String,
      docUser: (map['docUser'] ?? '') as String,
    );
  }

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
