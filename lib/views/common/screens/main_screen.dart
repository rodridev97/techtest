import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:techtest/views/contact/providers/contact_provider.dart';

import '../../contact/contact.dart' show ContactScreen;
import '../../user/user.dart' show UserScreen;

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  static const String routeName = '/main';

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 1:
          ref.refresh(contactProvider.future);
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          UserScreen(),
          ContactScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(FontAwesomeIcons.solidCircleUser),
            icon: Icon(FontAwesomeIcons.circleUser),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(FontAwesomeIcons.solidAddressBook),
            icon: Icon(FontAwesomeIcons.addressBook),
            label: 'Contactos',
          )
        ],
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
