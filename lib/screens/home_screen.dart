import 'package:budget_master/pages/Pages_list.dart';
import 'package:budget_master/pages/home_page.dart';
import 'package:budget_master/utils/firebase/getCurrentUsername.dart';
import 'package:budget_master/utils/navigation/app_router_paths.dart';
import 'package:budget_master/widgets/latest_receipts.dart';
import 'package:budget_master/widgets/navbar_items.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.scaffoldBackgroundColor,
        buttonBackgroundColor: Constants.primaryColor,
        items: NavBarItems.createItems(activeIndex),
        onTap: (index) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
      backgroundColor: Constants.primaryColor,
      body: IndexedStack(
        index: activeIndex,
        children: pagesList,
      ),
    );
  }
}
