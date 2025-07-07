import '../models/product.dart';

/// Abstract repository class that defines the interface for product data operations
abstract class ProductRepository {
  /// Load all products from storage
  Future<List<Product>> getProducts();
  
  /// Add a new product
  Future<void> addProduct(Product product);
  
  /// Update an existing product
  Future<void> updateProduct(Product product);
  
  /// Delete a product by id
  Future<void> deleteProduct(String id);
  
  /// Search products by name
  Future<List<Product>> searchProducts(String query);
}