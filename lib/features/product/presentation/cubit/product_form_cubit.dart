import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/product.dart';

/// State class for product form
class ProductFormState extends Equatable {
  final String name;
  final String stock;
  final String price;
  final String? nameError;
  final String? stockError;
  final String? priceError;
  final bool isValid;
  final bool isEditing;
  final Product? originalProduct;

  const ProductFormState({
    this.name = '',
    this.stock = '',
    this.price = '',
    this.nameError,
    this.stockError,
    this.priceError,
    this.isValid = false,
    this.isEditing = false,
    this.originalProduct,
  });

  /// Create a copy with modified values
  ProductFormState copyWith({
    String? name,
    String? stock,
    String? price,
    String? nameError,
    String? stockError,
    String? priceError,
    bool? isValid,
    bool? isEditing,
    Product? originalProduct,
  }) {
    return ProductFormState(
      name: name ?? this.name,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      nameError: nameError,
      stockError: stockError,
      priceError: priceError,
      isValid: isValid ?? this.isValid,
      isEditing: isEditing ?? this.isEditing,
      originalProduct: originalProduct ?? this.originalProduct,
    );
  }

  @override
  List<Object?> get props => [
        name,
        stock,
        price,
        nameError,
        stockError,
        priceError,
        isValid,
        isEditing,
        originalProduct,
      ];
}

/// Cubit that manages the product form state and validation
class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit() : super(const ProductFormState());

  /// Initialize form for adding a new product
  void initializeForAdd() {
    emit(const ProductFormState());
  }

  /// Initialize form for editing an existing product
  void initializeForEdit(Product product) {
    emit(ProductFormState(
      name: product.name,
      stock: product.stock.toString(),
      price: product.price?.toString() ?? '',
      isValid: true, // Existing product should be valid
      isEditing: true,
      originalProduct: product,
    ));
  }

  /// Update product name and validate
  void updateName(String name) {
    final nameError = _validateName(name);
    final currentState = state;
    
    emit(currentState.copyWith(
      name: name,
      nameError: nameError,
      isValid: _isFormValid(
        name: name,
        stock: currentState.stock,
        price: currentState.price,
        nameError: nameError,
        stockError: currentState.stockError,
        priceError: currentState.priceError,
      ),
    ));
  }

  /// Update stock quantity and validate
  void updateStock(String stock) {
    final stockError = _validateStock(stock);
    final currentState = state;
    
    emit(currentState.copyWith(
      stock: stock,
      stockError: stockError,
      isValid: _isFormValid(
        name: currentState.name,
        stock: stock,
        price: currentState.price,
        nameError: currentState.nameError,
        stockError: stockError,
        priceError: currentState.priceError,
      ),
    ));
  }

  /// Update price and validate
  void updatePrice(String price) {
    final priceError = _validatePrice(price);
    final currentState = state;
    
    emit(currentState.copyWith(
      price: price,
      priceError: priceError,
      isValid: _isFormValid(
        name: currentState.name,
        stock: currentState.stock,
        price: price,
        nameError: currentState.nameError,
        stockError: currentState.stockError,
        priceError: priceError,
      ),
    ));
  }

  /// Validate all fields at once (useful for form submission)
  void validateAll() {
    final currentState = state;
    final nameError = _validateName(currentState.name);
    final stockError = _validateStock(currentState.stock);
    final priceError = _validatePrice(currentState.price);
    
    emit(currentState.copyWith(
      nameError: nameError,
      stockError: stockError,
      priceError: priceError,
      isValid: _isFormValid(
        name: currentState.name,
        stock: currentState.stock,
        price: currentState.price,
        nameError: nameError,
        stockError: stockError,
        priceError: priceError,
      ),
    ));
  }

  /// Create a Product object from the current form state
  Product? createProduct() {
    if (!state.isValid) return null;
    
    final stockValue = int.tryParse(state.stock) ?? 0;
    final priceValue = state.price.isEmpty ? null : double.tryParse(state.price);
    
    if (state.isEditing && state.originalProduct != null) {
      // Update existing product
      return state.originalProduct!.copyWith(
        name: state.name.trim(),
        stock: stockValue,
        price: priceValue,
        lastModified: DateTime.now(),
      );
    } else {
      // Create new product
      return Product.create(
        name: state.name.trim(),
        stock: stockValue,
        price: priceValue,
      );
    }
  }

  /// Clear the form
  void clearForm() {
    emit(const ProductFormState());
  }

  /// Validate product name
  String? _validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Product name is required';
    }
    if (name.trim().length < 2) {
      return 'Product name must be at least 2 characters';
    }
    if (name.trim().length > 50) {
      return 'Product name must be less than 50 characters';
    }
    return null;
  }

  /// Validate stock quantity
  String? _validateStock(String stock) {
    if (stock.trim().isEmpty) {
      return 'Stock quantity is required';
    }
    
    final stockValue = int.tryParse(stock);
    if (stockValue == null) {
      return 'Stock must be a valid number';
    }
    
    if (stockValue < 0) {
      return 'Stock cannot be negative';
    }
    
    if (stockValue > 999999) {
      return 'Stock value is too large';
    }
    
    return null;
  }

  /// Validate price (optional field)
  String? _validatePrice(String price) {
    if (price.trim().isEmpty) {
      return null; // Price is optional
    }
    
    final priceValue = double.tryParse(price);
    if (priceValue == null) {
      return 'Price must be a valid number';
    }
    
    if (priceValue < 0) {
      return 'Price cannot be negative';
    }
    
    if (priceValue > 999999.99) {
      return 'Price value is too large';
    }
    
    return null;
  }

  /// Check if the entire form is valid
  bool _isFormValid({
    required String name,
    required String stock,
    required String price,
    required String? nameError,
    required String? stockError,
    required String? priceError,
  }) {
    return nameError == null && stockError == null && priceError == null;
  }
}