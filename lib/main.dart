import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/repository/product_repository.dart';
import 'core/repository/product_repository_impl.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/presentation/cubit/product_form_cubit.dart';
import 'features/product/presentation/pages/product_list_page.dart';

void main() {
  runApp(const InventoryApp());
}

/// Main application widget for the Inventory Control app
class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Repository providers
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Product Bloc provider
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(
              repository: context.read<ProductRepository>(),
            ),
          ),
          // Product Form Cubit provider
          BlocProvider<ProductFormCubit>(
            create: (context) => ProductFormCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Inventory Control',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // Modern Material 3 theme
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            ),
            
            // Typography
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              headlineLarge: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            
            // AppBar theme
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.indigo[600],
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            // Card theme
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
            
            // Input decoration theme
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.indigo[600]!),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            
            // Elevated button theme
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            
            // Floating action button theme
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo[600],
              foregroundColor: Colors.white,
            ),
            
            // Snackbar theme
            snackBarTheme: const SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          home: const AppInitializer(),
        ),
      ),
    );
  }
}

/// Widget that handles app initialization and sample data loading
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Add sample data if repository is empty
      final repository = context.read<ProductRepository>();
      if (repository is ProductRepositoryImpl) {
        await repository.addSampleData();
      }
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      // If initialization fails, still show the app
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.indigo[600],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Inventory Control',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Initializing application...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return const ProductListPage();
  }
}


