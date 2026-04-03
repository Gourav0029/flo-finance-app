import 'package:flutter/material.dart';

class TransactionIcon extends StatelessWidget {
  final String category;
  const TransactionIcon({super.key, required this.category});

  IconData getIcon() {
    switch (category.toLowerCase()) {
      case 'food':
      case 'dining': return Icons.restaurant;
      case 'transport': return Icons.directions_car;
      case 'shopping': return Icons.shopping_bag;
      case 'income':
      case 'salary': return Icons.account_balance_wallet;
      case 'utilities':
      case 'bills': return Icons.electric_bolt;
      case 'entertainment': return Icons.movie;
      case 'health': return Icons.favorite;
      default: return Icons.category;
    }
  }

  Color getColor() {
    switch (category.toLowerCase()) {
      case 'food':
      case 'dining': return Colors.orange;
      case 'transport': return Colors.blue;
      case 'shopping': return Colors.purple;
      case 'income':
      case 'salary': return Colors.green;
      case 'utilities':
      case 'bills': return Colors.amber;
      case 'entertainment': return Colors.pink;
      case 'health': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: getColor().withAlpha(25),
        shape: BoxShape.circle,
      ),
      child: Icon(getIcon(), color: getColor()),
    );
  }
}
