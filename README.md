# Flutter Inventory Control Application

A comprehensive Flutter inventory management application built with **Bloc Architecture** for state management. This application demonstrates modern Flutter development practices with clean architecture, proper state management, and a beautiful user interface.

## Features

### 📦 Core Functionality
- **CRUD Operations**: Create, Read, Update, Delete products
- **Search & Filter**: Real-time product search by name
- **Low Stock Alerts**: Visual warnings for products with low inventory
- **Form Validation**: Comprehensive input validation with error messages
- **Persistent Storage**: Local data storage using SharedPreferences

### 🎨 User Interface
- **Modern Design**: Clean, intuitive interface with Material 3 design
- **Responsive Layout**: Adapts to different screen sizes
- **Visual Feedback**: Loading states, success/error messages
- **Interactive Elements**: Pull-to-refresh, tap to edit, confirmation dialogs

### 🏗️ Architecture
- **Bloc Pattern**: Proper separation of business logic and UI
- **Repository Pattern**: Abstract data layer for easy testing and maintenance
- **Clean Architecture**: Organized code structure with clear dependencies

## Project Structure

```
lib/
├── core/
│   ├── models/
│   │   └── product.dart                 # Product model with JSON serialization
│   └── repository/
│       ├── product_repository.dart      # Abstract repository interface
│       └── product_repository_impl.dart # SharedPreferences implementation
├── features/
│   └── product/
│       └── presentation/
│           ├── bloc/
│           │   ├── product_bloc.dart    # Main product state management
│           │   ├── product_event.dart   # Product events definition
│           │   └── product_state.dart   # Product states definition
│           ├── cubit/
│           │   └── product_form_cubit.dart # Form validation cubit
│           ├── pages/
│           │   ├── product_list_page.dart  # Main product list screen
│           │   └── product_form_page.dart  # Add/Edit product screen
│           └── widgets/
│               ├── product_list_item.dart  # Product card widget
│               └── search_bar_widget.dart  # Search functionality widget
└── main.dart                           # App entry point with providers
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  flutter_bloc: ^8.1.3      # State management
  equatable: ^2.0.5         # Value equality
  shared_preferences: ^2.2.2 # Local storage
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter-inventory-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## Usage Guide

### 📱 Main Product List Screen
- **View Products**: See all products with stock levels and prices
- **Search**: Use the search bar to filter products by name
- **Low Stock Warning**: Products with less than 10 units show orange indicators
- **Add Product**: Tap the floating action button to add new products
- **Edit Product**: Tap on any product card to edit
- **Delete Product**: Tap the delete icon and confirm

### ✏️ Add/Edit Product Screen
- **Product Name**: Required field (2-50 characters)
- **Stock Quantity**: Required number field (0-999,999)
- **Unit Price**: Optional decimal field
- **Real-time Validation**: Instant feedback on form errors
- **Auto-save**: Form remembers data during editing

### 🔍 Search Functionality
- **Real-time Search**: Results update as you type
- **Clear Search**: X button to clear and show all products
- **No Results**: Helpful message when no products match

## Bloc Architecture Implementation

### ProductBloc
**Events:**
- `LoadProductsEvent` - Load all products
- `AddProductEvent` - Add new product
- `UpdateProductEvent` - Update existing product
- `DeleteProductEvent` - Delete product
- `SearchProductsEvent` - Search products
- `ClearSearchEvent` - Clear search
- `RefreshProductsEvent` - Refresh product list

**States:**
- `ProductInitial` - Initial state
- `ProductsLoading` - Loading indicator
- `ProductsLoaded` - Products successfully loaded
- `ProductsEmpty` - No products found
- `ProductOperationInProgress` - Operation in progress
- `ProductOperationSuccess` - Operation completed successfully
- `ProductError` - Error occurred

### ProductFormCubit
**Features:**
- Real-time form validation
- Field-specific error messages
- Form state management
- Product creation/editing logic

## Data Model

```dart
class Product {
  final String id;           // Unique identifier
  final String name;         // Product name
  final int stock;          // Stock quantity
  final double? price;      // Optional unit price
  final DateTime lastModified; // Last modified timestamp
  
  bool get hasLowStock => stock < 10; // Low stock indicator
}
```

## Key Features Explained

### 🔒 Form Validation
- **Name**: Required, 2-50 characters
- **Stock**: Required, non-negative integer
- **Price**: Optional, non-negative decimal
- **Real-time feedback**: Validation on every keystroke

### 📊 Visual Stock Indicators
- **Green**: Normal stock (≥10 units)
- **Orange**: Low stock (<10 units)
- **Red**: Out of stock (0 units)

### 💾 Data Persistence
- Uses SharedPreferences for local storage
- JSON serialization for complex data
- Automatic sample data generation
- Error handling for storage operations

### 🎯 State Management Best Practices
- **Separation of Concerns**: UI and business logic separated
- **Immutable States**: All states are immutable for predictability
- **Event-Driven**: Actions trigger events, not direct state mutations
- **Error Handling**: Comprehensive error states and user feedback

## Testing

The application is structured to support easy testing:

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the established architecture patterns
4. Add tests for new features
5. Submit a pull request

## Architecture Benefits

### 🔄 Maintainability
- **Clear separation** of UI, business logic, and data
- **Easy to modify** individual components without affecting others
- **Consistent patterns** throughout the application

### 🧪 Testability
- **Business logic** is easily testable in isolation
- **Repository pattern** allows for easy mocking
- **Pure functions** in Blocs/Cubits for predictable testing

### 📈 Scalability
- **Modular structure** allows for easy feature additions
- **Repository abstraction** enables different data sources
- **Bloc pattern** scales well with application complexity

## Common Issues & Solutions

### Issue: Products not loading
**Solution**: Check if SharedPreferences permissions are available

### Issue: Form validation not working
**Solution**: Ensure ProductFormCubit is properly provided in the widget tree

### Issue: Search not responsive
**Solution**: Verify debouncing is working correctly in the search implementation

## Performance Optimizations

- **Efficient List Rendering**: Uses ListView.builder for large lists
- **State Preservation**: Maintains search state during operations
- **Memory Management**: Proper disposal of controllers and listeners
- **Minimal Rebuilds**: Strategic use of BlocBuilder vs BlocListener

## Future Enhancements

- **Categories**: Product categorization
- **Barcode Scanning**: Quick product addition
- **Export/Import**: CSV/Excel support
- **Multi-user**: User authentication and permissions
- **Cloud Sync**: Remote data synchronization
- **Analytics**: Inventory reports and insights

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please create an issue in the repository or contact the development team.

---

**Built with ❤️ using Flutter and Bloc Architecture**
