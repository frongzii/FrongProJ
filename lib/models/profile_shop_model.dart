import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileShopModel {
  final String nameShop;
  final String address;
  final String phone;
  final double lat;
  final double long;
  final String pathImage;
  final bool product;
  ProfileShopModel({
    required this.nameShop,
    required this.address,
    required this.phone,
    required this.lat,
    required this.long,
    required this.pathImage,
    required this.product,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nameShop': nameShop,
      'address': address,
      'phone': phone,
      'lat': lat,
      'long': long,
      'pathImage': pathImage,
      'product': product,
    };
  }

  factory ProfileShopModel.fromMap(Map<String, dynamic> map) {
    return ProfileShopModel(
      nameShop: (map['nameShop'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      lat: (map['lat'] ?? 0.0) as double,
      long: (map['long'] ?? 0.0) as double,
      pathImage: (map['pathImage'] ?? '') as String,
      product: (map['product'] ?? false) as bool,
    );
  }

  factory ProfileShopModel.fromJson(String source) => ProfileShopModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
