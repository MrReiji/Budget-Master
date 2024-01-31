import 'package:flutter/material.dart';

/// Represents a collection of navigation bar items.
class NavBarItems {
  /// Creates a list of navigation bar items based on the active index.
  ///
  /// The [activeIndex] parameter specifies the index of the currently active item.
  /// Returns a list of [Icon] widgets representing the navigation bar items.
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

  /// Creates a navigation bar item with the specified icon and active state.
  ///
  /// - The [icon] parameter specifies the icon data for the item.
  /// - The [isActive] parameter indicates whether the item is currently active.
  ///
  /// Returns an [Icon] widget representing the navigation bar item.
  static Icon _createNavItem(IconData icon, bool isActive) {
    return Icon(
      icon,
      size: 30.0,
      color: isActive ? Colors.white : Color(0xFFC8C9CB),
    );
  }
}
