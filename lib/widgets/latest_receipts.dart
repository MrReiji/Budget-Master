import 'package:flutter/material.dart';

import '../models/order.dart';
import '../utils/constants.dart';
import 'receipt_card.dart';

class LatestReceipts extends StatelessWidget {
  final List<Order> receipts = [
    Order(
      id: 507,
      deliveryAddress: "New Times Square",
      arrivalDate: DateTime(2020, 1, 23),
      placedDate: DateTime(2020, 1, 17),
      status: OrderStatus.DELIVERING,
    ),
    Order(
      id: 536,
      deliveryAddress: "Victoria Square",
      arrivalDate: DateTime(2020, 1, 21),
      placedDate: DateTime(2020, 1, 19),
      status: OrderStatus.PICKING_UP,
    ),
    Order(
      id: 507,
      deliveryAddress: "New Times Square",
      arrivalDate: DateTime(2020, 1, 23),
      placedDate: DateTime(2020, 1, 17),
      status: OrderStatus.DELIVERING,
    ),
    Order(
      id: 536,
      deliveryAddress: "Victoria Square",
      arrivalDate: DateTime(2020, 1, 21),
      placedDate: DateTime(2020, 1, 19),
      status: OrderStatus.PICKING_UP,
    ),
    Order(
      id: 507,
      deliveryAddress: "New Times Square",
      arrivalDate: DateTime(2020, 1, 23),
      placedDate: DateTime(2020, 1, 17),
      status: OrderStatus.DELIVERING,
    ),
    Order(
      id: 536,
      deliveryAddress: "Victoria Square",
      arrivalDate: DateTime(2020, 1, 21),
      placedDate: DateTime(2020, 1, 19),
      status: OrderStatus.PICKING_UP,
    ),
    Order(
      id: 507,
      deliveryAddress: "New Times Square",
      arrivalDate: DateTime(2020, 1, 23),
      placedDate: DateTime(2020, 1, 17),
      status: OrderStatus.DELIVERING,
    ),
    Order(
      id: 536,
      deliveryAddress: "Victoria Square",
      arrivalDate: DateTime(2020, 1, 21),
      placedDate: DateTime(2020, 1, 19),
      status: OrderStatus.PICKING_UP,
    ),
    Order(
      id: 507,
      deliveryAddress: "New Times Square",
      arrivalDate: DateTime(2020, 1, 23),
      placedDate: DateTime(2020, 1, 17),
      status: OrderStatus.DELIVERING,
    ),
    Order(
      id: 536,
      deliveryAddress: "Victoria Square",
      arrivalDate: DateTime(2020, 1, 21),
      placedDate: DateTime(2020, 1, 19),
      status: OrderStatus.PICKING_UP,
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Latest Receipts",
                  style: TextStyle(
                    color: Color.fromRGBO(19, 22, 33, 1),
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  "Filter by",
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              // Lets pass the order to a new widget and render it there
              return ReceiptCard(
                order: receipts[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 15.0,
              );
            },
            itemCount: receipts.length,
          )
          // Let's create an order model
        ],
      ),
    );
  }
}
