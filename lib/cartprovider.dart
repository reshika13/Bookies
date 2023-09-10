import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  final List<Product> _cart = [];

  List<Product> get cart => _cart;

  void addProduct(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _cart.remove(product);
    notifyListeners();
  }
}

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}
