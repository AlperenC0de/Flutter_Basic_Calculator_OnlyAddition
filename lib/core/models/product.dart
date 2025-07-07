import 'package:equatable/equatable.dart';

/// Product model class that represents an inventory item
class Product extends Equatable {
  /// Unique identifier for the product
  final String id;
  
  /// Product name
  final String name;
  
  /// Current stock quantity
  final int stock;
  
  /// Unit price (optional)
  final double? price;
  
  /// Creation/last modified timestamp
  final DateTime lastModified;

  const Product({
    required this.id,
    required this.name,
    required this.stock,
    this.price,
    required this.lastModified,
  });

  /// Create a copy of the product with modified fields
  Product copyWith({
    String? id,
    String? name,
    int? stock,
    double? price,
    DateTime? lastModified,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  /// Check if the product has low stock (less than 10 units)
  bool get hasLowStock => stock < 10;

  /// Convert product to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'price': price,
      'lastModified': lastModified.millisecondsSinceEpoch,
    };
  }

  /// Create product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      stock: json['stock'],
      price: json['price']?.toDouble(),
      lastModified: DateTime.fromMillisecondsSinceEpoch(json['lastModified']),
    );
  }

  /// Create a new product with generated ID
  factory Product.create({
    required String name,
    required int stock,
    double? price,
  }) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      stock: stock,
      price: price,
      lastModified: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, name, stock, price, lastModified];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, stock: $stock, price: $price)';
  }
}