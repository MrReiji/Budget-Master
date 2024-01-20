import 'package:budget_master/pages/add_receipt_page.dart';
import 'package:budget_master/pages/home_page.dart';
import 'package:budget_master/pages/settings_page.dart';
import 'package:flutter/material.dart';

class PageManager {
  static final List<Widget> _pages = [
    const HomePage(), // For index 0
    const AddReceiptPage(), // For index 1
    const AddReceiptPage(), // For index 2
    const SettingsPage(), // For index 3
  ];

  // Static method to get pages
  static List<Widget> getPages() {
    return _pages;
  }
}
