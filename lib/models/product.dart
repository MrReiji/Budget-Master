class Product {
  String productName;
  String price;

  Product({required this.productName, required this.price});

  // Product.fromJson(Map<String, dynamic> json) {
  //   productName = json['productName'];
  //   price = json['price'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productName'] = productName;
    data['price'] = price;
    return data;
  }

  @override
  String toString() => '''Product {
  productName: $productName,
  price: $price
}''';
}
