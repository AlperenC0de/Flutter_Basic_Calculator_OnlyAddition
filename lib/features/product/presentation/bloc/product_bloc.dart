import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/repository/product_repository.dart';
import '../../../../core/models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

/// Bloc that manages product state and handles product-related events
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc({required ProductRepository repository})
      : _repository = repository,
        super(const ProductInitial()) {
    // Register event handlers
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<SearchProductsEvent>(_onSearchProducts);
    on<ClearSearchEvent>(_onClearSearch);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }

  /// Handle loading products
  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductsLoading());
    
    try {
      final products = await _repository.getProducts();
      
      if (products.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        emit(ProductsLoaded(
          products: products,
          filteredProducts: products,
        ));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  /// Handle adding a new product
  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductOperationInProgress('adding'));
    
    try {
      await _repository.addProduct(event.product);
      final products = await _repository.getProducts();
      
      // Preserve search state if any
      final currentState = state;
      if (currentState is ProductsLoaded && currentState.isSearching) {
        final filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(currentState.searchQuery.toLowerCase());
        }).toList();
        
        emit(ProductOperationSuccess(
          message: 'Product added successfully',
          products: products,
          filteredProducts: filteredProducts,
          searchQuery: currentState.searchQuery,
          isSearching: true,
        ));
      } else {
        emit(ProductOperationSuccess(
          message: 'Product added successfully',
          products: products,
          filteredProducts: products,
        ));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  /// Handle updating an existing product
  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductOperationInProgress('updating'));
    
    try {
      await _repository.updateProduct(event.product);
      final products = await _repository.getProducts();
      
      // Preserve search state if any
      final currentState = state;
      if (currentState is ProductsLoaded && currentState.isSearching) {
        final filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(currentState.searchQuery.toLowerCase());
        }).toList();
        
        emit(ProductOperationSuccess(
          message: 'Product updated successfully',
          products: products,
          filteredProducts: filteredProducts,
          searchQuery: currentState.searchQuery,
          isSearching: true,
        ));
      } else {
        emit(ProductOperationSuccess(
          message: 'Product updated successfully',
          products: products,
          filteredProducts: products,
        ));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  /// Handle deleting a product
  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductOperationInProgress('deleting'));
    
    try {
      await _repository.deleteProduct(event.productId);
      final products = await _repository.getProducts();
      
      if (products.isEmpty) {
        emit(const ProductsEmpty(message: 'No products found'));
      } else {
        // Preserve search state if any
        final currentState = state;
        if (currentState is ProductsLoaded && currentState.isSearching) {
          final filteredProducts = products.where((product) {
            return product.name.toLowerCase().contains(currentState.searchQuery.toLowerCase());
          }).toList();
          
          emit(ProductOperationSuccess(
            message: 'Product deleted successfully',
            products: products,
            filteredProducts: filteredProducts,
            searchQuery: currentState.searchQuery,
            isSearching: true,
          ));
        } else {
          emit(ProductOperationSuccess(
            message: 'Product deleted successfully',
            products: products,
            filteredProducts: products,
          ));
        }
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  /// Handle searching products
  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final products = await _repository.getProducts();
      final filteredProducts = await _repository.searchProducts(event.query);
      
      emit(ProductsLoaded(
        products: products,
        filteredProducts: filteredProducts,
        searchQuery: event.query,
        isSearching: event.query.isNotEmpty,
      ));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  /// Handle clearing search
  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final products = await _repository.getProducts();
      
      if (products.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        emit(ProductsLoaded(
          products: products,
          filteredProducts: products,
          searchQuery: '',
          isSearching: false,
        ));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  /// Handle refreshing products
  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductsLoading());
    
    try {
      final products = await _repository.getProducts();
      
      if (products.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        emit(ProductsLoaded(
          products: products,
          filteredProducts: products,
        ));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}