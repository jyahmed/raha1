import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: cart.itemCount > 0
              ? FloatingActionButton.extended(
                  key: const ValueKey('visible-cart-button'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/order_confirmation');
                  },
                  backgroundColor: const Color(0xFF153A6B),
                  icon: Stack(
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.white),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            cart.itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  label: Text(
                    '${cart.totalAmount.toStringAsFixed(0)} ر.س',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('hidden-cart-button')),
        );
      },
    );
  }
}
