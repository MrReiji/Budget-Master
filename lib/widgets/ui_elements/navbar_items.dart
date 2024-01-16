import 'package:flutter/material.dart';

class NavBarItems {
  static List<Icon> createItems(int activeIndex) {
    return [
      _createNavItem(
        Icons.home_rounded,
        activeIndex == 0,
      ),
      _createNavItem(
        Icons.add,
        activeIndex == 1,
      ),
      _createNavItem(
        Icons.insert_chart_outlined_rounded,
        activeIndex == 2,
      ),
      _createNavItem(
        Icons.settings,
        activeIndex == 3,
      ),
    ];
  }

  static Icon _createNavItem(IconData icon, bool isActive) {
    return Icon(
      icon,
      size: 30.0,
      color: isActive ? Colors.white : Color(0xFFC8C9CB),
    );
  }
}
