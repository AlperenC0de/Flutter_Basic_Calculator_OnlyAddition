import 'package:equatable/equatable.dart';
import '../../../../core/models/product.dart';

/// Base class for all product states
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the bloc is created
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// State when products are being loaded
class ProductsLoading extends ProductState {
  const ProductsLoading();
}

/// State when products are successfully loaded
class ProductsLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;
  final bool isSearching;

  const ProductsLoaded({
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
    this.isSearching = false,
  });

  /// Create a copy with modified values
  ProductsLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
    bool? isSearching,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [products, filteredProducts, searchQuery, isSearching];
}

/// State when a product operation (add/update/delete) is in progress
class ProductOperationInProgress extends ProductState {
  final String operation; // 'adding', 'updating', 'deleting'

  const ProductOperationInProgress(this.operation);

  @override
  List<Object?> get props => [operation];
}

/// State when a product operation is successful
class ProductOperationSuccess extends ProductState {
  final String message;
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;
  final bool isSearching;

  const ProductOperationSuccess({
    required this.message,
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
    this.isSearching = false,
  });

  @override
  List<Object?> get props => [message, products, filteredProducts, searchQuery, isSearching];
}

/// State when an error occurs
class ProductError extends ProductState {
  final String message;
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;
  final bool isSearching;

  const ProductError({
    required this.message,
    this.products = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
    this.isSearching = false,
  });

  @override
  List<Object?> get props => [message, products, filteredProducts, searchQuery, isSearching];
}

/// State when products are empty (no products found)
class ProductsEmpty extends ProductState {
  final String message;

  const ProductsEmpty({this.message = 'No products found'});

  @override
  List<Object?> get props => [message];
}