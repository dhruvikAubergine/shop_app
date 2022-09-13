import 'package:flutter/material.dart';

class OrderPriceWidget extends StatelessWidget {
  const OrderPriceWidget({
    super.key,
    required this.tax,
    required this.amount,
    required this.grandTotal,
    required this.deliveryCharge,
  });

  final double tax;
  final double amount;
  final double grandTotal;
  final double deliveryCharge;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Item total',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            trailing: Text(
              '\$ ${amount.toStringAsFixed(2)}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            visualDensity: const VisualDensity(vertical: -4),
          ),
          ListTile(
            title: const Text('Delivery Charge'),
            trailing: Text('\$${deliveryCharge.toStringAsFixed(2)}'),
            visualDensity: const VisualDensity(vertical: -4),
          ),
          ListTile(
            title: const Text('Gov. Tax'),
            trailing: Text('\$${tax.toStringAsFixed(2)}'),
            visualDensity: const VisualDensity(vertical: -4),
          ),
          ListTile(
            title: const Text(
              'Grand total',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(
              '\$${grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            visualDensity: const VisualDensity(vertical: -4),
          ),
        ],
      ),
    );
  }
}
