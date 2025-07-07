import 'package:equatable/equatable.dart';
import '../../../../core/models/product.dart';

/// Base class for all product events
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all products
class LoadProductsEvent extends ProductEvent {
  const LoadProductsEvent();
}

/// Event to add a new product
class AddProductEvent extends ProductEvent {
  final Product product;

  const AddProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

/// Event to update an existing product
class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

/// Event to delete a product
class DeleteProductEvent extends ProductEvent {
  final String productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Event to search products by name
class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear search and show all products
class ClearSearchEvent extends ProductEvent {
  const ClearSearchEvent();
}

/// Event to refresh the product list
class RefreshProductsEvent extends ProductEvent {
  const RefreshProductsEvent();
}