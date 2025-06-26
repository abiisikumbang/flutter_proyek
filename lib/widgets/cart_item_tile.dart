import 'package:flutter/material.dart';
import '../models/sampah_item.dart';

class CartItemTile extends StatelessWidget {
  final SampahItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('Poin: ${item.points.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onDecrement, icon: const Icon(Icons.remove)),
            Text('${item.quantity}'),
            IconButton(onPressed: onIncrement, icon: const Icon(Icons.add)),
            IconButton(onPressed: onRemove, icon: const Icon(Icons.delete, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}