import 'package:flutter/material.dart';
import 'package:inventify/screens/Home.dart';
import 'package:inventify/screens/category.dart';
import 'package:inventify/screens/profile.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

int _selectedIndex = 0;

class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Theme.of(context).colorScheme.background,
        body: _getBody(), 
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return    Home();
      case 1:
        return const Categories();
      case 2:
        return const Profile();
      default:
        return Container();
    }
  }
}
