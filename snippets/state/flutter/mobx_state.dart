import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';

// Include generated file
part 'mobx_example.g.dart';

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

// Store
class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  ObservableMap<String, CartItem> items = ObservableMap<String, CartItem>();

  @computed
  int get itemCount => items.length;

  @computed
  double get totalAmount {
    return items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @action
  void addItem(String id, String name, double price) {
    if (items.containsKey(id)) {
      final existing = items[id]!;
      items[id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      items[id] = CartItem(id: id, name: name, price: price);
    }
  }

  @action
  void removeItem(String id) {
    items.remove(id);
  }

  @action
  void updateQuantity(String id, int quantity) {
    if (items.containsKey(id)) {
      if (quantity <= 0) {
        removeItem(id);
      } else {
        items[id] = items[id]!.copyWith(quantity: quantity);
      }
    }
  }

  @action
  void clear() {
    items.clear();
  }
}

// Example usage in a widget
class CartScreen extends StatelessWidget {
  final CartStore store = CartStore();

  CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) => Text('Cart (${store.itemCount} items)'),
        ),
      ),
      body: Observer(
        builder: (_) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: store.items.length,
                  itemBuilder: (context, index) {
                    final item = store.items.values.elementAt(index);
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => store.removeItem(item.id),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Observer(
                  builder: (_) => Text(
                    'Total: \$${store.totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          store.addItem('1', 'Product 1', 29.99);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// To generate the .g.dart file, run:
// flutter pub run build_runner build
// Or for watch mode:
// flutter pub run build_runner watch
