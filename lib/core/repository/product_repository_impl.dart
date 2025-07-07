import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'product_repository.dart';

/// Concrete implementation of ProductRepository using SharedPreferences
class ProductRepositoryImpl implements ProductRepository {
  static const String _productsKey = 'products';
  
  /// Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<List<Product>> getProducts() async {
    try {
      final prefs = await _prefs;
      final productsJson = prefs.getString(_productsKey);
      
      if (productsJson == null) {
        return [];
      }
      
      final List<dynamic> productsList = json.decode(productsJson);
      return productsList.map((productJson) => Product.fromJson(productJson)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    try {
      final products = await getProducts();
      
      // Check if product with same name already exists
      if (products.any((p) => p.name.toLowerCase() == product.name.toLowerCase())) {
        throw Exception('Product with this name already exists');
      }
      
      products.add(product);
      await _saveProducts(products);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      final products = await getProducts();
      final index = products.indexWhere((p) => p.id == product.id);
      
      if (index == -1) {
        throw Exception('Product not found');
      }
      
      // Check if another product with same name already exists (excluding current product)
      if (products.any((p) => p.id != product.id && p.name.toLowerCase() == product.name.toLowerCase())) {
        throw Exception('Another product with this name already exists');
      }
      
      products[index] = product.copyWith(lastModified: DateTime.now());
      await _saveProducts(products);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final products = await getProducts();
      products.removeWhere((product) => product.id == id);
      await _saveProducts(products);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final products = await getProducts();
      if (query.isEmpty) {
        return products;
      }
      
      return products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  /// Save products to SharedPreferences
  Future<void> _saveProducts(List<Product> products) async {
    final prefs = await _prefs;
    final productsJson = json.encode(products.map((product) => product.toJson()).toList());
    await prefs.setString(_productsKey, productsJson);
  }

  /// Clear all products (useful for testing)
  Future<void> clearAllProducts() async {
    final prefs = await _prefs;
    await prefs.remove(_productsKey);
  }

  /// Add sample data for testing
  Future<void> addSampleData() async {
    final products = await getProducts();
    if (products.isEmpty) {
      final sampleProducts = [
        Product.create(name: 'Laptop', stock: 5, price: 999.99),
        Product.create(name: 'Mouse', stock: 25, price: 29.99),
        Product.create(name: 'Keyboard', stock: 8, price: 79.99),
        Product.create(name: 'Monitor', stock: 3, price: 299.99),
        Product.create(name: 'Headphones', stock: 15, price: 159.99),
      ];
      
      for (final product in sampleProducts) {
        await addProduct(product);
      }
    }
  }
}