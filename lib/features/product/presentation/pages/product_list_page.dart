import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_list_item.dart';
import '../widgets/search_bar_widget.dart';
import 'product_form_page.dart';

/// Main page that displays the list of products with search functionality
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load products when the page is first created
    context.read<ProductBloc>().add(const LoadProductsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Inventory Control',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<ProductBloc>().add(const RefreshProductsEvent());
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search section
          Container(
            color: Colors.indigo[600],
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SearchBarWidget(
              controller: _searchController,
              onSearchChanged: (query) {
                context.read<ProductBloc>().add(SearchProductsEvent(query));
              },
              onClearSearch: () {
                _searchController.clear();
                context.read<ProductBloc>().add(const ClearSearchEvent());
              },
            ),
          ),
          // Product list section
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                // Show success/error messages
                if (state is ProductOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (state is ProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () {
                          context.read<ProductBloc>().add(const LoadProductsEvent());
                        },
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return _buildBody(context, state);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddProduct(context),
        backgroundColor: Colors.indigo[600],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  /// Build the main body content based on the current state
  Widget _buildBody(BuildContext context, ProductState state) {
    if (state is ProductsLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is ProductsEmpty) {
      return _buildEmptyState(context, state.message);
    }

    if (state is ProductsLoaded ||
        state is ProductOperationSuccess ||
        state is ProductError) {
      List<Product> products = [];
      String searchQuery = '';
      bool isSearching = false;

      if (state is ProductsLoaded) {
        products = state.filteredProducts;
        searchQuery = state.searchQuery;
        isSearching = state.isSearching;
      } else if (state is ProductOperationSuccess) {
        products = state.filteredProducts;
        searchQuery = state.searchQuery;
        isSearching = state.isSearching;
      } else if (state is ProductError) {
        products = state.filteredProducts;
        searchQuery = state.searchQuery;
        isSearching = state.isSearching;
      }

      if (products.isEmpty && isSearching) {
        return _buildNoSearchResults(context, searchQuery);
      }

      if (products.isEmpty) {
        return _buildEmptyState(context, 'No products found');
      }

      return _buildProductList(context, products, isSearching, searchQuery);
    }

    return _buildEmptyState(context, 'Something went wrong');
  }

  /// Build the product list
  Widget _buildProductList(BuildContext context, List<Product> products, bool isSearching, String searchQuery) {
    return Column(
      children: [
        // Results header
        if (isSearching)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Text(
              'Found ${products.length} product(s) for "$searchQuery"',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        // Product list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<ProductBloc>().add(const RefreshProductsEvent());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProductListItem(
                    product: product,
                    onEdit: () => _navigateToEditProduct(context, product),
                    onDelete: () => _showDeleteConfirmation(context, product),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first product',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddProduct(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Build no search results widget
  Widget _buildNoSearchResults(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products found for "$query"',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              context.read<ProductBloc>().add(const ClearSearchEvent());
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear Search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to add product page
  Future<void> _navigateToAddProduct(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const ProductFormPage(),
      ),
    );

    // Refresh the list if a product was added
    if (result == true && mounted) {
      context.read<ProductBloc>().add(const LoadProductsEvent());
    }
  }

  /// Navigate to edit product page
  Future<void> _navigateToEditProduct(BuildContext context, Product product) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ProductFormPage(product: product),
      ),
    );

    // Refresh the list if a product was updated
    if (result == true && mounted) {
      context.read<ProductBloc>().add(const LoadProductsEvent());
    }
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteConfirmation(BuildContext context, Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<ProductBloc>().add(DeleteProductEvent(product.id));
    }
  }
}