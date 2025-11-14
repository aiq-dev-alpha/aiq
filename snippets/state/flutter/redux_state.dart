import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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

// State
class AppState {
  final Map<String, CartItem> items;

  AppState({required this.items});

  AppState.initial() : items = {};

  int get itemCount => items.length;

  double get totalAmount {
    return items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  AppState copyWith({Map<String, CartItem>? items}) {
    return AppState(items: items ?? this.items);
  }
}

// Actions
abstract class CartAction {}

class AddItemAction extends CartAction {
  final String id;
  final String name;
  final double price;

  AddItemAction(this.id, this.name, this.price);
}

class RemoveItemAction extends CartAction {
  final String id;

  RemoveItemAction(this.id);
}

class UpdateQuantityAction extends CartAction {
  final String id;
  final int quantity;

  UpdateQuantityAction(this.id, this.quantity);
}

class ClearCartAction extends CartAction {}

// Reducer
AppState cartReducer(AppState state, dynamic action) {
  if (action is AddItemAction) {
    final updatedItems = Map<String, CartItem>.from(state.items);

    if (updatedItems.containsKey(action.id)) {
      final existing = updatedItems[action.id]!;
      updatedItems[action.id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      updatedItems[action.id] = CartItem(
        id: action.id,
        name: action.name,
        price: action.price,
      );
    }

    return state.copyWith(items: updatedItems);
  }

  if (action is RemoveItemAction) {
    final updatedItems = Map<String, CartItem>.from(state.items);
    updatedItems.remove(action.id);
    return state.copyWith(items: updatedItems);
  }

  if (action is UpdateQuantityAction) {
    final updatedItems = Map<String, CartItem>.from(state.items);

    if (updatedItems.containsKey(action.id)) {
      if (action.quantity <= 0) {
        updatedItems.remove(action.id);
      } else {
        updatedItems[action.id] = updatedItems[action.id]!.copyWith(quantity: action.quantity);
      }
    }

    return state.copyWith(items: updatedItems);
  }

  if (action is ClearCartAction) {
    return AppState.initial();
  }

  return state;
}

// Middleware (optional - for logging, async operations, etc.)
void loggingMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  print('Action: $action');
  next(action);
  print('State after action: ${store.state.items.length} items');
}

// Store initialization
Store<AppState> createStore() {
  return Store<AppState>(
    cartReducer,
    initialState: AppState.initial(),
    middleware: [loggingMiddleware],
  );
}

// Example usage in main app
class MyApp extends StatelessWidget {
  final Store<AppState> store = createStore();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Cart Example',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const CartScreen(),
      ),
    );
  }
}

// Example usage in a widget
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreConnector<AppState, int>(
          converter: (store) => store.state.itemCount,
          builder: (context, itemCount) {
            return Text('Cart ($itemCount items)');
          },
        ),
      ),
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.items.isEmpty
                    ? const Center(child: Text('Cart is empty'))
                    : ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items.values.elementAt(index);
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    StoreProvider.of<AppState>(context).dispatch(
                                      UpdateQuantityAction(item.id, item.quantity - 1),
                                    );
                                  },
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    StoreProvider.of<AppState>(context).dispatch(
                                      UpdateQuantityAction(item.id, item.quantity + 1),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    StoreProvider.of<AppState>(context).dispatch(
                                      RemoveItemAction(item.id),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    StoreConnector<AppState, double>(
                      converter: (store) => store.state.totalAmount,
                      builder: (context, totalAmount) {
                        return Text(
                          'Total: \$${totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            StoreProvider.of<AppState>(context).dispatch(
                              AddItemAction(
                                DateTime.now().millisecondsSinceEpoch.toString(),
                                'Product ${state.items.length + 1}',
                                29.99,
                              ),
                            );
                          },
                          child: const Text('Add Item'),
                        ),
                        ElevatedButton(
                          onPressed: state.items.isEmpty
                              ? null
                              : () {
                                  StoreProvider.of<AppState>(context).dispatch(ClearCartAction());
                                },
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

// Alternative: Using distinct to optimize rebuilds
class OptimizedCartScreen extends StatelessWidget {
  const OptimizedCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreConnector<AppState, int>(
          distinct: true,
          converter: (store) => store.state.itemCount,
          builder: (context, itemCount) {
            return Text('Cart ($itemCount items)');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StoreConnector<AppState, List<CartItem>>(
              distinct: true,
              converter: (store) => store.state.items.values.toList(),
              builder: (context, items) {
                return items.isEmpty
                    ? const Center(child: Text('Cart is empty'))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                  RemoveItemAction(item.id),
                                );
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StoreConnector<AppState, double>(
              distinct: true,
              converter: (store) => store.state.totalAmount,
              builder: (context, totalAmount) {
                return Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
