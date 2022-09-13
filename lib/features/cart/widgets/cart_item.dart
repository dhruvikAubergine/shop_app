import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/cart/provider/cart_provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
    required this.productId,
  });
  final String id;
  final String productId;
  final String title;
  final String image;
  final double quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content:
                  const Text('Do you want to remove the item from the cart?'),
              actions: [
                ElevatedButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text('Product deleted from the cart.'),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        cardProvider.removeItem(productId);
      },
      background: Container(
        alignment: Alignment.center,
        color: const Color.fromARGB(255, 245, 112, 102),
        child: const Text(
          'Delete ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(image),
          ),
          title: Text(title),
          subtitle: Text('\$$price'),
          trailing: FittedBox(
            fit: BoxFit.fill,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      cardProvider.addOrRemoveQuantity(
                        id: productId,
                        isForAdd: false,
                      );
                    } else if (quantity == 1) {
                      cardProvider
                        ..addOrRemoveQuantity(
                          id: productId,
                          isForAdd: false,
                        )
                        ..removeItem(productId);
                    } else {
                      cardProvider.removeItem(productId);
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  '${quantity.toInt()}',
                ),
                IconButton(
                  onPressed: () {
                    cardProvider.addOrRemoveQuantity(
                      id: productId,
                      isForAdd: true,
                    );
                  },
                  icon: const Icon(Icons.add_circle),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
