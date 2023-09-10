import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cartprovider.dart';
import 'package:firebase_core/firebase_core.dart';

class MyCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body:
      Consumer<CartModel>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.cart.length,
            itemBuilder: (context, index) {
              final product = cart.cart[index];

              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.remove_shopping_cart),
                  onPressed: () {
                    cart.removeProduct(product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
