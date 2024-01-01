import 'package:budget_master/blocs/form_blocs/expense_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:go_router/go_router.dart';

import '../utils/constants.dart';
import '../utils/navigation/app_router_paths.dart';
import '../widgets/app_button.dart';
import '../widgets/input_widget.dart';
import '../widgets/loading_dialog.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseFormBloc(),
      child: Builder(builder: (context) {
        final receiptFormBloc = context.read<ExpenseFormBloc>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Constants.primaryColor,
          body: FormBlocListener<ExpenseFormBloc, String, String>(
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                              ),
                              Text(
                                "Enter your expense!",
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
                        SizedBox(
                          height: 40.0,
                        ),
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height - 180.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InputWidget(
                                  topLabel: "Name",
                                  hintText: "Enter your expense name",
                                  prefixIcon: Icons.apple,
                                  textFieldBloc: receiptFormBloc.productName,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                InputWidget(
                                  topLabel: "Price",
                                  hintText: "Enter your expense price",
                                  prefixIcon: Icons.attach_money_rounded,
                                  textInputType: TextInputType.number,
                                  autofillHints: const [
                                    AutofillHints.transactionAmount,
                                  ],
                                  textFieldBloc: receiptFormBloc.price,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                InputWidget(
                                  topLabel: "Store",
                                  hintText:
                                      "Enter the store name where the purchase was made",
                                  prefixIcon: Icons.store,
                                  textInputType: TextInputType.streetAddress,
                                  autofillHints: const [
                                    AutofillHints.location,
                                  ],
                                  textFieldBloc: receiptFormBloc.store,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                InputWidget(
                                  topLabel: "Date of purchase",
                                  hintText: "Enter the date of purchase",
                                  textInputType: TextInputType.datetime,
                                  prefixIcon: Icons.date_range_rounded,
                                  textFieldBloc: receiptFormBloc.purchaseDate,
                                ),
                                InputWidget(
                                  topLabel: "Category",
                                  hintText: "Enter the expense categories",
                                  textInputType: TextInputType.datetime,
                                  prefixIcon: Icons.date_range_rounded,
                                  textFieldBloc: receiptFormBloc.store,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                InputWidget(
                                  topLabel: "Description",
                                  hintText: "Enter description if needed",
                                  textInputType: TextInputType.text,
                                  prefixIcon: Icons.description_rounded,
                                  textFieldBloc: receiptFormBloc.description,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                AppButton(
                                  type: ButtonType.PRIMARY,
                                  text: "Add expense!",
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
