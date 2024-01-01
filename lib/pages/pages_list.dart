import 'package:budget_master/pages/add_expense_page.dart';
import 'package:budget_master/pages/home_page.dart';
import 'package:budget_master/pages/settings_page.dart';
import 'package:flutter/material.dart';

//Corresponds to the indexes in CurvedNavigationBar on HomeScreen

List<Widget> pagesList = [
  const HomePage(), // For index 0
  const HomePage(), // For index 1
  const AddExpensePage(), // For index 2
  const HomePage(), // For index 3
  const SettingsPage(), // For index 4
];
