import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catatan_keuangan/providers/cart_provider.dart';
import 'package:catatan_keuangan/providers/product_provider.dart';
import 'package:catatan_keuangan/providers/checkout_provider.dart';
import 'package:catatan_keuangan/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final cartProvider = CartProvider();
            cartProvider.loadCartFromPrefs();
            return cartProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final productProvider = ProductProvider();
            productProvider.loadProducts();
            return productProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final checkoutProvider = CheckoutProvider();
            checkoutProvider.loadHistory();
            return checkoutProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TOKU',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {'/home': (context) => const HomeScreen()},
    );
  }
}
