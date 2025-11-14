import 'package:flutter/material.dart';

// Model
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}

// Cart Manager using ValueNotifier
class CartManager {
  final ValueNotifier<Map<String, CartItem>> items = ValueNotifier({});

  ValueNotifier<int> get itemCount => ValueNotifier(items.value.length);

  ValueNotifier<double> get totalAmount {
    final total = items.value.values.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    return ValueNotifier(total);
  }

  void addItem(String id, String name, double price) {
    final updatedItems = Map<String, CartItem>.from(items.value);

    if (updatedItems.containsKey(id)) {
      final existing = updatedItems[id]!;
      updatedItems[id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      updatedItems[id] = CartItem(id: id, name: name, price: price);
    }

    items.value = updatedItems;
  }

  void removeItem(String id) {
    final updatedItems = Map<String, CartItem>.from(items.value);
    updatedItems.remove(id);
    items.value = updatedItems;
  }

  void updateQuantity(String id, int quantity) {
    final updatedItems = Map<String, CartItem>.from(items.value);

    if (updatedItems.containsKey(id)) {
      if (quantity <= 0) {
        updatedItems.remove(id);
      } else {
        updatedItems[id] = updatedItems[id]!.copyWith(quantity: quantity);
      }
    }

    items.value = updatedItems;
  }

  void clear() {
    items.value = {};
  }

  void dispose() {
    items.dispose();
  }
}

// Example usage in a widget
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartManager _cartManager = CartManager();

  @override
  void dispose() {
    _cartManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<Map<String, CartItem>>(
          valueListenable: _cartManager.items,
          builder: (context, items, child) {
            return Text('Cart (${items.length} items)');
          },
        ),
      ),
      body: ValueListenableBuilder<Map<String, CartItem>>(
        valueListenable: _cartManager.items,
        builder: (context, items, child) {
          final total = items.values.fold(
            0.0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          return Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Cart is empty'))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items.values.elementAt(index);
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _cartManager.removeItem(item.id),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _cartManager.addItem(
                            DateTime.now().millisecondsSinceEpoch.toString(),
                            'Product ${items.length + 1}',
                            29.99,
                          ),
                          child: const Text('Add Item'),
                        ),
                        ElevatedButton(
                          onPressed: items.isEmpty ? null : _cartManager.clear,
                          child: const Text('Clear Cart'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Simple Counter Example with ValueNotifier
class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    _counter.value++;
  }

  void _decrementCounter() {
    _counter.value--;
  }

  void _resetCounter() {
    _counter.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Counter Value:'),
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (context, value, child) {
                return Text(
                  '$value',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _resetCounter,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
