import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/authentication/modals/user.dart';
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

  User? user;

  final List<String> tableColumns = [
    'Desc',
    'Quantity',
    'Price',
    'Tax',
    'Amount'
  ];

  @override
  void didChangeDependencies() {
    order = ModalRoute.of(context)!.settings.arguments! as Order;
    Provider.of<AuthProvider>(context, listen: false).getUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AuthProvider>(context, listen: false).user;
    final itemTotal = order.amount! - (order.deliveryCharge! + order.tax!);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Invoice'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SHIP TO:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${user?.address?.area ?? ''},\n${user?.address?.city ?? ''}, ${user?.address?.state ?? ''}',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ORDER ID: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(order.id ?? '')
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'DELIVERD IN: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('3 to 5 working days')
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DATE: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                DateFormat.yMMMMd('en_US').format(order.dateTime!),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NAME: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(user?.name ?? '')
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: DataTable(
              columnSpacing: 25,
              columns: tableColumns
                  .map((columnName) => DataColumn(label: Text(columnName)))
                  .toList(),
              rows: order.products!.map(
                (item) {
                  final itemTax =
                      (((item.price ?? 0.0) * item.taxPercentage!) / 100) *
                          item.quantity!;

                  final total = itemTax + (item.price! * item.quantity!);
                  return DataRow(
                    cells: [
                      DataCell(
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 80),
                                child: Text(
                                  '${item.title}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text('${item.quantity ?? 0.0}')),
                      DataCell(Text('${item.price ?? ''}')),
                      DataCell(Text(itemTax.toStringAsFixed(2))),
                      DataCell(Text(total.toStringAsFixed(2))),
                    ],
                  );
                },
              ).toList(),
            ),
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
