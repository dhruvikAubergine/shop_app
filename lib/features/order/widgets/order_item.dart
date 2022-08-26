import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/features/order/models/order.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({super.key, required this.order});
  final Order order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle:
                Text(DateFormat.yMMMMd('en_US').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(
                _expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            SizedBox(
              height: min(widget.order.product.length * 10.0 + 50, 180),
              child: ListView(
                padding: const EdgeInsets.all(10) +
                    const EdgeInsets.only(bottom: 10),
                children: widget.order.product
                    .map(
                      (product) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${product.quantity}X  \$${product.price}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
