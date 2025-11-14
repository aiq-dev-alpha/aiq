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

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddItemEvent extends CartEvent {
  final String id;
  final String name;
  final double price;

  const AddItemEvent(this.id, this.name, this.price);

  @override
  List<Object?> get props => [id, name, price];
}

class RemoveItemEvent extends CartEvent {
  final String id;

  const RemoveItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateQuantityEvent extends CartEvent {
  final String id;
  final int quantity;

  const UpdateQuantityEvent(this.id, this.quantity);

  @override
  List<Object?> get props => [id, quantity];
}

class ClearCartEvent extends CartEvent {}

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

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddItemEvent>(_onAddItem);
    on<RemoveItemEvent>(_onRemoveItem);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddItem(AddItemEvent event, Emitter<CartState> emit) {
    final updatedItems = Map<String, CartItem>.from(state.items);

    if (updatedItems.containsKey(event.id)) {
      final existing = updatedItems[event.id]!;
      updatedItems[event.id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      updatedItems[event.id] = CartItem(
        id: event.id,
        name: event.name,
        price: event.price,
      );
    }

    emit(state.copyWith(items: updatedItems));
  }

  void _onRemoveItem(RemoveItemEvent event, Emitter<CartState> emit) {
    final updatedItems = Map<String, CartItem>.from(state.items);
    updatedItems.remove(event.id);
    emit(state.copyWith(items: updatedItems));
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    final updatedItems = Map<String, CartItem>.from(state.items);

    if (updatedItems.containsKey(event.id)) {
      if (event.quantity <= 0) {
        updatedItems.remove(event.id);
      } else {
        updatedItems[event.id] = updatedItems[event.id]!.copyWith(quantity: event.quantity);
      }
    }

    emit(state.copyWith(items: updatedItems));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}

// Example usage in a widget
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Text('Cart (${state.itemCount} items)');
            },
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
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
                            context.read<CartBloc>().add(RemoveItemEvent(item.id));
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
      ),
    );
  }
}
