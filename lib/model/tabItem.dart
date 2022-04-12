import 'package:flutter/material.dart';

class TabItem {
  final String? name;
  final IconData? iconData;

  TabItem({this.name, this.iconData});
}

List<TabItem> tabItems = [
  TabItem(
    name: "Dashboard",
    iconData: Icons.dashboard_rounded,
  ),
  TabItem(
    name: "Accounting",
    iconData: Icons.paid_outlined,
  ),
  TabItem(
    name: "Reports",
    iconData: Icons.receipt_long_outlined,
  ),
  TabItem(
    name: "Messages",
    iconData: Icons.question_answer_outlined,
  ),
  TabItem(
    name: "Tasks",
    iconData: Icons.check_box_outlined,
  ),
  TabItem(
    name: "More",
    iconData: Icons.more_horiz_rounded,
  ),
];