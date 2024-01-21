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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
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
          Expanded(
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
            child: Column(
              children: [
                SizedBox(height: 10.0),
                Container(
                  height: 60,
                  child: IconButton(
                    alignment: Alignment.center,
                    icon: const Icon(Icons.delete),
                    onPressed: onRemoveProduct,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
