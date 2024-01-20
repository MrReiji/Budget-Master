import 'package:budget_master/widgets/forms/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:budget_master/blocs/form_blocs/receipt_form_block.dart';

//Used in AddReceiptPage

class ProductCard extends StatelessWidget {
  final int productIndex;
  final ProductFieldBloc productField;

  final VoidCallback onRemoveProduct;

  const ProductCard({
    super.key,
    required this.productIndex,
    required this.productField,
    required this.onRemoveProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              child: InputWidget(
                height: 10,
                hintText: "Name",
                fieldBloc: productField.productName,
              ),
            ),
          ),
          SizedBox(width: 5.0),
          Flexible(
            flex: 1,
            child: Container(
              child: InputWidget(
                height: 10,
                hintText: "\$",
                textInputType: TextInputType.number,
                fieldBloc: productField.price,
              ),
            ),
          ),
          Container(
            child: IconButton(
              alignment: Alignment.center,
              icon: const Icon(Icons.delete),
              onPressed: onRemoveProduct,
            ),
          ),
        ],
      ),
    );
  }
}
