import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// State Notifier
class CartNotifier extends StateNotifier<Map<String, CartItem>> {
  CartNotifier() : super({});

  void addItem(String id, String name, double price) {
    if (state.containsKey(id)) {
      final existing = state[id]!;
      state = {
        ...state,
        id: existing.copyWith(quantity: existing.quantity + 1),
      };
    } else {
      state = {
        ...state,
        id: CartItem(id: id, name: name, price: price),
      };
    }
  }

  void removeItem(String id) {
    final newState = Map<String, CartItem>.from(state);
    newState.remove(id);
    state = newState;
  }

  void updateQuantity(String id, int quantity) {
    if (state.containsKey(id)) {
      if (quantity <= 0) {
        removeItem(id);
      } else {
        state = {
          ...state,
          id: state[id]!.copyWith(quantity: quantity),
        };
      }
    }
  }

  void clear() {
    state = {};
  }
}

// Providers
final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartItem>>((ref) {
  return CartNotifier();
});

final itemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.length;
});

final totalAmountProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
});

// Example usage in a widget
class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final total = ref.watch(totalAmountProvider);
    final count = ref.watch(itemCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart ($count items)'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart.values.elementAt(index);
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => ref.read(cartProvider.notifier).removeItem(item.id),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
