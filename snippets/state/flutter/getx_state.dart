import 'package:get/get.dart';
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

// Controller
class CartController extends GetxController {
  final _items = <String, CartItem>{}.obs;

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(String id, String name, double price) {
    if (_items.containsKey(id)) {
      final existing = _items[id]!;
      _items[id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _items[id] = CartItem(id: id, name: name, price: price);
    }
  }

  void removeItem(String id) {
    _items.remove(id);
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      if (quantity <= 0) {
        removeItem(id);
      } else {
        _items[id] = _items[id]!.copyWith(quantity: quantity);
      }
    }
  }

  void clear() {
    _items.clear();
  }
}

// Example usage in a widget
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Cart (${controller.itemCount} items)')),
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items.values.elementAt(index);
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => controller.removeItem(item.id),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: \$${controller.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addItem('1', 'Product 1', 29.99);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Alternative: Using GetBuilder for more granular control
class CartScreenWithGetBuilder extends StatelessWidget {
  const CartScreenWithGetBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: CartController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Cart (${controller.itemCount} items)'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items.values.elementAt(index);
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => controller.removeItem(item.id),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${controller.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.addItem('1', 'Product 1', 29.99);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
