import 'package:flutter/material.dart';
import 'package:selendra_marketplace_app/all_export.dart';
import 'package:selendra_marketplace_app/ui/screens/checkout/components/item_order.dart';

class ProductDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) => Container(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Order',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                value.items.length > 1
                    ? InkWell(
                        onTap: () {
                          showBottomSheet(
                            context: context,
                            shape: kDefaultShape,
                            builder: (context) => Container(
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: kDefaultColor,
                                      ),
                                    ),
                                    title: Text(
                                      'Your Order',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: ListView.builder(
                                        itemCount: value.items.length,
                                        itemBuilder: (context, index) =>
                                            ChangeNotifierProvider.value(
                                          value: value.items.values
                                              .toList()[index],
                                          child: ItemOrder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.grey,
                        child: Text('See all'),
                      )
                    : Container(),
              ],
            ),
          ),
          ChangeNotifierProvider.value(
            value: value.items.values.toList()[0],
            child: ItemOrder(),
          ),
          // Card(
          //   elevation: 0,
          //   shape: kDefaultShape,
          //   child: Container(
          //     height: 100,
          //     width: MediaQuery.of(context).size.width,
          //     margin: EdgeInsets.all(10.0),
          //     child: Row(
          //       children: [
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(kDefaultRadius),
          //           child: Container(
          //             width: 100,
          //             height: 100,
          //             decoration: BoxDecoration(
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Colors.grey[300],
          //                   spreadRadius: 5.0,
          //                   blurRadius: 5.0,
          //                 ),
          //               ],
          //             ),
          //             child: Image.network(value.items.values.toList()[0].image,
          //                 fit: BoxFit.cover),
          //           ),
          //         ),

          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Container(
          //               height: 20,
          //               width: MediaQuery.of(context).size.width / 2,
          //               child: ListTile(
          //                 title: Text(
          //                   value.items.values.toList()[0].title,
          //                   style: TextStyle(fontWeight: FontWeight.bold),
          //                 ),
          //                 isThreeLine: true,
          //                 subtitle: Text(
          //                     'Qty: ${value.items.values.toList()[0].qty}'),
          //               ),
          //             ),
          //             SizedBox(
          //               height: 10,
          //             ),
          //             Container(
          //               height: 20,
          //               width: MediaQuery.of(context).size.width / 2,
          //               child: ListTile(
          //                 subtitle: Text(
          //                   'Price: ${value.items.values.toList()[0].price}៛ ',
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     color: kDefaultColor,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),

          //         // Container(
          //         //   child: ListTile(
          //         //     title: Text(value.items.values.toList()[0].title),
          //         //     subtitle: Text(value.items.values.toList()[0].price),
          //         //   ),
          //         // )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      )),
    );
  }
}
