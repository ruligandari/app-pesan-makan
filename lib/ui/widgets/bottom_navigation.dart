import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kedai_1818/ui/pages/home.dart';
import 'package:kedai_1818/ui/pages/profile.dart';
import 'package:kedai_1818/ui/pages/riwayat.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final List<Widget> _children = [HomePage(), Riwayat(), Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/icons/home.png')),
                label: '',
                activeIcon: Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/icons/home_active.png'))),
            BottomNavigationBarItem(
                icon: Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/icons/cart.png')),
                label: '',
                activeIcon: Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/icons/cart_active.png'))),
            BottomNavigationBarItem(
                icon: Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/icons/profile.png')),
                label: '',
                activeIcon: Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/icons/profile_active.png'))),
          ],
        ));
  }
}
