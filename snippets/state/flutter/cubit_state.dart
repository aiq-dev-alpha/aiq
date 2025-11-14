import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

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
class CartState extends Equatable {
  final Map<String, CartItem> items;

  const CartState({this.items = const {}});

  int get itemCount => items.length;

  double get totalAmount {
    return items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  CartState copyWith({Map<String, CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}

// Cubit
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(String id, String name, double price) {
    final updatedItems = Map<String, CartItem>.from(state.items);

    if (updatedItems.containsKey(id)) {
      final existing = updatedItems[id]!;
      updatedItems[id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      updatedItems[id] = CartItem(
        id: id,
        name: name,
        price: price,
      );
    }

    emit(state.copyWith(items: updatedItems));
  }

  void removeItem(String id) {
    final updatedItems = Map<String, CartItem>.from(state.items);
    updatedItems.remove(id);
    emit(state.copyWith(items: updatedItems));
  }

  void updateQuantity(String id, int quantity) {
    final updatedItems = Map<String, CartItem>.from(state.items);

    if (updatedItems.containsKey(id)) {
      if (quantity <= 0) {
        updatedItems.remove(id);
      } else {
        updatedItems[id] = updatedItems[id]!.copyWith(quantity: quantity);
      }
    }

    emit(state.copyWith(items: updatedItems));
  }

  void clear() {
    emit(const CartState());
  }
}

// Example usage in a widget
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Text('Cart (${state.itemCount} items)');
            },
          ),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items.values.elementAt(index);
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<CartCubit>().removeItem(item.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$${state.totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<CartCubit>().addItem('1', 'Product 1', 29.99);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
