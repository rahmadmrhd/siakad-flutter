import 'package:flutter/material.dart';
import 'package:siakad/src/page/profile_page.dart';

import '../models/menu_item.dart';
import 'mata_kuliah_page.dart';
import 'nilai_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final List<MenuItem> _menuItem;

  _HomePageState() {
    _menuItem = [
      MenuItem(
        icon: Icons.class_rounded,
        title: 'Mata Kuliah',
        screen: const MataKuliahPage(),
      ),
      MenuItem(
        icon: Icons.bar_chart,
        title: 'Nilai',
        screen: const NilaiPage(),
      ),
      MenuItem(
        icon: Icons.account_circle_rounded,
        title: 'Profil',
        screen: ProfilePage(
          onBack: toBack,
        ),
      ),
    ];
  }
  void toBack() {
    _tabController.index = 0;
  }

  // ignore: unused_field
  late String _currentTitle;

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _currentTitle = _menuItem[0].title;
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_tabOnChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_tabOnChanged);
    _tabController.dispose();
  }

  void _tabOnChanged() {
    setState(() {
      _currentTitle = _menuItem[_tabController.index].title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   foregroundColor: Theme.of(context).colorScheme.onPrimary,
        //   title: Text(_currentTitle),
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabController.index,
          items: _menuItem.map(
            (item) {
              return BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.title,
              );
            },
          ).toList(),
          onTap: (index) {
            _tabController.animateTo(index);
          },
        ),
        body: TabBarView(
          controller: _tabController,
          children: _menuItem.map((item) {
            return item.screen ?? const Placeholder();
          }).toList(),
        ),
      ),
    );
  }
}
