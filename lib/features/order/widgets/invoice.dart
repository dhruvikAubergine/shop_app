import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/authentication/modals/address.dart';
import 'package:shop_app/features/authentication/providers/auth_provider.dart';
import 'package:shop_app/features/cart/widgets/order_price_widget.dart';
import 'package:shop_app/features/order/models/order.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});
  static const routeName = '/invoice';

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  late final Order order;

  Address? address;

  @override
  void didChangeDependencies() {
    order = ModalRoute.of(context)!.settings.arguments! as Order;
    Provider.of<AuthProvider>(context, listen: false).getAddress();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    address = Provider.of<AuthProvider>(context, listen: false).address;
    final itemTotal = order.amount! - (order.deliveryCharge! + order.tax!);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Invoice'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Text(
            'SHIP TO:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${address?.area ?? ''},\n${address?.city ?? ''},\n${address?.state ?? ''}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'DATE:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat.yMMMMd('en_US').format(order.dateTime!),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Card(
            child: ListTile(
              leading: Text(
                'Desc',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                'Unit Price',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                'Amount',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: order.products!.length,
            itemBuilder: (context, index) {
              final item = order.products![index];
              final amount = (item.price!) * (item.quantity!);
              return ListTile(
                leading: Text(
                  item.title ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                title: Text(
                  '${item.price}  X${item.quantity}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                trailing: Text(
                  '$amount',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          OrderPriceWidget(
            amount: itemTotal,
            deliveryCharge: order.deliveryCharge!,
            tax: order.tax!,
            grandTotal: order.amount!,
          )
        ],
      ),
    );
  }
}
