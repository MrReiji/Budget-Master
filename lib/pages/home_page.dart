import 'package:budget_master/utils/constants.dart';
import 'package:budget_master/utils/firebase/getCurrentUsername.dart';
import 'package:budget_master/widgets/latest_receipts.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kToolbarHeight + 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                                        ?.copyWith(
                                          color: Colors.white,
                                        ),
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
                                  )
                                ],
                              ),
                            );
                          }),
                      Image.asset(
                        "assets/profile.png",
                        scale: 6,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
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
              padding: EdgeInsets.symmetric(
                vertical: 24.0,
              ),
              child: LatestReceipts(),
            )
          ],
        ),
      ),
    );
  }
}
