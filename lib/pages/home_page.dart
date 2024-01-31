import 'package:flutter/material.dart';

import 'package:budget_master/constants/constants.dart';
import 'package:budget_master/models/filter_options.dart';
import 'package:budget_master/utils/firebase/getCurrentUsername.dart';
import 'package:budget_master/widgets/receipts/latest_receipts.dart';
import 'package:budget_master/widgets/receipts/sort_receipts_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedFilter;
  FilterOption filterOption = FilterOption.purchaseDate;
  SortDirection sortDirection = SortDirection.descending;

  void _updateFilterOption(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter.contains("Purchase Date")) {
        filterOption = FilterOption.purchaseDate;
      } else {
        filterOption = FilterOption.totalPrice;
      }
      sortDirection = filter.contains("Asc")
          ? SortDirection.ascending
          : SortDirection.descending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filterItems = [
      'Purchase Date Asc',
      'Purchase Date Desc',
      'Total Price Asc',
      'Total Price Desc',
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: kToolbarHeight + 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<String?>(
                  future: getCurrentUsername(),
                  builder: (context, snapshot) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Welcome Back,\n",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          TextSpan(
                            text: "${snapshot.data ?? 'User'}!",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Image.asset("assets/profile.png", scale: 6),
              ],
            ),
          ),
          SizedBox(height: 50.0),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 200.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              color: Constants.scaffoldBackgroundColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Latest Receipts",
                          style: TextStyle(
                            color: Color.fromRGBO(19, 22, 33, 1),
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Flexible(
                        child: SortReceiptsButton(
                          items: filterItems,
                          selectedValue: selectedFilter,
                          onChanged: (value) {
                            if (value != null) {
                              _updateFilterOption(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                LatestReceipts(
                  filterOption: filterOption,
                  sortDirection: sortDirection,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
