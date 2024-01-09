import 'package:budget_master/blocs/form_blocs/receipt_form_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';
import '../utils/navigation/app_router_paths.dart';
import '../widgets/ui_elements/app_button.dart';
import '../widgets/forms/input_widget.dart';
import '../widgets/dialogs/loading_dialog.dart';

class AddReceiptPage extends StatelessWidget {
  const AddReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReceiptFormBlock(),
      child: Builder(builder: (context) {
        final receiptFormBloc = context.read<ReceiptFormBlock>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Constants.primaryColor,
          body: FormBlocListener<ReceiptFormBlock, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) {
              LoadingDialog.hide(context);
            },
            onSuccess: (context, state) {
              LoadingDialog.hide(context);

              context.push(AppRouterPaths.home);
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failureResponse!)));
            },
            child: SafeArea(
              bottom: false,
              child: Container(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 35,
                              ),
                              Text(
                                "Enter your expenses or add photo of the receipt!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height - 180.0,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InputWidget(
                                  topLabel: "Store Name",
                                  hintText: "Store Name",
                                  prefixIcon: Icons.apple,
                                  textFieldBloc: receiptFormBloc.storeName,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                InputWidget(
                                  topLabel: "Date of purchase",
                                  hintText: "Enter the date of purchase",
                                  textInputType: TextInputType.datetime,
                                  prefixIcon: Icons.date_range_rounded,
                                  textFieldBloc: receiptFormBloc.purchaseDate,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                InputWidget(
                                  topLabel: "Category",
                                  hintText: "Enter the expense category",
                                  textInputType: TextInputType.text,
                                  prefixIcon: Icons.category_outlined,
                                  textFieldBloc: receiptFormBloc.category,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                InputWidget(
                                  topLabel: "Description",
                                  hintText: "Enter description if needed",
                                  textInputType: TextInputType.text,
                                  prefixIcon: Icons.description_rounded,
                                  textFieldBloc: receiptFormBloc.description,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                BlocBuilder<
                                    ListFieldBloc<ProductFieldBloc, dynamic>,
                                    ListFieldBlocState<ProductFieldBloc,
                                        dynamic>>(
                                  bloc: receiptFormBloc.product,
                                  builder: (context, state) {
                                    if (state.fieldBlocs.isNotEmpty) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: state.fieldBlocs.length,
                                        itemBuilder: (context, i) {
                                          return ProductCard(
                                            productIndex: i,
                                            productField: state.fieldBlocs[i],
                                            onRemoveProduct: () =>
                                                receiptFormBloc
                                                    .removeProduct(i),
                                          );
                                        },
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: receiptFormBloc.addProduct,
                                      child: const Text('Add product'),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 1.0,
                                          width: 100.0,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 4.0),
                                        const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'and/or',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'Add receipt photo',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 4.0),
                                        Container(
                                          height: 1.0,
                                          width: 100.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: null, //TODO addPhoto
                                          child: Text('From gallery'),
                                        ),
                                        ElevatedButton(
                                          onPressed: null, //TODO addPhoto
                                          child: Text('Using camera'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 1.0,
                                          width: 270.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                AppButton(
                                  type: ButtonType.PRIMARY,
                                  text: "Add expenses!",
                                  onPressed: () {
                                    receiptFormBloc.submit();
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

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
    return Card(
      color: Constants.primaryColor,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Product #${productIndex + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveProduct,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldBlocBuilder(
                      textFieldBloc: productField.productName,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldBlocBuilder(
                      textFieldBloc: productField.price,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
