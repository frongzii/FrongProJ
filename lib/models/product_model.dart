import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  final String nameProduct;
  final int amountProduct;
  final int priceProduct;
  final String pathProduct;
  ProductModel({
    required this.nameProduct,
    required this.amountProduct,
    required this.priceProduct,
    required this.pathProduct,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nameProduct': nameProduct,
      'amountProduct': amountProduct,
      'priceProduct': priceProduct,
      'pathProduct': pathProduct,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      nameProduct: (map['nameProduct'] ?? '') as String,
      amountProduct: (map['amountProduct'] ?? 0) as int,
      priceProduct: (map['priceProduct'] ?? 0) as int,
      pathProduct: (map['pathProduct'] ?? '') as String,
    );
  }

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
