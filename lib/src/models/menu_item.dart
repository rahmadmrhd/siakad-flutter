import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  Widget? screen;

  MenuItem({
    required this.title,
    required this.icon,
    this.screen,
  });
}
