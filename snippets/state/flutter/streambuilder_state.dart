import 'package:flutter/material.dart';
import 'dart:async';

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

// Cart Manager using Streams
class CartManager {
  final _itemsController = StreamController<Map<String, CartItem>>.broadcast();
  Map<String, CartItem> _items = {};

  Stream<Map<String, CartItem>> get itemsStream => _itemsController.stream;

  Stream<int> get itemCountStream => itemsStream.map((items) => items.length);

  Stream<double> get totalAmountStream {
    return itemsStream.map((items) {
      return items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    });
  }

  void addItem(String id, String name, double price) {
    if (_items.containsKey(id)) {
      final existing = _items[id]!;
      _items[id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _items[id] = CartItem(id: id, name: name, price: price);
    }
    _itemsController.add(_items);
  }

  void removeItem(String id) {
    _items.remove(id);
    _itemsController.add(_items);
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      if (quantity <= 0) {
        _items.remove(id);
      } else {
        _items[id] = _items[id]!.copyWith(quantity: quantity);
      }
    }
    _itemsController.add(_items);
  }

  void clear() {
    _items = {};
    _itemsController.add(_items);
  }

  void dispose() {
    _itemsController.close();
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
        title: StreamBuilder<int>(
          stream: _cartManager.itemCountStream,
          initialData: 0,
          builder: (context, snapshot) {
            return Text('Cart (${snapshot.data} items)');
          },
        ),
      ),
      body: StreamBuilder<Map<String, CartItem>>(
        stream: _cartManager.itemsStream,
        initialData: const {},
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? {};
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
                    StreamBuilder<double>(
                      stream: _cartManager.totalAmountStream,
                      initialData: 0.0,
                      builder: (context, snapshot) {
                        return Text(
                          'Total: \$${(snapshot.data ?? 0.0).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        );
                      },
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

// Timer Example with StreamBuilder
class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Stream<int> _timerStream() {
    return Stream.periodic(
      const Duration(seconds: 1),
      (count) => count,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Example'),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: _timerStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('Not connected');
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.active:
              case ConnectionState.done:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Seconds elapsed:'),
                    Text(
                      '${snapshot.data ?? 0}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

// FutureBuilder Example for async data
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'age': 30,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${user['name']}'),
                const SizedBox(height: 8),
                Text('Email: ${user['email']}'),
                const SizedBox(height: 8),
                Text('Age: ${user['age']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
